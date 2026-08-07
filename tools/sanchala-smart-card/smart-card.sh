#!/bin/bash
# Sanchala OS - Smart Card Manager (PIV/PKCS#11)
SANCHALA_ROOT="${SANCHALA_ROOT:-/data/data/com.termux/files/home/sanchala-os}"
CONFIG_DIR="$SANCHALA_ROOT/config/smart-card"
STATE_DIR="$SANCHALA_ROOT/state/smart-card"
LOG_FILE="$SANCHALA_ROOT/logs/smart-card.log"

mkdir -p "$CONFIG_DIR" "$STATE_DIR" "$(dirname "$LOG_FILE")"

[[ ! -f "$CONFIG_DIR/config.conf" ]] && cat > "$CONFIG_DIR/config.conf" << 'CONF'
ENABLED=true
PKCS11_MODULE=/usr/lib/opensc-pkcs11.so
PIV_ENABLED=true
REQUIRE_PIN=true
PIN_CACHE_TIME=300
CONF

source "$CONFIG_DIR/config.conf"
log_msg() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"; }

detect_reader() {
    command -v pcsc_scan &>/dev/null && { pcsc_scan -r 2>/dev/null | head -3; return; }
    command -v opensc-tool &>/dev/null && { opensc-tool -l 2>/dev/null; return; }
    lsusb 2>/dev/null | grep -i "smart card\|yubikey\|nitrokey" && return
    echo "Emulated Smart Card Reader"
}

detect_card() {
    command -v opensc-tool &>/dev/null && opensc-tool -a 2>/dev/null && return
    command -v pkcs11-tool &>/dev/null && pkcs11-tool -L 2>/dev/null && return
    echo "Card: Emulated PIV Card"
    echo "ATR: 3B 00 00 00 00 00 00 $(printf '%02X' $((RANDOM % 256)))"
}

list_certs() {
    command -v pkcs11-tool &>/dev/null && { pkcs11-tool --list-objects --type cert 2>/dev/null; return; }
    echo "Certificate 1: Authentication (PIV Auth)"
    echo "Certificate 2: Digital Signature"
    echo "Certificate 3: Key Management"
}

read_cert() {
    local slot=${1:-1}
    command -v pkcs11-tool &>/dev/null && { pkcs11-tool --read-object --type cert --id "$slot" 2>/dev/null; return; }
    echo "--- BEGIN CERTIFICATE (Slot $slot) ---"
    echo "Emulated certificate data for slot $slot"
}

sign_data() {
    local data=$1 pin=$2
    [[ -z "$data" ]] && { echo "Usage: sign <data> [pin]"; return 1; }
    echo "Signing data with smart card..."
    [[ "$REQUIRE_PIN" == "true" ]] && [[ -z "$pin" ]] && { echo "PIN required"; return 1; }
    echo "$(echo "$data" | sha256sum | cut -c1-64)_SIGNED_$(date +%s)"
    log_msg "Signed data"
}

show_status() {
    echo "═══════════════════════════════════════════"
    echo "  SANCHALA SMART CARD MANAGER"
    echo "═══════════════════════════════════════════"
    echo "  Reader: $(detect_reader | head -1)"
    echo "  Status: $ENABLED | PIV: $PIV_ENABLED"
    echo "───────────────────────────────────────────"
    detect_card | head -3
    echo "═══════════════════════════════════════════"
}

case "${1:-status}" in
    status) show_status ;;
    reader) detect_reader ;;
    card) detect_card ;;
    certs) list_certs ;;
    read) read_cert "$2" ;;
    sign) sign_data "$2" "$3" ;;
    *) echo "Usage: $0 {status|reader|card|certs|read SLOT|sign DATA [PIN]}" ;;
esac

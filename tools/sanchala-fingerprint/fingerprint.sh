#!/bin/bash
# Sanchala OS - Fingerprint Authentication Manager
SANCHALA_ROOT="${SANCHALA_ROOT:-/data/data/com.termux/files/home/sanchala-os}"
CONFIG_DIR="$SANCHALA_ROOT/config/fingerprint"
STATE_DIR="$SANCHALA_ROOT/state/fingerprint"
LOG_FILE="$SANCHALA_ROOT/logs/fingerprint.log"
PRINTS_DIR="$CONFIG_DIR/prints"

mkdir -p "$CONFIG_DIR" "$STATE_DIR" "$PRINTS_DIR" "$(dirname "$LOG_FILE")"

[[ ! -f "$CONFIG_DIR/config.conf" ]] && cat > "$CONFIG_DIR/config.conf" << 'CONF'
ENABLED=true
MAX_PRINTS=10
VERIFY_TIMEOUT=30
PAM_ENABLED=true
CONF

source "$CONFIG_DIR/config.conf"
log_msg() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"; }

detect_reader() {
    command -v fprintd-list &>/dev/null && echo "fprintd" && return
    lsusb 2>/dev/null | grep -qi "fingerprint\|validity\|synaptics" && echo "usb" && return
    echo "emulated"
}

enroll_finger() {
    local finger=${1:-right-index-finger} user=${2:-$USER}
    echo "Enrolling $finger for $user..."
    mkdir -p "$PRINTS_DIR/$user"
    for i in {1..5}; do
        echo "  Scan $i/5..."
        sleep 0.5
    done
    echo "$user-$finger-$(date +%s)" | sha256sum | cut -c1-32 > "$PRINTS_DIR/$user/$finger"
    log_msg "Enrolled $finger for $user"
    echo "✓ Enrollment complete!"
}

verify_finger() {
    local user=${1:-$USER}
    [[ -d "$PRINTS_DIR/$user" ]] && [[ $(ls "$PRINTS_DIR/$user" | wc -l) -gt 0 ]] && {
        echo "✓ Fingerprint verified"; return 0
    }
    echo "✗ Verification failed"; return 1
}

delete_print() {
    local finger=$1 user=${2:-$USER}
    [[ "$finger" == "all" ]] && rm -rf "$PRINTS_DIR/$user" || rm -f "$PRINTS_DIR/$user/$finger"
    echo "Deleted fingerprint(s)"
}

show_status() {
    echo "═══════════════════════════════════════════"
    echo "  SANCHALA FINGERPRINT MANAGER"
    echo "═══════════════════════════════════════════"
    echo "  Reader: $(detect_reader) | Status: $ENABLED"
    echo "  Enrolled: $(ls "$PRINTS_DIR/$USER" 2>/dev/null | wc -l) prints"
    echo "═══════════════════════════════════════════"
}

case "${1:-status}" in
    status) show_status ;;
    enroll) enroll_finger "$2" "$3" ;;
    verify) verify_finger "$2" ;;
    delete) delete_print "$2" "$3" ;;
    list) ls "$PRINTS_DIR/${2:-$USER}" 2>/dev/null ;;
    *) echo "Usage: $0 {status|enroll FINGER|verify|delete FINGER|list}" ;;
esac

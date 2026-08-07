#!/bin/bash
# Sanchala OS - Thunderbolt Device Management
# PCIe tunneling, security, and device authorization

SANCHALA_ROOT="${SANCHALA_ROOT:-/data/data/com.termux/files/home/sanchala-os}"
CONFIG_DIR="$SANCHALA_ROOT/config/thunderbolt"
STATE_DIR="$SANCHALA_ROOT/state/thunderbolt"
LOG_FILE="$SANCHALA_ROOT/logs/thunderbolt.log"
TB_PATH="/sys/bus/thunderbolt/devices"

mkdir -p "$CONFIG_DIR" "$STATE_DIR" "$(dirname "$LOG_FILE")"

[[ ! -f "$CONFIG_DIR/config.conf" ]] && cat > "$CONFIG_DIR/config.conf" << 'CONF'
SECURITY_LEVEL=user
AUTO_AUTHORIZE=false
TRUSTED_DEVICES_FILE=trusted_devices.list
PCIE_TUNNELING=enabled
DP_TUNNELING=enabled
USB_TUNNELING=enabled
CONF

source "$CONFIG_DIR/config.conf"
log_msg() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"; }

detect_devices() {
    local devices=()
    if [[ -d "$TB_PATH" ]]; then
        for dev in "$TB_PATH"/*-*; do
            [[ -d "$dev" ]] && devices+=("$(basename "$dev")")
        done
    fi
    [[ ${#devices[@]} -eq 0 ]] && devices+=("emulated-tb0")
    printf '%s\n' "${devices[@]}"
}

get_device_info() {
    local dev=$1 path="$TB_PATH/$dev"
    if [[ -d "$path" ]]; then
        local name=$(cat "$path/device_name" 2>/dev/null || echo "Unknown")
        local vendor=$(cat "$path/vendor_name" 2>/dev/null || echo "Unknown")
        local auth=$(cat "$path/authorized" 2>/dev/null || echo 0)
        local uuid=$(cat "$path/unique_id" 2>/dev/null || echo "N/A")
        echo "$name,$vendor,$auth,$uuid"
    else
        echo "Emulated TB Device,Sanchala,1,$(uuidgen 2>/dev/null || echo "emu-$(date +%s)")"
    fi
}

authorize_device() {
    local dev=$1 path="$TB_PATH/$dev"
    if [[ -f "$path/authorized" ]]; then
        echo 1 > "$path/authorized" 2>/dev/null
        log_msg "Authorized device: $dev"
        echo "Device $dev authorized"
    else
        echo "1" > "$STATE_DIR/${dev}_authorized"
        echo "Device $dev authorized (emulated)"
    fi
}

deauthorize_device() {
    local dev=$1 path="$TB_PATH/$dev"
    if [[ -f "$path/authorized" ]]; then
        echo 0 > "$path/authorized" 2>/dev/null
        log_msg "Deauthorized device: $dev"
    fi
    rm -f "$STATE_DIR/${dev}_authorized"
    echo "Device $dev deauthorized"
}

trust_device() {
    local dev=$1
    IFS=',' read -r name vendor auth uuid <<< "$(get_device_info "$dev")"
    echo "$uuid $name" >> "$CONFIG_DIR/$TRUSTED_DEVICES_FILE"
    sort -u "$CONFIG_DIR/$TRUSTED_DEVICES_FILE" -o "$CONFIG_DIR/$TRUSTED_DEVICES_FILE"
    authorize_device "$dev"
    log_msg "Trusted device: $dev ($uuid)"
    echo "Device $dev added to trusted list"
}

is_trusted() {
    local dev=$1
    IFS=',' read -r name vendor auth uuid <<< "$(get_device_info "$dev")"
    grep -q "^$uuid" "$CONFIG_DIR/$TRUSTED_DEVICES_FILE" 2>/dev/null
}

set_security_level() {
    local level=$1
    case "$level" in
        none|user|secure|dponly)
            [[ -f /sys/bus/thunderbolt/devices/domain0/security ]] && \
                echo "$level" > /sys/bus/thunderbolt/devices/domain0/security 2>/dev/null
            sed -i "s/SECURITY_LEVEL=.*/SECURITY_LEVEL=$level/" "$CONFIG_DIR/config.conf"
            log_msg "Security level set to: $level"
            echo "Security level: $level" ;;
        *) echo "Valid levels: none, user, secure, dponly" ;;
    esac
}

show_status() {
    echo "═══════════════════════════════════════════"
    echo "  SANCHALA THUNDERBOLT MANAGER"
    echo "═══════════════════════════════════════════"
    echo "  Security Level: $SECURITY_LEVEL"
    echo "  Auto-Authorize: $AUTO_AUTHORIZE"
    echo "───────────────────────────────────────────"
    echo "  Connected Devices:"
    for dev in $(detect_devices); do
        IFS=',' read -r name vendor auth uuid <<< "$(get_device_info "$dev")"
        local status="[UNAUTHORIZED]"
        [[ "$auth" == "1" ]] && status="[AUTHORIZED]"
        is_trusted "$dev" && status="[TRUSTED]"
        printf "  %-20s %s\n" "$name" "$status"
        echo "    Vendor: $vendor | ID: ${uuid:0:8}..."
    done
    echo "═══════════════════════════════════════════"
}

monitor_devices() {
    log_msg "Starting device monitor"
    echo "Monitoring Thunderbolt devices (Ctrl+C to stop)..."
    while true; do
        for dev in $(detect_devices); do
            if is_trusted "$dev" && [[ "$AUTO_AUTHORIZE" == "true" ]]; then
                authorize_device "$dev" >/dev/null
            fi
        done
        sleep 2
    done
}

case "${1:-status}" in
    status) show_status ;;
    list) detect_devices ;;
    info) get_device_info "$2" ;;
    auth) authorize_device "$2" ;;
    deauth) deauthorize_device "$2" ;;
    trust) trust_device "$2" ;;
    security) set_security_level "$2" ;;
    monitor) monitor_devices ;;
    *) echo "Usage: $0 {status|list|info DEV|auth DEV|deauth DEV|trust DEV|security LEVEL|monitor}" ;;
esac

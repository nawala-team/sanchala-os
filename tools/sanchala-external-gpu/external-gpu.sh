#!/bin/bash
# Sanchala OS - External GPU (eGPU) Manager
SANCHALA_ROOT="${SANCHALA_ROOT:-/data/data/com.termux/files/home/sanchala-os}"
CONFIG_DIR="$SANCHALA_ROOT/config/external-gpu"
STATE_DIR="$SANCHALA_ROOT/state/external-gpu"
LOG_FILE="$SANCHALA_ROOT/logs/external-gpu.log"

mkdir -p "$CONFIG_DIR" "$STATE_DIR" "$(dirname "$LOG_FILE")"

[[ ! -f "$CONFIG_DIR/config.conf" ]] && cat > "$CONFIG_DIR/config.conf" << 'CONF'
AUTO_SWITCH=true
HOT_PLUG=true
PREFER_EGPU=false
POWER_MANAGEMENT=balanced
CONF

source "$CONFIG_DIR/config.conf"
log_msg() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"; }

detect_egpu() {
    # Check Thunderbolt GPU
    for dev in /sys/bus/thunderbolt/devices/*/device; do
        [[ -f "$dev" ]] && grep -qi "gpu\|graphics\|nvidia\|amd" "$dev" 2>/dev/null && {
            dirname "$dev" | xargs basename; return
        }
    done
    # Check PCIe external
    lspci 2>/dev/null | grep -i "vga\|3d\|display" | grep -vi "integrated\|intel" | head -1 && return
    cat "$STATE_DIR/egpu_device" 2>/dev/null || echo "none"
}

get_egpu_info() {
    local egpu=$(detect_egpu)
    [[ "$egpu" == "none" ]] && { echo "No eGPU detected"; return; }
    echo "Device: $egpu"
    # Try to get details
    if command -v nvidia-smi &>/dev/null; then
        nvidia-smi --query-gpu=name,memory.total,driver_version --format=csv,noheader 2>/dev/null
    elif [[ -d /sys/class/drm/card1 ]]; then
        echo "AMD/Intel eGPU detected"
        cat /sys/class/drm/card1/device/vendor 2>/dev/null
    else
        echo "Generic eGPU | Power: $POWER_MANAGEMENT"
    fi
}

authorize_egpu() {
    local dev=${1:-$(detect_egpu)}
    [[ "$dev" == "none" ]] && { echo "No eGPU to authorize"; return 1; }
    local auth_path="/sys/bus/thunderbolt/devices/$dev/authorized"
    [[ -f "$auth_path" ]] && echo 1 > "$auth_path" 2>/dev/null
    echo "$dev" > "$STATE_DIR/egpu_device"
    log_msg "Authorized eGPU: $dev"
    echo "eGPU authorized: $dev"
}

switch_gpu() {
    local target=$1
    case "$target" in
        egpu|external)
            echo "Switching to eGPU..."
            # Set environment for prime-run or similar
            echo "DRI_PRIME=1" > "$STATE_DIR/gpu_env"
            export DRI_PRIME=1
            log_msg "Switched to eGPU" ;;
        igpu|internal|integrated)
            echo "Switching to integrated GPU..."
            echo "DRI_PRIME=0" > "$STATE_DIR/gpu_env"
            export DRI_PRIME=0
            log_msg "Switched to iGPU" ;;
        auto)
            [[ "$(detect_egpu)" != "none" ]] && switch_gpu egpu || switch_gpu igpu ;;
    esac
}

safe_disconnect() {
    local egpu=$(detect_egpu)
    [[ "$egpu" == "none" ]] && { echo "No eGPU connected"; return; }
    echo "Preparing safe disconnect..."
    switch_gpu igpu
    sleep 1
    # Try to power down
    [[ -f "/sys/bus/thunderbolt/devices/$egpu/authorized" ]] && \
        echo 0 > "/sys/bus/thunderbolt/devices/$egpu/authorized" 2>/dev/null
    rm -f "$STATE_DIR/egpu_device"
    log_msg "Safe disconnect: $egpu"
    echo "✓ Safe to disconnect eGPU"
}

show_status() {
    local egpu=$(detect_egpu)
    local active=$(cat "$STATE_DIR/gpu_env" 2>/dev/null | grep -oP 'DRI_PRIME=\K\d' || echo "0")
    echo "═══════════════════════════════════════════"
    echo "  SANCHALA EXTERNAL GPU MANAGER"
    echo "═══════════════════════════════════════════"
    echo "  eGPU: $egpu"
    echo "  Active GPU: $([ "$active" == "1" ] && echo "External" || echo "Integrated")"
    echo "───────────────────────────────────────────"
    echo "  Auto-Switch: $AUTO_SWITCH | Hot-Plug: $HOT_PLUG"
    echo "  Power Mode: $POWER_MANAGEMENT"
    [[ "$egpu" != "none" ]] && { echo "───────────────────────────────────────────"; get_egpu_info; }
    echo "═══════════════════════════════════════════"
}

case "${1:-status}" in
    status) show_status ;;
    detect) detect_egpu ;;
    info) get_egpu_info ;;
    auth) authorize_egpu "$2" ;;
    switch) switch_gpu "${2:-auto}" ;;
    disconnect) safe_disconnect ;;
    *) echo "Usage: $0 {status|detect|info|auth [DEV]|switch egpu/igpu/auto|disconnect}" ;;
esac

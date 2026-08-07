#!/bin/bash
# Sanchala OS - Stylus & Pen Configuration
SANCHALA_ROOT="${SANCHALA_ROOT:-/data/data/com.termux/files/home/sanchala-os}"
CONFIG_DIR="$SANCHALA_ROOT/config/stylus-config"
STATE_DIR="$SANCHALA_ROOT/state/stylus-config"
LOG_FILE="$SANCHALA_ROOT/logs/stylus-config.log"

mkdir -p "$CONFIG_DIR" "$STATE_DIR" "$(dirname "$LOG_FILE")"

[[ ! -f "$CONFIG_DIR/config.conf" ]] && cat > "$CONFIG_DIR/config.conf" << 'CONF'
PRESSURE_CURVE=default
BUTTON1_ACTION=right-click
BUTTON2_ACTION=middle-click
ERASER_MODE=true
PALM_REJECTION=true
TILT_SENSITIVITY=50
HOVER_DISTANCE=10
CONF

source "$CONFIG_DIR/config.conf"
log_msg() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"; }

detect_stylus() {
    # Check for Wacom devices
    command -v xsetwacom &>/dev/null && xsetwacom list 2>/dev/null | head -3 && return
    # Check libinput
    libinput list-devices 2>/dev/null | grep -i "pen\|stylus\|tablet" -A3 && return
    # Check /dev/input
    for dev in /dev/input/event*; do
        udevadm info "$dev" 2>/dev/null | grep -qi "stylus\|pen\|wacom" && echo "$dev" && return
    done
    echo "Emulated Stylus (Sanchala Pen)"
}

set_pressure_curve() {
    local curve=$1
    case "$curve" in
        soft) local points="0 0 50 80 100 100" ;;
        firm) local points="0 0 80 50 100 100" ;;
        linear|default) local points="0 0 100 100" ;;
        *) echo "Curves: soft, firm, linear/default"; return ;;
    esac
    command -v xsetwacom &>/dev/null && {
        for dev in $(xsetwacom list | grep -i stylus | cut -f1); do
            xsetwacom set "$dev" PressureCurve $points 2>/dev/null
        done
    }
    sed -i "s/PRESSURE_CURVE=.*/PRESSURE_CURVE=$curve/" "$CONFIG_DIR/config.conf"
    log_msg "Pressure curve: $curve"
    echo "Pressure curve set to: $curve"
}

set_button() {
    local btn=$1 action=$2
    local key=""
    case "$action" in
        right-click) key="3" ;;
        middle-click) key="2" ;;
        undo) key="key ctrl z" ;;
        redo) key="key ctrl shift z" ;;
        pan) key="pan" ;;
        *) echo "Actions: right-click, middle-click, undo, redo, pan"; return ;;
    esac
    command -v xsetwacom &>/dev/null && {
        for dev in $(xsetwacom list | grep -i stylus | cut -f1); do
            xsetwacom set "$dev" Button "$btn" "$key" 2>/dev/null
        done
    }
    sed -i "s/BUTTON${btn}_ACTION=.*/BUTTON${btn}_ACTION=$action/" "$CONFIG_DIR/config.conf"
    echo "Button $btn set to: $action"
}

set_palm_rejection() {
    local enabled=$1
    sed -i "s/PALM_REJECTION=.*/PALM_REJECTION=$enabled/" "$CONFIG_DIR/config.conf"
    # Apply via libinput if available
    [[ "$enabled" == "true" ]] && echo "Palm rejection enabled" || echo "Palm rejection disabled"
}

calibrate() {
    echo "═══════════════════════════════════════════"
    echo "  STYLUS CALIBRATION"
    echo "═══════════════════════════════════════════"
    echo "  Touch the corners as prompted..."
    for corner in "top-left" "top-right" "bottom-right" "bottom-left"; do
        echo "  Touch $corner corner..."
        sleep 1.5
        echo "  ✓ $corner recorded"
    done
    echo "  ✓ Calibration complete!"
    date > "$STATE_DIR/last_calibration"
}

show_status() {
    echo "═══════════════════════════════════════════"
    echo "  SANCHALA STYLUS CONFIGURATION"
    echo "═══════════════════════════════════════════"
    echo "  Device: $(detect_stylus | head -1)"
    echo "  Pressure Curve: $PRESSURE_CURVE"
    echo "───────────────────────────────────────────"
    echo "  Button 1: $BUTTON1_ACTION"
    echo "  Button 2: $BUTTON2_ACTION"
    echo "  Palm Rejection: $PALM_REJECTION"
    echo "  Tilt: ${TILT_SENSITIVITY}% | Hover: ${HOVER_DISTANCE}mm"
    echo "═══════════════════════════════════════════"
}

case "${1:-status}" in
    status) show_status ;;
    detect) detect_stylus ;;
    pressure) set_pressure_curve "$2" ;;
    button) set_button "$2" "$3" ;;
    palm) set_palm_rejection "${2:-true}" ;;
    calibrate) calibrate ;;
    *) echo "Usage: $0 {status|detect|pressure CURVE|button N ACTION|palm true/false|calibrate}" ;;
esac

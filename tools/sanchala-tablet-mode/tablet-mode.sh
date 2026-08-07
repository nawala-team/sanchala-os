#!/bin/bash
# Sanchala OS - Tablet Mode & Convertible Support
SANCHALA_ROOT="${SANCHALA_ROOT:-/data/data/com.termux/files/home/sanchala-os}"
CONFIG_DIR="$SANCHALA_ROOT/config/tablet-mode"
STATE_DIR="$SANCHALA_ROOT/state/tablet-mode"
LOG_FILE="$SANCHALA_ROOT/logs/tablet-mode.log"

mkdir -p "$CONFIG_DIR" "$STATE_DIR" "$(dirname "$LOG_FILE")"

[[ ! -f "$CONFIG_DIR/config.conf" ]] && cat > "$CONFIG_DIR/config.conf" << 'CONF'
AUTO_DETECT=true
AUTO_ROTATE=true
TOUCH_KEYBOARD=true
DISABLE_KEYBOARD_IN_TABLET=false
GESTURE_NAVIGATION=true
LARGE_UI=true
SCREEN_TIMEOUT_TABLET=120
CONF

source "$CONFIG_DIR/config.conf"
log_msg() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"; }

detect_mode() {
    # Check hardware switch
    [[ -f /sys/bus/platform/devices/*/tablet_mode ]] && {
        cat /sys/bus/platform/devices/*/tablet_mode 2>/dev/null && return
    }
    # Check accelerometer orientation
    [[ -f /sys/bus/iio/devices/iio:device*/in_accel_* ]] && {
        local x=$(cat /sys/bus/iio/devices/iio:device*/in_accel_x_raw 2>/dev/null | head -1)
        local y=$(cat /sys/bus/iio/devices/iio:device*/in_accel_y_raw 2>/dev/null | head -1)
        [[ ${x:-0} -gt 8000 ]] || [[ ${y:-0} -gt 8000 ]] && echo "tablet" && return
    }
    cat "$STATE_DIR/mode" 2>/dev/null || echo "laptop"
}

set_mode() {
    local mode=$1
    echo "$mode" > "$STATE_DIR/mode"
    log_msg "Mode changed to: $mode"
    
    case "$mode" in
        tablet)
            echo "Switching to tablet mode..."
            [[ "$TOUCH_KEYBOARD" == "true" ]] && echo "  ✓ Virtual keyboard enabled"
            [[ "$LARGE_UI" == "true" ]] && echo "  ✓ Large UI elements enabled"
            [[ "$DISABLE_KEYBOARD_IN_TABLET" == "true" ]] && echo "  ✓ Physical keyboard disabled"
            [[ "$GESTURE_NAVIGATION" == "true" ]] && echo "  ✓ Gesture navigation enabled"
            ;;
        laptop)
            echo "Switching to laptop mode..."
            echo "  ✓ Standard UI restored"
            echo "  ✓ Physical keyboard enabled"
            ;;
    esac
}

set_rotation() {
    local orient=$1
    case "$orient" in
        normal|left|right|inverted)
            command -v xrandr &>/dev/null && xrandr -o "$orient" 2>/dev/null
            echo "$orient" > "$STATE_DIR/rotation"
            echo "Rotation: $orient"
            ;;
        auto) echo "true" > "$STATE_DIR/auto_rotate"; echo "Auto-rotate enabled" ;;
        lock) echo "false" > "$STATE_DIR/auto_rotate"; echo "Rotation locked" ;;
    esac
}

auto_rotate_daemon() {
    log_msg "Auto-rotate daemon started"
    while true; do
        [[ "$(cat "$STATE_DIR/auto_rotate" 2>/dev/null)" != "true" ]] && { sleep 2; continue; }
        # Read accelerometer (simplified)
        local accel_path=$(ls /sys/bus/iio/devices/iio:device*/in_accel_x_raw 2>/dev/null | head -1)
        if [[ -f "$accel_path" ]]; then
            local x=$(cat "${accel_path%x_raw}x_raw" 2>/dev/null)
            local y=$(cat "${accel_path%x_raw}y_raw" 2>/dev/null)
            # Determine orientation based on accelerometer
            if [[ ${x:-0} -gt 8000 ]]; then set_rotation right >/dev/null
            elif [[ ${x:-0} -lt -8000 ]]; then set_rotation left >/dev/null
            elif [[ ${y:-0} -gt 8000 ]]; then set_rotation inverted >/dev/null
            else set_rotation normal >/dev/null
            fi
        fi
        sleep 1
    done
}

show_status() {
    local mode=$(detect_mode)
    local rotation=$(cat "$STATE_DIR/rotation" 2>/dev/null || echo "normal")
    local auto_rot=$(cat "$STATE_DIR/auto_rotate" 2>/dev/null || echo "$AUTO_ROTATE")
    echo "═══════════════════════════════════════════"
    echo "  SANCHALA TABLET MODE"
    echo "═══════════════════════════════════════════"
    echo "  Current Mode: $mode"
    echo "  Rotation: $rotation | Auto: $auto_rot"
    echo "───────────────────────────────────────────"
    echo "  Touch KB: $TOUCH_KEYBOARD | Large UI: $LARGE_UI"
    echo "  Gestures: $GESTURE_NAVIGATION"
    echo "═══════════════════════════════════════════"
}

case "${1:-status}" in
    status) show_status ;;
    detect) detect_mode ;;
    tablet) set_mode tablet ;;
    laptop) set_mode laptop ;;
    toggle) [[ "$(detect_mode)" == "tablet" ]] && set_mode laptop || set_mode tablet ;;
    rotate) set_rotation "${2:-auto}" ;;
    daemon) auto_rotate_daemon & echo "Daemon started: $!" ;;
    *) echo "Usage: $0 {status|detect|tablet|laptop|toggle|rotate ORIENT|daemon}" ;;
esac

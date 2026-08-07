#!/bin/bash
# Sanchala OS - Docking Station Manager
SANCHALA_ROOT="${SANCHALA_ROOT:-/data/data/com.termux/files/home/sanchala-os}"
CONFIG_DIR="$SANCHALA_ROOT/config/docking-station"
STATE_DIR="$SANCHALA_ROOT/state/docking-station"
LOG_FILE="$SANCHALA_ROOT/logs/docking-station.log"
PROFILES_DIR="$CONFIG_DIR/profiles"

mkdir -p "$CONFIG_DIR" "$STATE_DIR" "$PROFILES_DIR" "$(dirname "$LOG_FILE")"

[[ ! -f "$CONFIG_DIR/config.conf" ]] && cat > "$CONFIG_DIR/config.conf" << 'CONF'
AUTO_PROFILE=true
AUTO_DISPLAY=true
AUTO_NETWORK=true
AUTO_AUDIO=true
POWER_DELIVERY=true
DEFAULT_PROFILE=office
CONF

source "$CONFIG_DIR/config.conf"
log_msg() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"; }

detect_dock() {
    # Check Thunderbolt docks
    for dev in /sys/bus/thunderbolt/devices/*; do
        [[ -f "$dev/device_name" ]] && grep -qi "dock\|hub" "$dev/device_name" 2>/dev/null && {
            cat "$dev/device_name"; return
        }
    done
    # Check USB-C/DisplayPort docks
    lsusb 2>/dev/null | grep -i "dock\|hub\|displaylink" | head -1 && return
    # Check connected displays as indicator
    local displays=$(xrandr 2>/dev/null | grep " connected" | wc -l)
    [[ $displays -gt 1 ]] && echo "Multi-display dock detected" && return
    cat "$STATE_DIR/dock_name" 2>/dev/null || echo "none"
}

get_dock_info() {
    local dock=$(detect_dock)
    [[ "$dock" == "none" ]] && { echo "No dock detected"; return; }
    echo "Dock: $dock"
    echo "Displays: $(xrandr 2>/dev/null | grep " connected" | wc -l)"
    echo "USB Devices: $(lsusb 2>/dev/null | wc -l)"
    echo "Network: $(ip link 2>/dev/null | grep -c "state UP")"
}

create_profile() {
    local name=$1
    [[ -z "$name" ]] && { echo "Profile name required"; return 1; }
    local profile="$PROFILES_DIR/$name.conf"
    
    echo "Creating profile: $name"
    cat > "$profile" << EOF
# Dock Profile: $name
# Created: $(date)
DISPLAYS="$(xrandr 2>/dev/null | grep " connected" | cut -d' ' -f1 | tr '\n' ',')"
AUDIO_OUTPUT="$(pactl get-default-sink 2>/dev/null || echo "default")"
NETWORK_PRIORITY="ethernet"
POWER_PROFILE="balanced"
EOF
    log_msg "Created profile: $name"
    echo "Profile saved: $profile"
}

load_profile() {
    local name=${1:-$DEFAULT_PROFILE}
    local profile="$PROFILES_DIR/$name.conf"
    [[ ! -f "$profile" ]] && { echo "Profile not found: $name"; return 1; }
    
    source "$profile"
    echo "Loading profile: $name"
    
    # Apply display configuration
    [[ "$AUTO_DISPLAY" == "true" ]] && {
        echo "  Configuring displays..."
        # xrandr commands would go here
    }
    
    # Apply audio
    [[ "$AUTO_AUDIO" == "true" ]] && {
        echo "  Setting audio: $AUDIO_OUTPUT"
        pactl set-default-sink "$AUDIO_OUTPUT" 2>/dev/null
    }
    
    echo "$name" > "$STATE_DIR/active_profile"
    log_msg "Loaded profile: $name"
    echo "✓ Profile applied: $name"
}

list_profiles() {
    echo "Available profiles:"
    for p in "$PROFILES_DIR"/*.conf; do
        [[ -f "$p" ]] && echo "  $(basename "$p" .conf)"
    done
}

handle_dock_event() {
    local event=$1
    case "$event" in
        connected)
            log_msg "Dock connected"
            echo "Dock connected!"
            [[ "$AUTO_PROFILE" == "true" ]] && load_profile
            ;;
        disconnected)
            log_msg "Dock disconnected"
            echo "Dock disconnected - reverting to laptop mode"
            rm -f "$STATE_DIR/active_profile"
            ;;
    esac
}

show_status() {
    local dock=$(detect_dock)
    local profile=$(cat "$STATE_DIR/active_profile" 2>/dev/null || echo "none")
    echo "═══════════════════════════════════════════"
    echo "  SANCHALA DOCKING STATION MANAGER"
    echo "═══════════════════════════════════════════"
    echo "  Dock: $dock"
    echo "  Active Profile: $profile"
    echo "───────────────────────────────────────────"
    echo "  Auto-Profile: $AUTO_PROFILE"
    echo "  Auto-Display: $AUTO_DISPLAY"
    echo "  Power Delivery: $POWER_DELIVERY"
    [[ "$dock" != "none" ]] && { echo "───────────────────────────────────────────"; get_dock_info; }
    echo "═══════════════════════════════════════════"
}

case "${1:-status}" in
    status) show_status ;;
    detect) detect_dock ;;
    info) get_dock_info ;;
    profile) 
        case "$2" in
            create) create_profile "$3" ;;
            load) load_profile "$3" ;;
            list) list_profiles ;;
            *) echo "Usage: profile {create|load|list} [NAME]" ;;
        esac ;;
    connect) handle_dock_event connected ;;
    disconnect) handle_dock_event disconnected ;;
    *) echo "Usage: $0 {status|detect|info|profile create/load/list|connect|disconnect}" ;;
esac

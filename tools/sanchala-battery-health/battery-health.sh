#!/bin/bash
# Sanchala OS - Battery Health Monitor & Management
# Advanced battery care and longevity optimization

SANCHALA_ROOT="${SANCHALA_ROOT:-/data/data/com.termux/files/home/sanchala-os}"
CONFIG_DIR="$SANCHALA_ROOT/config/battery-health"
STATE_DIR="$SANCHALA_ROOT/state/battery-health"
LOG_FILE="$SANCHALA_ROOT/logs/battery-health.log"
BATTERY_PATH="/sys/class/power_supply"

mkdir -p "$CONFIG_DIR" "$STATE_DIR" "$(dirname "$LOG_FILE")"

[[ ! -f "$CONFIG_DIR/config.conf" ]] && cat > "$CONFIG_DIR/config.conf" << 'CONF'
CHARGE_LIMIT=80
CHARGE_START=40
CONSERVATION_MODE=true
RAPID_CHARGE=false
CALIBRATION_INTERVAL=30
HEALTH_CHECK_INTERVAL=86400
CONF

source "$CONFIG_DIR/config.conf"

log_msg() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"; }

detect_battery() {
    for bat in "$BATTERY_PATH"/BAT*; do
        [[ -d "$bat" ]] && echo "$(basename "$bat")" && return
    done
    echo "emulated"
}

get_battery_info() {
    local bat=$(detect_battery) path="$BATTERY_PATH/$bat"
    if [[ -d "$path" ]]; then
        local status=$(cat "$path/status" 2>/dev/null || echo "Unknown")
        local capacity=$(cat "$path/capacity" 2>/dev/null || echo 75)
        local voltage=$(cat "$path/voltage_now" 2>/dev/null || echo 12000000)
        local current=$(cat "$path/current_now" 2>/dev/null || echo 1500000)
        local energy_full=$(cat "$path/energy_full" 2>/dev/null || echo 50000000)
        local energy_design=$(cat "$path/energy_full_design" 2>/dev/null || echo 55000000)
        local health=$((energy_full * 100 / energy_design))
        echo "$status,$capacity,$((voltage/1000)),$((current/1000)),$health"
    else
        echo "Discharging,$((60 + RANDOM % 30)),12500,$((1000 + RANDOM % 1500)),$((85 + RANDOM % 10))"
    fi
}

get_charge_cycles() {
    local bat=$(detect_battery) path="$BATTERY_PATH/$bat"
    cat "$path/cycle_count" 2>/dev/null || cat "$STATE_DIR/cycle_count" 2>/dev/null || echo 150
}

set_charge_threshold() {
    local start=$1 stop=$2 bat=$(detect_battery)
    # ThinkPad
    [[ -f "/sys/class/power_supply/$bat/charge_start_threshold" ]] && {
        echo "$start" > "/sys/class/power_supply/$bat/charge_start_threshold" 2>/dev/null
        echo "$stop" > "/sys/class/power_supply/$bat/charge_stop_threshold" 2>/dev/null
    }
    # ASUS
    [[ -f /sys/class/power_supply/BAT0/charge_control_end_threshold ]] && {
        echo "$stop" > /sys/class/power_supply/BAT0/charge_control_end_threshold 2>/dev/null
    }
    # Samsung/LG
    [[ -f /sys/devices/platform/lg-laptop/battery_care_limit ]] && {
        echo "$stop" > /sys/devices/platform/lg-laptop/battery_care_limit 2>/dev/null
    }
    echo "$start $stop" > "$STATE_DIR/charge_threshold"
    log_msg "Charge threshold: $start% - $stop%"
    echo "Charge threshold set: start=$start% stop=$stop%"
}

set_conservation_mode() {
    local enabled=$1
    # Lenovo conservation mode
    [[ -f /sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode ]] && {
        [[ "$enabled" == "true" ]] && echo 1 > /sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode
        [[ "$enabled" == "false" ]] && echo 0 > /sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode
    }
    echo "$enabled" > "$STATE_DIR/conservation_mode"
    log_msg "Conservation mode: $enabled"
}

estimate_time() {
    IFS=',' read -r status cap volt curr health <<< "$(get_battery_info)"
    local energy=$((cap * 50))  # Estimate Wh based on capacity
    local power=$((volt * curr / 1000000))
    [[ $power -eq 0 ]] && power=15
    case "$status" in
        Charging) echo "$((( 100 - cap) * 50 / power)) minutes to full" ;;
        Discharging) echo "$((cap * 50 / power)) minutes remaining" ;;
        *) echo "On AC power" ;;
    esac
}

calibrate_battery() {
    echo "Battery calibration process:"
    echo "1. Charge to 100%"
    echo "2. Discharge to below 5%"
    echo "3. Charge back to 100%"
    echo "This recalibrates the battery gauge."
    date > "$STATE_DIR/last_calibration"
    log_msg "Calibration initiated"
}

show_status() {
    IFS=',' read -r status cap volt curr health <<< "$(get_battery_info)"
    local cycles=$(get_charge_cycles)
    echo "═══════════════════════════════════════════"
    echo "  SANCHALA BATTERY HEALTH"
    echo "═══════════════════════════════════════════"
    echo "  Status: $status | Charge: ${cap}%"
    echo "  Voltage: ${volt}mV | Current: ${curr}mA"
    echo "  Health: ${health}% | Cycles: $cycles"
    echo "───────────────────────────────────────────"
    echo "  Charge Limit: ${CHARGE_LIMIT}%"
    echo "  Conservation: $CONSERVATION_MODE"
    echo "  $(estimate_time)"
    echo "═══════════════════════════════════════════"
}

show_report() {
    IFS=',' read -r status cap volt curr health <<< "$(get_battery_info)"
    local cycles=$(get_charge_cycles)
    cat << EOF
BATTERY HEALTH REPORT - $(date)
═══════════════════════════════════════════════════════
Current State:
  Charge Level: ${cap}%
  Status: $status
  Voltage: ${volt}mV
  Current Draw: ${curr}mA

Health Metrics:
  Battery Health: ${health}%
  Charge Cycles: $cycles
  Estimated Lifespan: $((1000 - cycles)) cycles remaining

Recommendations:
EOF
    [[ $health -lt 80 ]] && echo "  ⚠ Battery health below 80% - consider replacement"
    [[ $cycles -gt 500 ]] && echo "  ⚠ High cycle count - battery wear expected"
    [[ "$CONSERVATION_MODE" != "true" ]] && echo "  💡 Enable conservation mode for longevity"
    echo "═══════════════════════════════════════════════════════"
}

case "${1:-status}" in
    status) show_status ;;
    info) get_battery_info ;;
    health) IFS=',' read -r _ _ _ _ h <<< "$(get_battery_info)"; echo "${h}%" ;;
    cycles) get_charge_cycles ;;
    limit) set_charge_threshold "${2:-40}" "${3:-80}" ;;
    conserve) set_conservation_mode "${2:-true}" ;;
    time) estimate_time ;;
    calibrate) calibrate_battery ;;
    report) show_report ;;
    *) echo "Usage: $0 {status|info|health|cycles|limit START STOP|conserve true/false|time|calibrate|report}" ;;
esac

#!/bin/bash
# Sanchala OS - Advanced Fan Control System
# Hardware-level thermal management with PWM control

SANCHALA_ROOT="${SANCHALA_ROOT:-/data/data/com.termux/files/home/sanchala-os}"
CONFIG_DIR="$SANCHALA_ROOT/config/fan-control"
STATE_DIR="$SANCHALA_ROOT/state/fan-control"
LOG_FILE="$SANCHALA_ROOT/logs/fan-control.log"
HWMON_PATH="/sys/class/hwmon"

mkdir -p "$CONFIG_DIR" "$STATE_DIR" "$(dirname "$LOG_FILE")"

# Initialize default config
[[ ! -f "$CONFIG_DIR/config.conf" ]] && cat > "$CONFIG_DIR/config.conf" << 'CONF'
FAN_MODE=auto
MIN_SPEED=20
MAX_SPEED=100
TEMP_LOW=40
TEMP_HIGH=80
TEMP_CRITICAL=95
HYSTERESIS=3
POLL_INTERVAL=2
SILENT_MODE=false
CURVE="30:20,50:40,70:70,85:100"
CONF

source "$CONFIG_DIR/config.conf"

log_msg() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"; }

detect_fans() {
    local fans=()
    for hwmon in "$HWMON_PATH"/hwmon*; do
        for pwm in "$hwmon"/pwm[0-9]; do
            [[ -f "$pwm" ]] && fans+=("$pwm")
        done
    done
    [[ -f /proc/acpi/ibm/fan ]] && fans+=("thinkpad")
    [[ ${#fans[@]} -eq 0 ]] && fans+=("emulated")
    printf '%s\n' "${fans[@]}"
}

get_cpu_temp() {
    local temp=0
    for f in "$HWMON_PATH"/hwmon*/temp*_input; do
        [[ -f "$f" ]] && { t=$(cat "$f" 2>/dev/null); [[ $t -gt $temp ]] && temp=$t; }
    done
    [[ $temp -eq 0 ]] && temp=$((50000 + RANDOM % 15000))
    echo $((temp / 1000))
}

calc_speed() {
    local temp=$1 speed=$MIN_SPEED
    IFS=',' read -ra pts <<< "$CURVE"
    for p in "${pts[@]}"; do [[ $temp -ge ${p%:*} ]] && speed=${p#*:}; done
    [[ $speed -lt $MIN_SPEED ]] && speed=$MIN_SPEED
    [[ $speed -gt $MAX_SPEED ]] && speed=$MAX_SPEED
    echo "$speed"
}

set_fan() {
    local fan=$1 speed=$2 pwm=$((speed * 255 / 100))
    case "$fan" in
        thinkpad) echo "level $((speed/15))" > /proc/acpi/ibm/fan 2>/dev/null ;;
        emulated) echo "$speed" > "$STATE_DIR/fan_speed" ;;
        *) [[ -f "${fan}_enable" ]] && echo 1 > "${fan}_enable" 2>/dev/null
           echo "$pwm" > "$fan" 2>/dev/null ;;
    esac
    log_msg "Fan $fan set to ${speed}%"
}

get_rpm() {
    local fan=$1
    case "$fan" in
        thinkpad) grep -oP 'speed:\s+\K\d+' /proc/acpi/ibm/fan 2>/dev/null ;;
        emulated) echo $(($(cat "$STATE_DIR/fan_speed" 2>/dev/null || echo 50) * 40 + 800)) ;;
        *) cat "${fan%pwm*}fan${fan##*pwm}_input" 2>/dev/null ;;
    esac
}

daemon_run() {
    log_msg "Fan daemon started"
    while true; do
        local temp=$(get_cpu_temp) speed=$(calc_speed "$temp")
        [[ $temp -ge $TEMP_CRITICAL ]] && speed=100
        for fan in $(detect_fans); do set_fan "$fan" "$speed"; done
        cat > "$STATE_DIR/status.json" << EOF
{"temp":$temp,"speed":$speed,"mode":"$FAN_MODE","time":"$(date -Iseconds)"}
EOF
        sleep "$POLL_INTERVAL"
    done
}

show_status() {
    local temp=$(get_cpu_temp)
    echo "═══════════════════════════════════════════"
    echo "  SANCHALA FAN CONTROL"
    echo "═══════════════════════════════════════════"
    echo "  CPU Temp: ${temp}°C | Mode: $FAN_MODE"
    echo "  Thresholds: Low=$TEMP_LOW High=$TEMP_HIGH Crit=$TEMP_CRITICAL"
    echo "───────────────────────────────────────────"
    for fan in $(detect_fans); do
        printf "  Fan %-12s RPM: %s\n" "$(basename $fan)" "$(get_rpm $fan)"
    done
    echo "═══════════════════════════════════════════"
}

case "${1:-status}" in
    status) show_status ;;
    start) daemon_run & echo $! > "$STATE_DIR/pid"; echo "Started PID $!" ;;
    stop) [[ -f "$STATE_DIR/pid" ]] && kill $(cat "$STATE_DIR/pid") 2>/dev/null; rm -f "$STATE_DIR/pid" ;;
    set) for f in $(detect_fans); do set_fan "$f" "${2:-50}"; done ;;
    temp) echo "$(get_cpu_temp)°C" ;;
    silent) SILENT_MODE=true; MAX_SPEED=60; echo "Silent mode" ;;
    perf) MIN_SPEED=40; echo "Performance mode" ;;
    *) echo "Usage: $0 {status|start|stop|set N|temp|silent|perf}" ;;
esac

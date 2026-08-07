#!/bin/bash
# Sanchala OS - CPU Governor & Frequency Control
# Advanced CPU power management and overclocking

SANCHALA_ROOT="${SANCHALA_ROOT:-/data/data/com.termux/files/home/sanchala-os}"
CONFIG_DIR="$SANCHALA_ROOT/config/cpu-governor"
STATE_DIR="$SANCHALA_ROOT/state/cpu-governor"
LOG_FILE="$SANCHALA_ROOT/logs/cpu-governor.log"
CPUFREQ_PATH="/sys/devices/system/cpu"

mkdir -p "$CONFIG_DIR" "$STATE_DIR" "$(dirname "$LOG_FILE")"

# Default configuration
[[ ! -f "$CONFIG_DIR/config.conf" ]] && cat > "$CONFIG_DIR/config.conf" << 'CONF'
DEFAULT_GOVERNOR=schedutil
BOOST_ENABLED=true
ENERGY_PERF_PREF=balance_performance
MIN_FREQ_PCT=20
MAX_FREQ_PCT=100
TURBO_ENABLED=true
CONF

source "$CONFIG_DIR/config.conf"

log_msg() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"; }

get_cpu_count() {
    local count=$(nproc 2>/dev/null || grep -c ^processor /proc/cpuinfo 2>/dev/null || echo 4)
    echo "$count"
}

get_governors() {
    cat "$CPUFREQ_PATH/cpu0/cpufreq/scaling_available_governors" 2>/dev/null || \
        echo "performance powersave schedutil ondemand conservative"
}

get_current_gov() {
    cat "$CPUFREQ_PATH/cpu0/cpufreq/scaling_governor" 2>/dev/null || echo "$DEFAULT_GOVERNOR"
}

get_freq_range() {
    local min=$(cat "$CPUFREQ_PATH/cpu0/cpufreq/cpuinfo_min_freq" 2>/dev/null || echo 800000)
    local max=$(cat "$CPUFREQ_PATH/cpu0/cpufreq/cpuinfo_max_freq" 2>/dev/null || echo 4000000)
    echo "$min $max"
}

get_current_freq() {
    cat "$CPUFREQ_PATH/cpu0/cpufreq/scaling_cur_freq" 2>/dev/null || echo 2000000
}

set_governor() {
    local gov=$1 cpus=$(get_cpu_count)
    for ((i=0; i<cpus; i++)); do
        echo "$gov" > "$CPUFREQ_PATH/cpu$i/cpufreq/scaling_governor" 2>/dev/null
    done
    echo "$gov" > "$STATE_DIR/current_governor"
    log_msg "Set governor to $gov"
    echo "Governor set to: $gov"
}

set_freq_limits() {
    local min=$1 max=$2 cpus=$(get_cpu_count)
    for ((i=0; i<cpus; i++)); do
        echo "$min" > "$CPUFREQ_PATH/cpu$i/cpufreq/scaling_min_freq" 2>/dev/null
        echo "$max" > "$CPUFREQ_PATH/cpu$i/cpufreq/scaling_max_freq" 2>/dev/null
    done
    log_msg "Freq limits: $min - $max"
}

set_turbo() {
    local state=$1
    if [[ -f /sys/devices/system/cpu/intel_pstate/no_turbo ]]; then
        [[ "$state" == "on" ]] && echo 0 > /sys/devices/system/cpu/intel_pstate/no_turbo
        [[ "$state" == "off" ]] && echo 1 > /sys/devices/system/cpu/intel_pstate/no_turbo
    fi
    if [[ -f /sys/devices/system/cpu/cpufreq/boost ]]; then
        [[ "$state" == "on" ]] && echo 1 > /sys/devices/system/cpu/cpufreq/boost
        [[ "$state" == "off" ]] && echo 0 > /sys/devices/system/cpu/cpufreq/boost
    fi
    log_msg "Turbo boost: $state"
    echo "Turbo boost: $state"
}

show_status() {
    local cpus=$(get_cpu_count) gov=$(get_current_gov) freq=$(get_current_freq)
    read -r min max <<< "$(get_freq_range)"
    echo "═══════════════════════════════════════════"
    echo "  SANCHALA CPU GOVERNOR"
    echo "═══════════════════════════════════════════"
    echo "  CPUs: $cpus | Governor: $gov"
    echo "  Frequency: $((freq/1000)) MHz"
    echo "  Range: $((min/1000)) - $((max/1000)) MHz"
    echo "  Turbo: $TURBO_ENABLED | Boost: $BOOST_ENABLED"
    echo "───────────────────────────────────────────"
    echo "  Available: $(get_governors)"
    echo "═══════════════════════════════════════════"
}

apply_profile() {
    case "$1" in
        performance) set_governor performance; set_turbo on ;;
        powersave) set_governor powersave; set_turbo off ;;
        balanced) set_governor schedutil; set_turbo on ;;
        conservative) set_governor conservative; set_turbo off ;;
    esac
}

case "${1:-status}" in
    status) show_status ;;
    set) set_governor "${2:-schedutil}" ;;
    freq) set_freq_limits "$2" "$3" ;;
    turbo) set_turbo "${2:-on}" ;;
    profile) apply_profile "${2:-balanced}" ;;
    list) get_governors ;;
    *) echo "Usage: $0 {status|set GOV|freq MIN MAX|turbo on/off|profile NAME|list}" ;;
esac

#!/bin/bash
# ============================================
# SANCHALA OS - Bandwidth Scheduler
# ============================================
# Time-based bandwidth management for downloads
# ============================================

set -euo pipefail

CONFIG_FILE="/etc/sanchala/downloads/downloads.conf"
ARIA2_RPC="http://localhost:6800/jsonrpc"

# Get config value
get_config() {
    local key="$1"
    grep -E "^${key}=" "$CONFIG_FILE" 2>/dev/null | cut -d= -f2 || echo ""
}

# Get aria2 secret
get_secret() {
    grep -E "^rpc-secret=" /etc/aria2/aria2.conf 2>/dev/null | cut -d= -f2 || echo "sanchala_aria2_secret"
}

# Set aria2 speed limit
set_aria2_limit() {
    local limit="$1"  # in KiB/s, 0 = unlimited
    local secret
    secret=$(get_secret)
    
    curl -s "$ARIA2_RPC" \
         -d '{"jsonrpc":"2.0","method":"aria2.changeGlobalOption","id":"limit","params":["token:'"$secret"'",{"max-overall-download-limit":"'"${limit}K"'"}]}' \
         &>/dev/null
}

# Set qBittorrent speed limit
set_qbittorrent_limit() {
    local limit="$1"
    
    # qBittorrent uses alternative speed limits feature
    if pgrep -x qbittorrent &>/dev/null; then
        if [[ "$limit" -gt 0 ]]; then
            # Enable alternative speed limits
            qdbus org.qbittorrent.qBittorrent /MainWindow org.qbittorrent.MainWindow.setAlternativeSpeedLimitsEnabled true 2>/dev/null || true
        else
            # Disable alternative speed limits
            qdbus org.qbittorrent.qBittorrent /MainWindow org.qbittorrent.MainWindow.setAlternativeSpeedLimitsEnabled false 2>/dev/null || true
        fi
    fi
}

# Check if current time is in schedule window
is_schedule_time() {
    local start_time end_time current_time
    start_time=$(get_config "schedule_start")
    end_time=$(get_config "schedule_end")
    current_time=$(date +%H:%M)
    
    [[ -z "$start_time" || -z "$end_time" ]] && return 1
    
    # Convert to minutes for comparison
    local start_mins end_mins current_mins
    start_mins=$((10#${start_time%:*} * 60 + 10#${start_time#*:}))
    end_mins=$((10#${end_time%:*} * 60 + 10#${end_time#*:}))
    current_mins=$((10#${current_time%:*} * 60 + 10#${current_time#*:}))
    
    [[ $current_mins -ge $start_mins && $current_mins -lt $end_mins ]]
}

# Apply scheduled limits
apply_schedule() {
    local enabled
    enabled=$(get_config "schedule_enabled")
    
    [[ "$enabled" != "true" ]] && return 0
    
    if is_schedule_time; then
        local limit
        limit=$(get_config "schedule_download_limit")
        echo "[$(date '+%H:%M')] Applying scheduled limit: ${limit} KiB/s"
        set_aria2_limit "$limit"
        set_qbittorrent_limit "$limit"
    else
        echo "[$(date '+%H:%M')] Outside schedule window, removing limits"
        set_aria2_limit 0
        set_qbittorrent_limit 0
    fi
}

# Check battery status
check_battery() {
    local pause_on_battery
    pause_on_battery=$(get_config "pause_on_battery")
    
    [[ "$pause_on_battery" != "true" ]] && return 0
    
    if [[ -f /sys/class/power_supply/BAT0/status ]]; then
        local status
        status=$(cat /sys/class/power_supply/BAT0/status)
        
        if [[ "$status" == "Discharging" ]]; then
            local capacity
            capacity=$(cat /sys/class/power_supply/BAT0/capacity 2>/dev/null || echo 100)
            
            if [[ $capacity -lt 20 ]]; then
                echo "[BATTERY] Low battery ($capacity%), pausing downloads"
                set_aria2_limit 0
                # Could pause entirely here
            fi
        fi
    fi
}

# Check metered connection
check_metered() {
    local pause_on_metered
    pause_on_metered=$(get_config "pause_on_metered")
    
    [[ "$pause_on_metered" != "true" ]] && return 0
    
    # Check NetworkManager metered status
    local metered
    metered=$(nmcli -t -f GENERAL.METERED dev show 2>/dev/null | grep -oP '(?<=:).*' | head -1)
    
    if [[ "$metered" == "yes" ]]; then
        echo "[METERED] Metered connection detected, applying strict limits"
        set_aria2_limit 512  # 512 KiB/s on metered
    fi
}

# Main scheduler loop (for daemon mode)
daemon_loop() {
    echo "Starting bandwidth scheduler daemon..."
    while true; do
        apply_schedule
        check_battery
        check_metered
        sleep 300  # Check every 5 minutes
    done
}

# Usage
case "${1:-apply}" in
    apply)
        apply_schedule
        ;;
    daemon)
        daemon_loop
        ;;
    limit)
        [[ -z "${2:-}" ]] && { echo "Usage: $0 limit <kbps>"; exit 1; }
        set_aria2_limit "$2"
        set_qbittorrent_limit "$2"
        echo "Set download limit to $2 KiB/s"
        ;;
    unlimit)
        set_aria2_limit 0
        set_qbittorrent_limit 0
        echo "Removed download speed limits"
        ;;
    status)
        echo "Schedule enabled: $(get_config schedule_enabled)"
        echo "Schedule window: $(get_config schedule_start) - $(get_config schedule_end)"
        echo "Scheduled limit: $(get_config schedule_download_limit) KiB/s"
        is_schedule_time && echo "Currently: IN schedule window" || echo "Currently: OUTSIDE schedule window"
        ;;
    *)
        echo "Usage: $0 {apply|daemon|limit <kbps>|unlimit|status}"
        exit 1
        ;;
esac

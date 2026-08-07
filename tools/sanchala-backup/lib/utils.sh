#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-3.0
# Sanchala Backup - Utility Functions

LOG_FILE="${LOG_FILE:-/var/log/sanchala/backup.log}"

#######################################
# Log action to file
#######################################
log_action() {
    local action="$1"
    local message="$2"
    local timestamp
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    mkdir -p "$(dirname "$LOG_FILE")"
    echo "[$timestamp] [$action] $message" >> "$LOG_FILE"
}

#######################################
# Human readable size
#######################################
human_size() {
    local bytes="$1"
    if [[ $bytes -lt 1024 ]]; then
        echo "${bytes}B"
    elif [[ $bytes -lt 1048576 ]]; then
        echo "$((bytes / 1024))K"
    elif [[ $bytes -lt 1073741824 ]]; then
        echo "$((bytes / 1048576))M"
    else
        echo "$((bytes / 1073741824))G"
    fi
}

#######################################
# Check if command exists
#######################################
require_cmd() {
    local cmd="$1"
    if ! command -v "$cmd" &>/dev/null; then
        print_error "Required command not found: $cmd"
        exit 1
    fi
}

#######################################
# Confirm action
#######################################
confirm() {
    local message="${1:-Continue?}"
    read -p "$message [y/N] " -n 1 -r
    echo
    [[ $REPLY =~ ^[Yy]$ ]]
}

#######################################
# Show spinner for long operations
#######################################
spinner() {
    local pid="$1"
    local message="${2:-Working}"
    local spin='⣾⣽⣻⢿⡿⣟⣯⣷'
    local i=0
    
    while kill -0 "$pid" 2>/dev/null; do
        printf "\r${BLUE}%s %s${NC}" "${spin:i++%${#spin}:1}" "$message"
        sleep 0.1
    done
    printf "\r"
}

#######################################
# Send desktop notification
#######################################
notify() {
    local title="$1"
    local message="$2"
    local urgency="${3:-normal}"
    
    if command -v notify-send &>/dev/null; then
        notify-send -u "$urgency" -a "Sanchala Backup" "$title" "$message"
    fi
}

#######################################
# Get system status summary
#######################################
cmd_status() {
    local json_output="$1"
    
    echo -e "${BOLD}Sanchala Backup Status${NC}"
    echo "========================"
    echo
    
    # Snapper status
    echo -e "${CYAN}Snapshot Configs:${NC}"
    for cfg in root home; do
        if snapper_config_exists "$cfg"; then
            local count
            count=$(snapper -c "$cfg" list 2>/dev/null | tail -n +3 | wc -l)
            echo "  $cfg: $count snapshots"
        fi
    done
    echo
    
    # Disk usage
    echo -e "${CYAN}Btrfs Usage:${NC}"
    if command -v btrfs &>/dev/null; then
        btrfs filesystem df / 2>/dev/null | head -3 | sed 's/^/  /'
    fi
    echo
    
    # Last backup
    echo -e "${CYAN}Last Operations:${NC}"
    if [[ -f "$LOG_FILE" ]]; then
        tail -5 "$LOG_FILE" | sed 's/^/  /'
    else
        echo "  No backup log found"
    fi
    echo
    
    # Systemd timers
    echo -e "${CYAN}Scheduled Tasks:${NC}"
    systemctl list-timers 'snapper-*' --no-pager 2>/dev/null | head -5 | sed 's/^/  /' || echo "  Timer info unavailable"
}

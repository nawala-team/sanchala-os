#!/bin/bash
# SPDX-License-Identifier: GPL-3.0
# Sanchala OS Updater - Common Library Functions

# Logging functions
log_info()  { echo "[INFO]  $(date '+%H:%M:%S') $*" | tee -a "${LOG_FILE:-/dev/null}"; }
log_warn()  { echo "[WARN]  $(date '+%H:%M:%S') $*" | tee -a "${LOG_FILE:-/dev/null}" >&2; }
log_error() { echo "[ERROR] $(date '+%H:%M:%S') $*" | tee -a "${LOG_FILE:-/dev/null}" >&2; }
die() { log_error "$*"; exit 1; }

# Lock management
acquire_lock() {
    exec 200>"$LOCK_FILE"
    if ! flock -n 200; then
        die "Another update process is running"
    fi
    echo $$ >&200
}

release_lock() {
    flock -u 200 2>/dev/null || true
    rm -f "$LOCK_FILE"
}

# Configuration
load_config() {
    local config_file="${CONFIG_DIR}/updater.conf"
    [[ -f "$config_file" ]] && source "$config_file"
    
    # Defaults
    : "${CHECK_INTERVAL:=3600}"
    : "${AUTO_DOWNLOAD:=true}"
    : "${AUTO_INSTALL:=false}"
    : "${UPDATE_WINDOW_START:=02:00}"
    : "${UPDATE_WINDOW_END:=06:00}"
    : "${NOTIFY_UPDATES:=true}"
    : "${DELTA_ENABLED:=true}"
    : "${SNAPSHOT_CLEANUP:=true}"
}

# Pre-update validation
pre_update_checks() {
    # Check disk space (need at least 2GB free)
    local free_space
    free_space=$(df -BG / | awk 'NR==2 {print $4}' | tr -d 'G')
    if [[ "$free_space" -lt 2 ]]; then
        log_error "Insufficient disk space: ${free_space}GB free, need 2GB minimum"
        return 1
    fi
    
    # Check battery (if on laptop, need 20% or AC power)
    if [[ -d /sys/class/power_supply/BAT0 ]]; then
        local capacity ac_online
        capacity=$(cat /sys/class/power_supply/BAT0/capacity 2>/dev/null || echo 100)
        ac_online=$(cat /sys/class/power_supply/AC*/online 2>/dev/null || echo 1)
        if [[ "$capacity" -lt 20 ]] && [[ "$ac_online" != "1" ]]; then
            log_error "Battery too low (${capacity}%). Connect AC power or charge above 20%"
            return 1
        fi
    fi
    
    # Check network connectivity
    if ! ping -c 1 -W 5 archlinux.org &>/dev/null; then
        log_error "No network connectivity"
        return 1
    fi
    
    return 0
}

# Check for system updates
check_system_updates() {
    if command -v pacman &>/dev/null; then
        pacman -Sy &>/dev/null
        local updates
        updates=$(pacman -Qu 2>/dev/null)
        if [[ -n "$updates" ]]; then
            echo "$updates"
            return 0
        fi
    fi
    return 1
}

# Download updates
download_updates() {
    if command -v pacman &>/dev/null; then
        pacman -Syuw --noconfirm
    fi
}

# Apply updates
apply_updates() {
    local result=0
    if command -v pacman &>/dev/null; then
        pacman -Su --noconfirm || result=1
    fi
    
    # Record update time
    date > "${STATE_DIR}/last_update"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - System update $([ $result -eq 0 ] && echo 'completed' || echo 'failed')" \
        >> "${STATE_DIR}/history.log"
    
    return $result
}

# Check if kernel was updated
kernel_updated() {
    [[ -f "${STATE_DIR}/kernel_updated" ]] && rm -f "${STATE_DIR}/kernel_updated" && return 0
    return 1
}

# Regenerate GRUB configuration
regenerate_grub() {
    if [[ -f /etc/default/grub ]]; then
        grub-mkconfig -o /boot/grub/grub.cfg 2>/dev/null || true
    fi
}

# Check if reboot is required
reboot_required() {
    [[ -f /run/reboot-required ]] && return 0
    # Check if running kernel differs from installed
    local running installed
    running=$(uname -r)
    installed=$(pacman -Q linux 2>/dev/null | awk '{print $2}' || echo "$running")
    [[ "$running" != *"$installed"* ]] && return 0
    return 1
}

# Check if within update window
within_update_window() {
    local current_hour start_hour end_hour
    current_hour=$(date +%H)
    start_hour=${UPDATE_WINDOW_START%%:*}
    end_hour=${UPDATE_WINDOW_END%%:*}
    
    if [[ "$start_hour" -le "$end_hour" ]]; then
        [[ "$current_hour" -ge "$start_hour" ]] && [[ "$current_hour" -lt "$end_hour" ]]
    else
        [[ "$current_hour" -ge "$start_hour" ]] || [[ "$current_hour" -lt "$end_hour" ]]
    fi
}

# Run hooks
run_hooks() {
    local hook_type="$1"
    local hooks_dir="${CONFIG_DIR}/hooks.d/${hook_type}"
    
    [[ ! -d "$hooks_dir" ]] && return 0
    
    for hook in "$hooks_dir"/*; do
        [[ -x "$hook" ]] && "$hook" || log_warn "Hook failed: $hook"
    done
}

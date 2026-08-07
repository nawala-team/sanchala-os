#!/bin/bash
# SPDX-License-Identifier: GPL-3.0
# Sanchala OS Updater - Notification System

# Notification methods
readonly NOTIFY_DESKTOP="${NOTIFY_DESKTOP:-true}"
readonly NOTIFY_SYSTEM="${NOTIFY_SYSTEM:-true}"

# Send desktop notification
send_desktop_notification() {
    local title="$1"
    local message="$2"
    local urgency="${3:-normal}"
    local icon="${4:-system-software-update}"
    
    # Try notify-send for desktop users
    if command -v notify-send &>/dev/null; then
        # Send to all logged-in users
        for user in $(who | awk '{print $1}' | sort -u); do
            local uid
            uid=$(id -u "$user" 2>/dev/null) || continue
            
            sudo -u "$user" DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/${uid}/bus" \
                notify-send -u "$urgency" -i "$icon" "$title" "$message" 2>/dev/null || true
        done
    fi
}

# Write to system log
log_to_system() {
    local message="$1"
    local priority="${2:-info}"
    
    if command -v logger &>/dev/null; then
        logger -t "sanchala-updater" -p "user.${priority}" "$message"
    fi
}

# Notify: Updates available
notify_updates_available() {
    local count
    count=$(pacman -Qu 2>/dev/null | wc -l)
    
    local message="$count system update(s) available"
    
    [[ "$NOTIFY_DESKTOP" == "true" ]] && \
        send_desktop_notification "Updates Available" "$message" "normal" "software-update-available"
    
    [[ "$NOTIFY_SYSTEM" == "true" ]] && \
        log_to_system "$message" "info"
}

# Notify: Update complete
notify_update_complete() {
    local message="System has been updated successfully"
    
    [[ "$NOTIFY_DESKTOP" == "true" ]] && \
        send_desktop_notification "Update Complete" "$message" "normal" "emblem-ok-symbolic"
    
    [[ "$NOTIFY_SYSTEM" == "true" ]] && \
        log_to_system "$message" "info"
}

# Notify: Update failed
notify_update_failed() {
    local snapshot_num="$1"
    local message="System update failed. Rollback available: snapshot #${snapshot_num}"
    
    [[ "$NOTIFY_DESKTOP" == "true" ]] && \
        send_desktop_notification "Update Failed" "$message" "critical" "dialog-error"
    
    [[ "$NOTIFY_SYSTEM" == "true" ]] && \
        log_to_system "$message" "err"
}

# Notify: Reboot required
notify_reboot_required() {
    local message="A system reboot is required to complete the update"
    
    [[ "$NOTIFY_DESKTOP" == "true" ]] && \
        send_desktop_notification "Reboot Required" "$message" "normal" "system-reboot"
    
    [[ "$NOTIFY_SYSTEM" == "true" ]] && \
        log_to_system "$message" "notice"
    
    # Create marker file for other tools
    touch /run/reboot-required
}

# Notify: Rollback complete
notify_rollback_complete() {
    local snapshot_num="$1"
    local message="System rolled back to snapshot #${snapshot_num}. Reboot to apply."
    
    [[ "$NOTIFY_DESKTOP" == "true" ]] && \
        send_desktop_notification "Rollback Prepared" "$message" "normal" "edit-undo"
    
    [[ "$NOTIFY_SYSTEM" == "true" ]] && \
        log_to_system "$message" "notice"
}

# Notify: Low disk space warning
notify_low_disk_space() {
    local free_space="$1"
    local message="Low disk space: ${free_space}GB free. Consider cleaning up."
    
    [[ "$NOTIFY_DESKTOP" == "true" ]] && \
        send_desktop_notification "Low Disk Space" "$message" "critical" "drive-harddisk"
    
    [[ "$NOTIFY_SYSTEM" == "true" ]] && \
        log_to_system "$message" "warning"
}

#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-3.0
# Sanchala Backup - Restore and Rollback Functions

#######################################
# Restore file from snapshot
#######################################
cmd_restore() {
    local config="$1" id="$2" target_path="${3:-}"
    
    [[ -z "$id" ]] && { print_error "Snapshot ID required"; exit 1; }
    [[ -z "$target_path" ]] && { print_error "Path to restore required"; exit 1; }
    
    local subvol=$(get_subvolume_path "$config")
    local snap_path="${subvol}/.snapshots/${id}/snapshot${target_path}"
    
    if [[ ! -e "$snap_path" ]]; then
        print_error "Path not found in snapshot #$id: $target_path"
        exit 1
    fi

    # Backup current file
    if [[ -e "$target_path" ]]; then
        local backup="${target_path}.backup.$(date +%s)"
        print_info "Backing up current file to: $backup"
        cp -a "$target_path" "$backup"
    fi

    # Restore from snapshot
    print_info "Restoring $target_path from snapshot #$id..."
    if cp -a "$snap_path" "$target_path"; then
        print_success "Restored: $target_path"
        log_action "RESTORE" "File $target_path from snapshot #$id"
    else
        print_error "Restore failed"
        exit 1
    fi
}

#######################################
# Full system rollback
#######################################
cmd_rollback() {
    local config="$1" id="$2"
    
    [[ -z "$id" ]] && { print_error "Snapshot ID required"; exit 1; }
    [[ "$config" != "root" ]] && { print_error "Rollback only for root config"; exit 1; }

    # Verify snapshot exists
    if ! snapper -c "$config" list | grep -q "^$id "; then
        print_error "Snapshot #$id not found"
        exit 1
    fi

    echo -e "${BOLD}${YELLOW}⚠ SYSTEM ROLLBACK WARNING${NC}"
    echo "================================"
    echo "This will rollback the system to snapshot #$id"
    echo
    echo "What will happen:"
    echo "  • System files will be restored to snapshot state"
    echo "  • A new snapshot of current state will be created"
    echo "  • System will need to reboot"
    echo
    echo "What will NOT change:"
    echo "  • /home (user data)"
    echo "  • /var/log (logs)"
    echo "  • /var/cache (cache)"
    echo

    read -p "Type 'ROLLBACK' to confirm: " confirm
    [[ "$confirm" != "ROLLBACK" ]] && { echo "Cancelled"; exit 0; }

    print_info "Scheduling rollback to snapshot #$id..."
    
    # Use snapper rollback
    if snapper -c root rollback "$id"; then
        print_success "Rollback scheduled successfully"
        log_action "ROLLBACK" "Scheduled rollback to snapshot #$id"
        
        echo
        echo -e "${CYAN}Reboot required to complete rollback${NC}"
        read -p "Reboot now? [y/N] " -n 1 -r; echo
        [[ $REPLY =~ ^[Yy]$ ]] && systemctl reboot
    else
        print_error "Rollback failed"
        exit 1
    fi
}

#######################################
# Add snapshot to GRUB boot menu
#######################################
cmd_boot_entry() {
    local id="$1"
    [[ -z "$id" ]] && { print_error "Snapshot ID required"; exit 1; }
    
    # Check grub-btrfs
    if ! command -v grub-btrfsd &>/dev/null; then
        print_error "grub-btrfs not installed"
        echo "Install with: sudo pacman -S grub-btrfs"
        exit 1
    fi

    print_info "Regenerating GRUB menu with snapshots..."
    
    # Trigger grub-btrfs regeneration
    if grub-mkconfig -o /boot/grub/grub.cfg; then
        print_success "GRUB menu updated"
        print_info "Snapshot #$id available in boot menu"
    else
        print_error "Failed to update GRUB"
        exit 1
    fi
}

#######################################
# Schedule operations
#######################################
cmd_schedule() {
    local action="${1:-show}"
    
    case "$action" in
        show)
            echo -e "${BOLD}Backup Schedule${NC}"
            echo "================"
            echo
            echo "Snapper Timers:"
            systemctl list-timers 'snapper-*' --no-pager 2>/dev/null || echo "  Not available"
            echo
            echo "Remote Backup Timer:"
            systemctl list-timers 'sanchala-backup-*' --no-pager 2>/dev/null || echo "  Not configured"
            ;;
        enable)
            systemctl enable --now snapper-timeline.timer
            systemctl enable --now snapper-cleanup.timer
            print_success "Snapshot timers enabled"
            ;;
        disable)
            systemctl disable --now snapper-timeline.timer
            systemctl disable --now snapper-cleanup.timer
            print_success "Snapshot timers disabled"
            ;;
        *)
            print_error "Unknown: $action"
            echo "Usage: schedule [show|enable|disable]"
            ;;
    esac
}

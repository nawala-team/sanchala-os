#!/bin/bash
# SPDX-License-Identifier: GPL-3.0
# Sanchala OS Updater - Btrfs Snapshot Integration

readonly SNAPPER_CONFIG="root"

# Create pre-update snapshot
create_pre_snapshot() {
    local description="${1:-System update}"
    local snapshot_num
    
    snapshot_num=$(snapper -c "$SNAPPER_CONFIG" create \
        --type pre \
        --cleanup-algorithm number \
        --print-number \
        --description "$description")
    
    echo "$snapshot_num"
}

# Create post-update snapshot
create_post_snapshot() {
    local pre_num="$1"
    local description="${2:-Update completed}"
    local snapshot_num
    
    snapshot_num=$(snapper -c "$SNAPPER_CONFIG" create \
        --type post \
        --pre-number "$pre_num" \
        --cleanup-algorithm number \
        --print-number \
        --description "$description")
    
    # Update GRUB snapshot entries
    update_grub_snapshots
    
    echo "$snapshot_num"
}

# Check if snapshot exists
snapshot_exists() {
    local num="$1"
    snapper -c "$SNAPPER_CONFIG" list | awk '{print $1}' | grep -q "^${num}$"
}

# Get snapshot info
snapshot_info() {
    local num="$1"
    snapper -c "$SNAPPER_CONFIG" list --columns number,date,type,description | grep "^${num} "
}

# Perform system rollback
perform_rollback() {
    local snapshot_num="$1"
    
    # Use snapper's rollback functionality
    # This creates a new snapshot from the target and sets it as default
    snapper -c "$SNAPPER_CONFIG" rollback "$snapshot_num"
    
    # Update GRUB to reflect rollback
    update_grub_snapshots
    
    # Mark for reboot
    touch /run/reboot-required
    
    return 0
}

# Update GRUB with current snapshots
update_grub_snapshots() {
    # Trigger grub-btrfs to update snapshot entries
    if systemctl is-active grub-btrfsd &>/dev/null; then
        systemctl restart grub-btrfsd
    elif command -v grub-mkconfig &>/dev/null; then
        grub-mkconfig -o /boot/grub/grub.cfg 2>/dev/null || true
    fi
}

# List available snapshots for rollback
list_rollback_snapshots() {
    echo "Available snapshots:"
    echo ""
    snapper -c "$SNAPPER_CONFIG" list --columns number,date,type,cleanup,description
}

# Compare two snapshots
compare_snapshots() {
    local snap1="$1"
    local snap2="$2"
    
    snapper -c "$SNAPPER_CONFIG" diff "$snap1".."$snap2"
}

# Restore specific files from snapshot
restore_files_from_snapshot() {
    local snapshot_num="$1"
    shift
    local files=("$@")
    
    for file in "${files[@]}"; do
        snapper -c "$SNAPPER_CONFIG" undochange "${snapshot_num}..0" "$file"
    done
}

# Cleanup old snapshots
cleanup_snapshots() {
    snapper -c "$SNAPPER_CONFIG" cleanup timeline
    snapper -c "$SNAPPER_CONFIG" cleanup number
}

# Get snapshot mount path
get_snapshot_path() {
    local num="$1"
    echo "/.snapshots/${num}/snapshot"
}

# Check snapshot health
verify_snapshot() {
    local num="$1"
    local path
    path=$(get_snapshot_path "$num")
    
    [[ -d "$path" ]] && [[ -f "${path}/etc/os-release" ]]
}

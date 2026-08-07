#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-3.0
# Sanchala Backup - Snapshot Functions

#######################################
# List all snapshots
#######################################
cmd_list_snapshots() {
    local config="$1" json="$2"
    shift 2
    
    if ! snapper_config_exists "$config"; then
        print_error "Config '$config' not found"; exit 1
    fi

    if [[ "$json" == "true" ]]; then
        snapper -c "$config" --jsonout list
    else
        echo -e "${BOLD}Snapshots for '$config'${NC}"
        echo "=========================="
        snapper -c "$config" list --columns number,type,pre-number,date,cleanup,description
    fi
}

#######################################
# Create a new snapshot
#######################################
cmd_create_snapshot() {
    local config="$1"; shift
    local desc="" type="single" cleanup="timeline"

    while [[ $# -gt 0 ]]; do
        case "$1" in
            -d|--description) desc="$2"; shift 2 ;;
            -t|--type) type="$2"; shift 2 ;;
            --cleanup) cleanup="$2"; shift 2 ;;
            *) desc="${desc:-$*}"; break ;;
        esac
    done
    
    [[ -z "$desc" ]] && desc="Manual snapshot $(date '+%Y-%m-%d %H:%M')"

    print_info "Creating snapshot..."
    local num
    num=$(snapper -c "$config" create --type "$type" \
        --cleanup-algorithm "$cleanup" \
        --description "$desc" --print-number)
    
    if [[ $? -eq 0 ]]; then
        print_success "Snapshot #$num created"
        log_action "CREATE" "Snapshot #$num: $desc"
        echo "$num"
    else
        print_error "Failed to create snapshot"; exit 1
    fi
}

#######################################
# Delete a snapshot
#######################################
cmd_delete_snapshot() {
    local config="$1" id="$2"
    [[ -z "$id" ]] && { print_error "Snapshot ID required"; exit 1; }
    
    if ! snapper -c "$config" list | grep -q "^$id "; then
        print_error "Snapshot #$id not found"; exit 1
    fi

    echo -e "${YELLOW}Warning: Delete snapshot #$id permanently?${NC}"
    read -p "[y/N] " -n 1 -r; echo
    [[ ! $REPLY =~ ^[Yy]$ ]] && { echo "Cancelled"; exit 0; }

    if snapper -c "$config" delete "$id"; then
        print_success "Snapshot #$id deleted"
        log_action "DELETE" "Snapshot #$id"
    else
        print_error "Delete failed"; exit 1
    fi
}

#######################################
# Show snapshot info
#######################################
cmd_snapshot_info() {
    local config="$1" id="$2"
    [[ -z "$id" ]] && { print_error "Snapshot ID required"; exit 1; }
    
    local subvol path
    subvol=$(get_subvolume_path "$config")
    path="${subvol}/.snapshots/${id}/snapshot"

    echo -e "${BOLD}Snapshot #$id Details${NC}"
    echo "======================"
    snapper -c "$config" list | grep "^$id "
    
    if [[ -d "$path" ]]; then
        echo -e "\n${CYAN}Path:${NC} $path"
        command -v btrfs &>/dev/null && {
            local info=$(btrfs subvolume show "$path" 2>/dev/null)
            echo "UUID: $(echo "$info" | grep "UUID:" | head -1 | awk '{print $2}')"
        }
    fi
}

#######################################
# Compare two snapshots
#######################################
cmd_compare_snapshots() {
    local config="$1" id1="$2" id2="$3"
    [[ -z "$id1" || -z "$id2" ]] && { print_error "Two IDs required"; exit 1; }
    
    echo -e "${BOLD}Comparing #$id1 → #$id2${NC}"
    snapper -c "$config" diff "$id1..$id2"
}

#######################################
# Browse snapshot
#######################################
cmd_browse_snapshot() {
    local config="$1" id="$2" path="${3:-}"
    [[ -z "$id" ]] && { print_error "Snapshot ID required"; exit 1; }
    
    local subvol snap_path
    subvol=$(get_subvolume_path "$config")
    snap_path="${subvol}/.snapshots/${id}/snapshot${path}"
    
    [[ ! -e "$snap_path" ]] && { print_error "Path not found"; exit 1; }
    
    echo -e "${BOLD}Browsing Snapshot #$id${NC}: $snap_path"
    ls -la "$snap_path"
}

#######################################
# Cleanup old snapshots
#######################################
cmd_cleanup() {
    local config="$1"; shift
    local algo="timeline" dry=false
    
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --algorithm) algo="$2"; shift 2 ;;
            --dry-run) dry=true; shift ;;
            *) shift ;;
        esac
    done

    echo -e "${BOLD}Cleaning snapshots ($algo)${NC}"
    if $dry; then
        snapper -c "$config" cleanup "$algo" --dry-run
    else
        snapper -c "$config" cleanup "$algo"
        print_success "Cleanup completed"
    fi
}

#######################################
# Verify snapshots
#######################################
cmd_verify() {
    local config="$1"
    local subvol=$(get_subvolume_path "$config")
    
    echo -e "${BOLD}Verifying Snapshot Integrity${NC}"
    
    print_info "Checking Btrfs..."
    if btrfs device stats "$subvol" 2>/dev/null | grep -v " 0$"; then
        print_error "Errors detected! Run: sudo btrfs scrub start $subvol"
    else
        print_success "No filesystem errors"
    fi
}

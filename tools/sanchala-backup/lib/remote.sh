#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-3.0
# Sanchala Backup - Remote & Cloud Backup Functions

REMOTE_CONFIG="/etc/sanchala/backup-remotes.conf"
RCLONE_CONFIG="/etc/sanchala/rclone.conf"

cmd_remote() {
    local action="${1:-list}"; shift || true
    case "$action" in
        list) remote_list ;;
        add) remote_add "$@" ;;
        remove) remote_remove "$@" ;;
        backup) remote_backup "$@" ;;
        status) remote_status ;;
        *) print_error "Unknown: remote $action"; exit 1 ;;
    esac
}

cmd_cloud() {
    local action="${1:-status}"; shift || true
    case "$action" in
        setup) cloud_setup "$@" ;;
        sync) cloud_sync "$@" ;;
        status) cloud_status ;;
        *) print_error "Unknown: cloud $action"; exit 1 ;;
    esac
}

remote_list() {
    echo -e "${BOLD}Remote Targets${NC}"
    [[ ! -f "$REMOTE_CONFIG" ]] && { echo "None configured"; return; }
    while IFS='|' read -r name type target enabled; do
        [[ "$name" =~ ^# ]] && continue
        echo "  $name ($type) → $target [${enabled}]"
    done < "$REMOTE_CONFIG"
}

remote_add() {
    echo -e "${BOLD}Add Remote Target${NC}"
    read -p "Name: " name
    read -p "Type (local/ssh/restic/rclone): " type
    read -p "Path/URL: " target
    mkdir -p "$(dirname "$REMOTE_CONFIG")"
    echo "${name}|${type}|${target}|yes" >> "$REMOTE_CONFIG"
    print_success "Added '$name'"
}

remote_remove() {
    local name="$1"
    [[ -z "$name" ]] && { print_error "Name required"; exit 1; }
    sed -i "/^${name}|/d" "$REMOTE_CONFIG"
    print_success "Removed '$name'"
}

remote_backup() {
    local target="${1:-}"
    require_cmd restic
    [[ -z "$target" ]] && target=$(head -1 "$REMOTE_CONFIG" 2>/dev/null | cut -d'|' -f1)
    [[ -z "$target" ]] && { print_error "No target"; exit 1; }
    
    local repo=$(grep "^${target}|" "$REMOTE_CONFIG" | cut -d'|' -f3)
    print_info "Backing up to '$target'..."
    
    restic -r "$repo" backup / \
        --exclude='/dev' --exclude='/proc' --exclude='/sys' \
        --exclude='/tmp' --exclude='/run' --exclude='/mnt' \
        --exclude='/var/cache' --exclude='/home/*/.cache' \
        --verbose && print_success "Backup done" || { print_error "Failed"; exit 1; }
}

remote_status() {
    echo -e "${BOLD}Remote Status${NC}"
    [[ ! -f "$REMOTE_CONFIG" ]] && { echo "Not configured"; return; }
    local repo=$(head -1 "$REMOTE_CONFIG" | cut -d'|' -f3)
    command -v restic &>/dev/null && restic -r "$repo" snapshots --last 5 2>/dev/null
}

cloud_setup() {
    require_cmd rclone
    echo "Providers: gdrive, onedrive, dropbox, s3, b2"
    rclone config --config "$RCLONE_CONFIG"
    print_success "Cloud configured"
}

cloud_sync() {
    require_cmd rclone
    [[ ! -f "$RCLONE_CONFIG" ]] && { print_error "Run: cloud setup"; exit 1; }
    local remote=$(rclone --config "$RCLONE_CONFIG" listremotes | head -1 | tr -d ':')
    print_info "Syncing to $remote..."
    rclone sync /home "${remote}:sanchala-backup/home" \
        --config "$RCLONE_CONFIG" --exclude '.cache/**' --progress
    print_success "Sync done"
}

cloud_status() {
    echo -e "${BOLD}Cloud Status${NC}"
    [[ ! -f "$RCLONE_CONFIG" ]] && { echo "Not configured"; return; }
    rclone --config "$RCLONE_CONFIG" listremotes | sed 's/^/  /'
}

#!/bin/bash
# core.sh - Core migration functions for sanchala-migrate
# Part of SANCHALA OS

# Calculate directory size
get_size() {
    du -sh "$1" 2>/dev/null | cut -f1
}

# Safe copy with verification
safe_copy() {
    local src="$1" dst="$2"
    mkdir -p "$(dirname "$dst")"
    if rsync -av --checksum "$src" "$dst"; then
        return 0
    else
        return 1
    fi
}

# Create migration checkpoint
create_checkpoint() {
    local name="$1"
    local state_file="${DATA_DIR}/state.json"
    cat > "$state_file" << EOF
{
    "checkpoint": "${name}",
    "timestamp": "$(date -Iseconds)",
    "source": "${MIGRATE_SOURCE:-unknown}",
    "status": "in_progress"
}
EOF
}

# Update migration state
update_state() {
    local key="$1" value="$2"
    local state_file="${DATA_DIR}/state.json"
    [[ -f "$state_file" ]] && {
        local tmp=$(mktemp)
        jq ".${key} = \"${value}\"" "$state_file" > "$tmp" && mv "$tmp" "$state_file"
    }
}

# Verify file integrity
verify_file() {
    local src="$1" dst="$2"
    local src_hash=$(sha256sum "$src" 2>/dev/null | cut -d' ' -f1)
    local dst_hash=$(sha256sum "$dst" 2>/dev/null | cut -d' ' -f1)
    [[ "$src_hash" == "$dst_hash" ]]
}

# Map Windows path to Linux
map_windows_path() {
    local win_path="$1"
    case "$win_path" in
        */Documents) echo "$HOME/Documents" ;;
        */Downloads) echo "$HOME/Downloads" ;;
        */Pictures)  echo "$HOME/Pictures" ;;
        */Music)     echo "$HOME/Music" ;;
        */Videos)    echo "$HOME/Videos" ;;
        */Desktop)   echo "$HOME/Desktop" ;;
        *)           echo "$HOME/Migrated/$(basename "$win_path")" ;;
    esac
}

# Map macOS path to Linux
map_macos_path() {
    local mac_path="$1"
    case "$mac_path" in
        */Documents) echo "$HOME/Documents" ;;
        */Downloads) echo "$HOME/Downloads" ;;
        */Pictures)  echo "$HOME/Pictures" ;;
        */Music)     echo "$HOME/Music" ;;
        */Movies)    echo "$HOME/Videos" ;;
        */Desktop)   echo "$HOME/Desktop" ;;
        *)           echo "$HOME/Migrated/$(basename "$mac_path")" ;;
    esac
}

#!/bin/bash
# documents.sh - Document migration functions for sanchala-migrate
# Part of SANCHALA OS

# Standard folder mappings
FOLDER_MAP_WINDOWS=(
    "Documents:Documents"
    "Downloads:Downloads"
    "Pictures:Pictures"
    "Music:Music"
    "Videos:Videos"
    "Desktop:Desktop"
)

FOLDER_MAP_MACOS=(
    "Documents:Documents"
    "Downloads:Downloads"
    "Pictures:Pictures"
    "Music:Music"
    "Movies:Videos"
    "Desktop:Desktop"
)

# Migrate documents from Windows
migrate_windows_documents() {
    local source="$1" user="$2" dry_run="${3:-false}"
    local user_dir="${source}/Users/${user}"
    
    [[ ! -d "$user_dir" ]] && { echo "User directory not found: $user_dir"; return 1; }
    
    for mapping in "${FOLDER_MAP_WINDOWS[@]}"; do
        local src_folder="${mapping%%:*}"
        local dst_folder="${mapping##*:}"
        local src_path="${user_dir}/${src_folder}"
        local dst_path="$HOME/${dst_folder}"
        
        if [[ -d "$src_path" ]]; then
            local size=$(du -sh "$src_path" 2>/dev/null | cut -f1)
            echo "  ${src_folder} (${size}) → ${dst_folder}"
            
            if [[ "$dry_run" != "true" ]]; then
                mkdir -p "$dst_path"
                rsync -av --progress "$src_path/" "$dst_path/"
            fi
        fi
    done
}

# Migrate documents from macOS
migrate_macos_documents() {
    local source="$1" user="$2" dry_run="${3:-false}"
    local user_dir="${source}/Users/${user}"
    
    [[ ! -d "$user_dir" ]] && { echo "User directory not found: $user_dir"; return 1; }
    
    for mapping in "${FOLDER_MAP_MACOS[@]}"; do
        local src_folder="${mapping%%:*}"
        local dst_folder="${mapping##*:}"
        local src_path="${user_dir}/${src_folder}"
        local dst_path="$HOME/${dst_folder}"
        
        if [[ -d "$src_path" ]]; then
            local size=$(du -sh "$src_path" 2>/dev/null | cut -f1)
            echo "  ${src_folder} (${size}) → ${dst_folder}"
            
            if [[ "$dry_run" != "true" ]]; then
                mkdir -p "$dst_path"
                rsync -av --progress "$src_path/" "$dst_path/"
            fi
        fi
    done
}

# Migrate custom fonts
migrate_fonts() {
    local source="$1" os_type="$2" user="$3"
    local fonts_dir="$HOME/.local/share/fonts/migrated"
    
    mkdir -p "$fonts_dir"
    
    case "$os_type" in
        windows*)
            local win_fonts="${source}/Windows/Fonts"
            [[ -d "$win_fonts" ]] && {
                echo "Migrating Windows fonts..."
                find "$win_fonts" -type f \( -name "*.ttf" -o -name "*.otf" \) \
                    -exec cp {} "$fonts_dir/" \;
            }
            ;;
        macos*)
            local mac_fonts="${source}/Users/${user}/Library/Fonts"
            [[ -d "$mac_fonts" ]] && {
                echo "Migrating macOS fonts..."
                find "$mac_fonts" -type f \( -name "*.ttf" -o -name "*.otf" \) \
                    -exec cp {} "$fonts_dir/" \;
            }
            ;;
    esac
    
    # Refresh font cache
    fc-cache -f "$fonts_dir" 2>/dev/null
}

# Migrate SSH keys (with caution)
migrate_ssh() {
    local source="$1" user="$2" os_type="$3"
    local ssh_src=""
    
    case "$os_type" in
        windows*) ssh_src="${source}/Users/${user}/.ssh" ;;
        macos*|linux*) ssh_src="${source}/Users/${user}/.ssh" ;;
    esac
    
    [[ ! -d "$ssh_src" ]] && { echo "No SSH keys found"; return 0; }
    
    echo "Found SSH keys in ${ssh_src}"
    echo "WARNING: SSH keys are sensitive. Review before migrating."
    echo "Files found:"
    ls -la "$ssh_src"
    echo
    echo "To migrate manually:"
    echo "  cp -r '${ssh_src}' ~/.ssh"
    echo "  chmod 700 ~/.ssh && chmod 600 ~/.ssh/*"
}

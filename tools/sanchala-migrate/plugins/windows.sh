#!/bin/bash
# windows.sh - Windows-specific migration plugin for sanchala-migrate
# Part of SANCHALA OS

# Windows user folder locations
WIN_USER_FOLDERS=(Documents Downloads Pictures Music Videos Desktop)

# Analyze Windows installation
analyze_windows() {
    local source="$1"
    local users_dir="${source}/Users"
    
    echo "OS: $(detect_windows_version "$source")"
    echo "Source: ${source}"
    echo
    
    echo "User Profiles:"
    for user in $(find_windows_users "$source"); do
        echo "  • ${user}"
        local user_dir="${users_dir}/${user}"
        
        local total=0
        for folder in "${WIN_USER_FOLDERS[@]}"; do
            if [[ -d "${user_dir}/${folder}" ]]; then
                local size=$(du -sh "${user_dir}/${folder}" 2>/dev/null | cut -f1)
                echo "    ${folder}: ${size}"
            fi
        done
    done
    echo
    
    echo "Browsers:"
    for user in $(find_windows_users "$source"); do
        for browser in $(detect_windows_browsers "$source" "$user"); do
            echo "  • ${browser^} (${user})"
        done
    done
    echo
    
    echo "Ready to migrate: sanchala-migrate --source ${source} --type windows"
}

# Full Windows migration
migrate_windows() {
    local source="$1" include="${2:-all}"
    local users_dir="${source}/Users"
    
    echo "Starting Windows migration..."
    echo
    
    # Find users
    local users=($(find_windows_users "$source"))
    
    if [[ ${#users[@]} -eq 0 ]]; then
        log ERROR "No user profiles found"
        return 1
    fi
    
    # If multiple users, use first or ask
    local selected_user="${users[0]}"
    if [[ ${#users[@]} -gt 1 ]]; then
        echo "Multiple users found: ${users[*]}"
        echo "Migrating from: ${selected_user}"
    fi
    
    local user_dir="${users_dir}/${selected_user}"
    
    # Migrate based on include list
    case "$include" in
        all)
            migrate_windows_documents "$source" "$selected_user" "$DRY_RUN"
            migrate_windows_browsers "$source" "$selected_user"
            migrate_windows_wifi "$source"
            migrate_fonts "$source" "windows" "$selected_user"
            ;;
        documents)
            migrate_windows_documents "$source" "$selected_user" "$DRY_RUN"
            ;;
        browser)
            migrate_windows_browsers "$source" "$selected_user"
            ;;
        settings)
            migrate_windows_wifi "$source"
            migrate_windows_shortcuts
            ;;
    esac
}

# Migrate Windows browsers
migrate_windows_browsers() {
    local source="$1" user="$2"
    local user_dir="${source}/Users/${user}"
    
    echo "Browser data migration:"
    
    # Chrome
    local chrome_dir="${user_dir}/AppData/Local/Google/Chrome/User Data"
    if [[ -d "$chrome_dir" ]]; then
        echo "  Chrome found - exporting bookmarks..."
        export_chrome_bookmarks "$chrome_dir" "$HOME/chrome-bookmarks.html" 2>/dev/null || \
            echo "    Manual import recommended"
    fi
    
    # Firefox
    local firefox_dir="${user_dir}/AppData/Roaming/Mozilla/Firefox/Profiles"
    if [[ -d "$firefox_dir" ]]; then
        echo "  Firefox found - exporting bookmarks..."
        export_firefox_bookmarks "$firefox_dir" "$HOME/firefox-bookmarks.html" 2>/dev/null || \
            echo "    Manual import recommended"
    fi
    
    # Edge
    local edge_dir="${user_dir}/AppData/Local/Microsoft/Edge/User Data"
    if [[ -d "$edge_dir" ]]; then
        echo "  Edge found (Chromium-based)"
        echo "    Use Edge's export feature or sync with Microsoft account"
    fi
    
    echo
    echo "Import bookmarks in your browser's settings"
}

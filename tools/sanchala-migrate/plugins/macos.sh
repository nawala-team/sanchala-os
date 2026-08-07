#!/bin/bash
# macos.sh - macOS-specific migration plugin for sanchala-migrate
# Part of SANCHALA OS

# macOS user folder locations
MAC_USER_FOLDERS=(Documents Downloads Pictures Music Movies Desktop)

# Analyze macOS installation
analyze_macos() {
    local source="$1"
    local users_dir="${source}/Users"
    
    echo "OS: $(detect_macos_version "$source")"
    echo "Source: ${source}"
    echo
    
    echo "User Profiles:"
    for user in $(find_macos_users "$source"); do
        echo "  • ${user}"
        local user_dir="${users_dir}/${user}"
        
        for folder in "${MAC_USER_FOLDERS[@]}"; do
            if [[ -d "${user_dir}/${folder}" ]]; then
                local size=$(du -sh "${user_dir}/${folder}" 2>/dev/null | cut -f1)
                echo "    ${folder}: ${size}"
            fi
        done
    done
    echo
    
    echo "Browsers:"
    for user in $(find_macos_users "$source"); do
        for browser in $(detect_macos_browsers "$source" "$user"); do
            echo "  • ${browser^} (${user})"
        done
    done
    echo
    
    echo "Ready to migrate: sanchala-migrate --source ${source} --type macos"
}

# Full macOS migration
migrate_macos() {
    local source="$1" include="${2:-all}"
    local users_dir="${source}/Users"
    
    echo "Starting macOS migration..."
    echo
    
    local users=($(find_macos_users "$source"))
    
    if [[ ${#users[@]} -eq 0 ]]; then
        log ERROR "No user profiles found"
        return 1
    fi
    
    local selected_user="${users[0]}"
    if [[ ${#users[@]} -gt 1 ]]; then
        echo "Multiple users found: ${users[*]}"
        echo "Migrating from: ${selected_user}"
    fi
    
    case "$include" in
        all)
            migrate_macos_documents "$source" "$selected_user" "$DRY_RUN"
            migrate_macos_browsers "$source" "$selected_user"
            migrate_macos_wifi "$source"
            migrate_fonts "$source" "macos" "$selected_user"
            ;;
        documents)
            migrate_macos_documents "$source" "$selected_user" "$DRY_RUN"
            ;;
        browser)
            migrate_macos_browsers "$source" "$selected_user"
            ;;
        settings)
            migrate_macos_wifi "$source"
            migrate_macos_shortcuts
            ;;
    esac
}

# Migrate macOS browsers
migrate_macos_browsers() {
    local source="$1" user="$2"
    local user_dir="${source}/Users/${user}"
    
    echo "Browser data migration:"
    
    # Safari
    local safari_dir="${user_dir}/Library/Safari"
    if [[ -d "$safari_dir" ]]; then
        echo "  Safari found"
        if [[ -f "${safari_dir}/Bookmarks.plist" ]]; then
            echo "    Bookmarks available (plist format)"
            echo "    Convert: plutil -convert xml1 '${safari_dir}/Bookmarks.plist'"
        fi
    fi
    
    # Chrome
    local chrome_dir="${user_dir}/Library/Application Support/Google/Chrome"
    if [[ -d "$chrome_dir" ]]; then
        echo "  Chrome found - exporting bookmarks..."
        export_chrome_bookmarks "$chrome_dir" "$HOME/chrome-bookmarks.html" 2>/dev/null || \
            echo "    Manual export recommended"
    fi
    
    # Firefox
    local firefox_dir="${user_dir}/Library/Application Support/Firefox/Profiles"
    if [[ -d "$firefox_dir" ]]; then
        echo "  Firefox found - exporting bookmarks..."
        export_firefox_bookmarks "$firefox_dir" "$HOME/firefox-bookmarks.html" 2>/dev/null || \
            echo "    Manual export recommended"
    fi
    
    echo
    echo "Import bookmarks in your browser's settings"
}

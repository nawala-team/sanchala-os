#!/bin/bash
# safari.sh - Safari browser import plugin (macOS source only)
# Part of SANCHALA OS - sanchala-migrate

# Find Safari data directory
find_safari_profile() {
    local source="${1:-}"
    local user="${2:-}"
    
    local paths=(
        "${source}/Users/${user}/Library/Safari"
        "${source}/Library/Safari"
    )
    
    for path in "${paths[@]}"; do
        [[ -d "$path" ]] && { echo "$path"; return 0; }
    done
    return 1
}

# Export Safari bookmarks (requires plist conversion)
safari_export_bookmarks() {
    local safari_dir="$1"
    local output="${2:-$HOME/safari-bookmarks.html}"
    
    local bookmarks_plist="${safari_dir}/Bookmarks.plist"
    [[ ! -f "$bookmarks_plist" ]] && { echo "Bookmarks.plist not found"; return 1; }
    
    # Check if we can read plist
    if command -v plutil &>/dev/null; then
        # Convert binary plist to XML
        local tmp=$(mktemp)
        plutil -convert xml1 "$bookmarks_plist" -o "$tmp"
        
        # Parse XML (simplified)
        echo "Safari bookmarks found. Manual conversion needed."
        echo "Plist file: ${bookmarks_plist}"
        rm -f "$tmp"
    elif command -v plistutil &>/dev/null; then
        # Use plistutil on Linux
        local tmp=$(mktemp)
        plistutil -i "$bookmarks_plist" -o "$tmp"
        echo "Converted plist to: ${tmp}"
        echo "Manual parsing required for HTML export"
    else
        echo "Safari bookmarks export requires:"
        echo "  - plistutil (install: sudo pacman -S libplist)"
        echo "  - Or export bookmarks from Safari on macOS first"
        echo
        echo "On macOS: File → Export Bookmarks..."
    fi
}

# Safari reading list
safari_export_reading_list() {
    local safari_dir="$1"
    
    local bookmarks_plist="${safari_dir}/Bookmarks.plist"
    [[ ! -f "$bookmarks_plist" ]] && { echo "Bookmarks.plist not found"; return 1; }
    
    echo "Safari Reading List is stored in Bookmarks.plist"
    echo "Export from Safari on macOS for best results"
}

# Safari history
safari_export_history() {
    local safari_dir="$1"
    local output="${2:-$HOME/safari-history.txt}"
    
    local history_db="${safari_dir}/History.db"
    [[ ! -f "$history_db" ]] && { echo "History.db not found"; return 1; }
    
    # Copy to avoid lock issues
    local tmp=$(mktemp)
    cp "$history_db" "$tmp"
    
    sqlite3 "$tmp" "
        SELECT datetime(visit_time + 978307200, 'unixepoch'), url, title
        FROM history_visits
        JOIN history_items ON history_visits.history_item = history_items.id
        ORDER BY visit_time DESC
        LIMIT 1000;
    " > "$output" 2>/dev/null || {
        echo "Could not read Safari history"
        rm -f "$tmp"
        return 1
    }
    
    rm -f "$tmp"
    echo "History exported to: ${output}"
}

# Safari passwords (Keychain)
safari_export_passwords() {
    echo "Safari passwords are stored in macOS Keychain"
    echo
    echo "To export Safari passwords:"
    echo "  1. On macOS: System Preferences → Passwords"
    echo "  2. Or: Safari → Preferences → Passwords"
    echo "  3. Select all, export to CSV (macOS 12+)"
    echo "  4. Import to Firefox/Chrome or KeePassXC on Sanchala OS"
    echo
    echo "Note: Keychain export requires macOS access"
}

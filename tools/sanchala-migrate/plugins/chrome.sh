#!/bin/bash
# chrome.sh - Chrome/Chromium browser import plugin
# Part of SANCHALA OS - sanchala-migrate

# Find Chrome profile directory
find_chrome_profile() {
    local source="${1:-}"
    
    # Check common locations
    local paths=(
        # Windows
        "${source}/AppData/Local/Google/Chrome/User Data"
        # macOS
        "${source}/Library/Application Support/Google/Chrome"
        # Linux
        "${source}/.config/google-chrome"
        "$HOME/.config/google-chrome"
    )
    
    for path in "${paths[@]}"; do
        [[ -d "$path" ]] && { echo "$path"; return 0; }
    done
    
    return 1
}

# List Chrome profiles
list_chrome_profiles() {
    local chrome_dir="$1"
    
    echo "Chrome profiles in ${chrome_dir}:"
    for profile in "${chrome_dir}"/*/; do
        local name=$(basename "$profile")
        [[ "$name" == "System Profile" || "$name" == "Crashpad" ]] && continue
        [[ -f "${profile}/Preferences" ]] && echo "  • ${name}"
    done
}

# Export Chrome bookmarks
chrome_export_bookmarks() {
    local chrome_dir="$1"
    local output="${2:-$HOME/chrome-bookmarks.html}"
    local profile="${3:-Default}"
    
    local bookmarks="${chrome_dir}/${profile}/Bookmarks"
    [[ ! -f "$bookmarks" ]] && { echo "Bookmarks not found"; return 1; }
    
    python3 -c "
import json, html, sys

with open('${bookmarks}') as f:
    data = json.load(f)

def convert(node, depth=0):
    out = ''
    t = node.get('type', '')
    if t == 'folder':
        out += '  '*depth + '<DT><H3>' + html.escape(node.get('name','')) + '</H3>\\n'
        out += '  '*depth + '<DL><p>\\n'
        for c in node.get('children', []):
            out += convert(c, depth+1)
        out += '  '*depth + '</DL><p>\\n'
    elif t == 'url':
        out += '  '*depth + '<DT><A HREF=\"' + html.escape(node.get('url','')) + '\">'
        out += html.escape(node.get('name','')) + '</A>\\n'
    return out

print('''<!DOCTYPE NETSCAPE-Bookmark-file-1>
<TITLE>Chrome Bookmarks</TITLE>
<H1>Bookmarks</H1>
<DL><p>''')
for r in ['bookmark_bar','other','synced']:
    if r in data.get('roots',{}):
        print(convert(data['roots'][r]))
print('</DL><p>')
" > "$output"
    
    echo "Exported to: ${output}"
}

# Export Chrome passwords (requires decryption key)
chrome_export_passwords() {
    echo "Chrome password export requires:"
    echo "  1. Chrome's built-in export (chrome://settings/passwords)"
    echo "  2. Or use a password manager's import feature"
    echo
    echo "Recommended: Export as CSV from Chrome, import to KeePassXC"
}

# Export Chrome history
chrome_export_history() {
    local chrome_dir="$1"
    local output="${2:-$HOME/chrome-history.txt}"
    local profile="${3:-Default}"
    
    local history_db="${chrome_dir}/${profile}/History"
    [[ ! -f "$history_db" ]] && { echo "History not found"; return 1; }
    
    # Copy to avoid lock issues
    local tmp=$(mktemp)
    cp "$history_db" "$tmp"
    
    sqlite3 "$tmp" "SELECT datetime(last_visit_time/1000000-11644473600,'unixepoch'), url, title FROM urls ORDER BY last_visit_time DESC LIMIT 1000;" > "$output"
    
    rm -f "$tmp"
    echo "History exported to: ${output}"
}

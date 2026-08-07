#!/bin/bash
# brave.sh - Brave browser import plugin
# Part of SANCHALA OS - sanchala-migrate

# Find Brave profile directory (Chromium-based)
find_brave_profile() {
    local source="${1:-}"
    
    local paths=(
        # Windows
        "${source}/AppData/Local/BraveSoftware/Brave-Browser/User Data"
        # macOS
        "${source}/Library/Application Support/BraveSoftware/Brave-Browser"
        # Linux
        "${source}/.config/BraveSoftware/Brave-Browser"
        "$HOME/.config/BraveSoftware/Brave-Browser"
    )
    
    for path in "${paths[@]}"; do
        [[ -d "$path" ]] && { echo "$path"; return 0; }
    done
    return 1
}

# List Brave profiles
list_brave_profiles() {
    local brave_dir="$1"
    
    echo "Brave profiles in ${brave_dir}:"
    for profile in "${brave_dir}"/*/; do
        local name=$(basename "$profile")
        [[ "$name" == "System Profile" || "$name" == "Crashpad" ]] && continue
        [[ -f "${profile}/Preferences" ]] && echo "  • ${name}"
    done
}

# Export Brave bookmarks (same format as Chrome)
brave_export_bookmarks() {
    local brave_dir="$1"
    local output="${2:-$HOME/brave-bookmarks.html}"
    local profile="${3:-Default}"
    
    local bookmarks="${brave_dir}/${profile}/Bookmarks"
    [[ ! -f "$bookmarks" ]] && { echo "Brave bookmarks not found"; return 1; }
    
    python3 -c "
import json, html

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
<TITLE>Brave Bookmarks</TITLE>
<H1>Bookmarks</H1>
<DL><p>''')
for r in ['bookmark_bar','other','synced']:
    if r in data.get('roots',{}):
        print(convert(data['roots'][r]))
print('</DL><p>')
" > "$output"
    
    echo "Exported to: ${output}"
}

# Export Brave passwords
brave_export_passwords() {
    echo "Brave password export:"
    echo "  1. Open Brave on source system"
    echo "  2. Go to brave://settings/passwords"
    echo "  3. Click ⋯ → Export passwords"
    echo "  4. Import to Firefox or KeePassXC"
}

# Export Brave history
brave_export_history() {
    local brave_dir="$1"
    local output="${2:-$HOME/brave-history.txt}"
    local profile="${3:-Default}"
    
    local history_db="${brave_dir}/${profile}/History"
    [[ ! -f "$history_db" ]] && { echo "History not found"; return 1; }
    
    local tmp=$(mktemp)
    cp "$history_db" "$tmp"
    
    sqlite3 "$tmp" "SELECT datetime(last_visit_time/1000000-11644473600,'unixepoch'), url, title FROM urls ORDER BY last_visit_time DESC LIMIT 1000;" > "$output"
    
    rm -f "$tmp"
    echo "History exported to: ${output}"
}

#!/bin/bash
# edge.sh - Microsoft Edge browser import plugin
# Part of SANCHALA OS - sanchala-migrate

# Find Edge profile directory (Chromium-based)
find_edge_profile() {
    local source="${1:-}"
    
    local paths=(
        # Windows
        "${source}/AppData/Local/Microsoft/Edge/User Data"
        # macOS
        "${source}/Library/Application Support/Microsoft Edge"
        # Linux
        "${source}/.config/microsoft-edge"
        "$HOME/.config/microsoft-edge"
    )
    
    for path in "${paths[@]}"; do
        [[ -d "$path" ]] && { echo "$path"; return 0; }
    done
    return 1
}

# List Edge profiles
list_edge_profiles() {
    local edge_dir="$1"
    
    echo "Edge profiles in ${edge_dir}:"
    for profile in "${edge_dir}"/*/; do
        local name=$(basename "$profile")
        [[ "$name" == "System Profile" || "$name" == "Crashpad" || "$name" == "GrShaderCache" ]] && continue
        [[ -f "${profile}/Preferences" ]] && echo "  • ${name}"
    done
}

# Export Edge bookmarks (same format as Chrome)
edge_export_bookmarks() {
    local edge_dir="$1"
    local output="${2:-$HOME/edge-bookmarks.html}"
    local profile="${3:-Default}"
    
    local bookmarks="${edge_dir}/${profile}/Bookmarks"
    [[ ! -f "$bookmarks" ]] && { echo "Edge bookmarks not found"; return 1; }
    
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
<TITLE>Edge Bookmarks</TITLE>
<H1>Bookmarks</H1>
<DL><p>''')
for r in ['bookmark_bar','other','synced']:
    if r in data.get('roots',{}):
        print(convert(data['roots'][r]))
print('</DL><p>')
" > "$output"
    
    echo "Exported to: ${output}"
}

# Export Edge passwords (manual process)
edge_export_passwords() {
    echo "Edge password export:"
    echo "  1. Open Edge on source system"
    echo "  2. Go to edge://settings/passwords"
    echo "  3. Click ⋯ → Export passwords"
    echo "  4. Save CSV file"
    echo "  5. Import to Firefox or KeePassXC on Sanchala OS"
}

# Export Edge history
edge_export_history() {
    local edge_dir="$1"
    local output="${2:-$HOME/edge-history.txt}"
    local profile="${3:-Default}"
    
    local history_db="${edge_dir}/${profile}/History"
    [[ ! -f "$history_db" ]] && { echo "History not found"; return 1; }
    
    local tmp=$(mktemp)
    cp "$history_db" "$tmp"
    
    sqlite3 "$tmp" "SELECT datetime(last_visit_time/1000000-11644473600,'unixepoch'), url, title FROM urls ORDER BY last_visit_time DESC LIMIT 1000;" > "$output"
    
    rm -f "$tmp"
    echo "History exported to: ${output}"
}

# Export Edge collections
edge_export_collections() {
    local edge_dir="$1"
    local output="${2:-$HOME/edge-collections.json}"
    local profile="${3:-Default}"
    
    local collections="${edge_dir}/${profile}/Collections/collectionsSQLite"
    [[ ! -f "$collections" ]] && { echo "Collections not found"; return 1; }
    
    local tmp=$(mktemp)
    cp "$collections" "$tmp"
    
    sqlite3 "$tmp" "SELECT title, source FROM items;" > "$output"
    
    rm -f "$tmp"
    echo "Collections exported to: ${output}"
}

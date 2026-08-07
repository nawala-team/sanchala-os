#!/bin/bash
# browser.sh - Browser data import functions for sanchala-migrate
# Part of SANCHALA OS

# Get Chrome profile path
get_chrome_profile() {
    local source="$1" user="$2" os_type="$3"
    
    case "$os_type" in
        windows*)
            echo "${source}/Users/${user}/AppData/Local/Google/Chrome/User Data"
            ;;
        macos*)
            echo "${source}/Users/${user}/Library/Application Support/Google/Chrome"
            ;;
        linux*)
            echo "${source}/home/${user}/.config/google-chrome"
            ;;
    esac
}

# Get Firefox profile path
get_firefox_profile() {
    local source="$1" user="$2" os_type="$3"
    
    case "$os_type" in
        windows*)
            echo "${source}/Users/${user}/AppData/Roaming/Mozilla/Firefox/Profiles"
            ;;
        macos*)
            echo "${source}/Users/${user}/Library/Application Support/Firefox/Profiles"
            ;;
        linux*)
            echo "${source}/home/${user}/.mozilla/firefox"
            ;;
    esac
}

# Export Chrome bookmarks to HTML
export_chrome_bookmarks() {
    local profile_dir="$1" output="$2"
    local bookmarks="${profile_dir}/Default/Bookmarks"
    
    [[ ! -f "$bookmarks" ]] && { echo "Chrome bookmarks not found"; return 1; }
    
    # Convert JSON to HTML bookmarks format
    python3 << EOF
import json
import html

with open('${bookmarks}', 'r') as f:
    data = json.load(f)

def process_node(node, indent=0):
    result = ""
    if node.get('type') == 'folder':
        result += '  ' * indent + '<DT><H3>' + html.escape(node.get('name', '')) + '</H3>\n'
        result += '  ' * indent + '<DL><p>\n'
        for child in node.get('children', []):
            result += process_node(child, indent + 1)
        result += '  ' * indent + '</DL><p>\n'
    elif node.get('type') == 'url':
        result += '  ' * indent + '<DT><A HREF="' + html.escape(node.get('url', '')) + '">'
        result += html.escape(node.get('name', '')) + '</A>\n'
    return result

output = '''<!DOCTYPE NETSCAPE-Bookmark-file-1>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
<TITLE>Bookmarks</TITLE>
<H1>Bookmarks</H1>
<DL><p>
'''

roots = data.get('roots', {})
for key in ['bookmark_bar', 'other', 'synced']:
    if key in roots:
        output += process_node(roots[key])

output += '</DL><p>'

with open('${output}', 'w') as f:
    f.write(output)
EOF
    
    echo "Bookmarks exported to ${output}"
}

# Export Firefox bookmarks
export_firefox_bookmarks() {
    local profile_dir="$1" output="$2"
    
    # Find the default profile
    local default_profile=$(find "$profile_dir" -maxdepth 1 -type d -name "*.default*" | head -1)
    [[ -z "$default_profile" ]] && { echo "Firefox profile not found"; return 1; }
    
    local places_db="${default_profile}/places.sqlite"
    [[ ! -f "$places_db" ]] && { echo "Firefox places.sqlite not found"; return 1; }
    
    # Copy database (Firefox locks it)
    local tmp_db=$(mktemp)
    cp "$places_db" "$tmp_db"
    
    # Export bookmarks
    sqlite3 "$tmp_db" << EOF > "$output"
.mode html
SELECT '<DT><A HREF="' || p.url || '">' || b.title || '</A>'
FROM moz_bookmarks b
JOIN moz_places p ON b.fk = p.id
WHERE b.type = 1 AND b.title IS NOT NULL;
EOF
    
    rm -f "$tmp_db"
    echo "Bookmarks exported to ${output}"
}

# Import bookmarks to Firefox
import_to_firefox() {
    local bookmarks_html="$1"
    local firefox_dir="$HOME/.mozilla/firefox"
    
    [[ ! -f "$bookmarks_html" ]] && { echo "Bookmarks file not found"; return 1; }
    
    echo "To import bookmarks in Firefox:"
    echo "  1. Open Firefox"
    echo "  2. Press Ctrl+Shift+O (Bookmarks Manager)"
    echo "  3. Import and Backup → Import Bookmarks from HTML"
    echo "  4. Select: ${bookmarks_html}"
}

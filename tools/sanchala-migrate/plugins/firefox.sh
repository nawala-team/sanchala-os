#!/bin/bash
# firefox.sh - Firefox browser import plugin
# Part of SANCHALA OS - sanchala-migrate

# Find Firefox profile directory
find_firefox_profile() {
    local source="${1:-}"
    
    local paths=(
        "${source}/AppData/Roaming/Mozilla/Firefox/Profiles"
        "${source}/Library/Application Support/Firefox/Profiles"
        "${source}/.mozilla/firefox"
        "$HOME/.mozilla/firefox"
    )
    
    for path in "${paths[@]}"; do
        [[ -d "$path" ]] && { echo "$path"; return 0; }
    done
    return 1
}

# Get default Firefox profile
get_firefox_default_profile() {
    local profiles_dir="$1"
    
    # Check profiles.ini
    local profiles_ini="${profiles_dir}/../profiles.ini"
    if [[ -f "$profiles_ini" ]]; then
        local default=$(grep -A5 "\[Install" "$profiles_ini" | grep "Default=" | cut -d= -f2)
        [[ -n "$default" && -d "${profiles_dir}/../${default}" ]] && { echo "${profiles_dir}/../${default}"; return 0; }
    fi
    
    # Fall back to first .default profile
    for p in "${profiles_dir}"/*.default* ; do
        [[ -d "$p" ]] && { echo "$p"; return 0; }
    done
    return 1
}

# Export Firefox bookmarks
firefox_export_bookmarks() {
    local profiles_dir="$1"
    local output="${2:-$HOME/firefox-bookmarks.html}"
    
    local profile=$(get_firefox_default_profile "$profiles_dir")
    [[ -z "$profile" ]] && { echo "No Firefox profile found"; return 1; }
    
    local places_db="${profile}/places.sqlite"
    [[ ! -f "$places_db" ]] && { echo "places.sqlite not found"; return 1; }
    
    # Copy database (Firefox may lock it)
    local tmp=$(mktemp)
    cp "$places_db" "$tmp"
    
    # Generate HTML bookmarks
    cat > "$output" << 'HEADER'
<!DOCTYPE NETSCAPE-Bookmark-file-1>
<TITLE>Firefox Bookmarks</TITLE>
<H1>Bookmarks</H1>
<DL><p>
HEADER
    
    sqlite3 "$tmp" "
        SELECT '<DT><A HREF=\"' || p.url || '\">' || COALESCE(b.title, p.title, 'Untitled') || '</A>'
        FROM moz_bookmarks b
        JOIN moz_places p ON b.fk = p.id
        WHERE b.type = 1 AND p.url NOT LIKE 'place:%'
        ORDER BY b.position;
    " >> "$output"
    
    echo "</DL><p>" >> "$output"
    rm -f "$tmp"
    
    echo "Bookmarks exported to: ${output}"
}

# Export Firefox passwords
firefox_export_passwords() {
    local profiles_dir="$1"
    
    local profile=$(get_firefox_default_profile "$profiles_dir")
    [[ -z "$profile" ]] && { echo "No Firefox profile found"; return 1; }
    
    echo "Firefox passwords location: ${profile}/logins.json"
    echo
    echo "To export Firefox passwords:"
    echo "  1. Open Firefox on source system"
    echo "  2. Menu → Settings → Privacy & Security → Saved Logins"
    echo "  3. Click ⋯ → Export Logins"
    echo "  4. Import CSV to KeePassXC or Firefox on Sanchala OS"
}

# Copy Firefox profile
firefox_copy_profile() {
    local profiles_dir="$1"
    local dest="$HOME/.mozilla/firefox"
    
    local profile=$(get_firefox_default_profile "$profiles_dir")
    [[ -z "$profile" ]] && { echo "No Firefox profile found"; return 1; }
    
    local profile_name=$(basename "$profile")
    mkdir -p "${dest}"
    
    echo "Copying Firefox profile: ${profile_name}"
    rsync -av "$profile/" "${dest}/${profile_name}/"
    
    echo "Profile copied. Update profiles.ini to use it."
}

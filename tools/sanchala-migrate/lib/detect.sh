#!/bin/bash
# detect.sh - OS and browser detection for sanchala-migrate
# Part of SANCHALA OS

# Detect Windows version
detect_windows_version() {
    local source="$1"
    local reg_file="${source}/Windows/System32/config/SOFTWARE"
    
    if [[ -f "$reg_file" ]]; then
        # Try to determine version from registry hive
        if grep -q "Windows 11" "$reg_file" 2>/dev/null; then
            echo "Windows 11"
        elif grep -q "Windows 10" "$reg_file" 2>/dev/null; then
            echo "Windows 10"
        else
            echo "Windows (unknown version)"
        fi
    else
        echo "Windows"
    fi
}

# Detect macOS version
detect_macos_version() {
    local source="$1"
    local plist="${source}/System/Library/CoreServices/SystemVersion.plist"
    
    if [[ -f "$plist" ]]; then
        local version=$(grep -A1 "ProductVersion" "$plist" 2>/dev/null | grep string | sed 's/.*<string>\(.*\)<\/string>.*/\1/')
        echo "macOS ${version:-unknown}"
    else
        echo "macOS"
    fi
}

# Find all user profiles on Windows
find_windows_users() {
    local source="$1"
    local users_dir="${source}/Users"
    
    [[ ! -d "$users_dir" ]] && return 1
    
    for user_dir in "${users_dir}"/*; do
        [[ ! -d "$user_dir" ]] && continue
        local name=$(basename "$user_dir")
        # Skip system accounts
        [[ "$name" == "Public" || "$name" == "Default"* || "$name" == "All Users" ]] && continue
        echo "$name"
    done
}

# Find all user profiles on macOS
find_macos_users() {
    local source="$1"
    local users_dir="${source}/Users"
    
    [[ ! -d "$users_dir" ]] && return 1
    
    for user_dir in "${users_dir}"/*; do
        [[ ! -d "$user_dir" ]] && continue
        local name=$(basename "$user_dir")
        [[ "$name" == "Shared" || "$name" == ".localized" ]] && continue
        echo "$name"
    done
}

# Detect installed browsers on Windows
detect_windows_browsers() {
    local source="$1" user="$2"
    local user_dir="${source}/Users/${user}"
    local browsers=()
    
    [[ -d "${user_dir}/AppData/Local/Google/Chrome/User Data" ]] && browsers+=("chrome")
    [[ -d "${user_dir}/AppData/Local/Microsoft/Edge/User Data" ]] && browsers+=("edge")
    [[ -d "${user_dir}/AppData/Local/BraveSoftware/Brave-Browser/User Data" ]] && browsers+=("brave")
    [[ -d "${user_dir}/AppData/Roaming/Mozilla/Firefox/Profiles" ]] && browsers+=("firefox")
    [[ -d "${user_dir}/AppData/Roaming/Opera Software/Opera Stable" ]] && browsers+=("opera")
    
    echo "${browsers[*]}"
}

# Detect installed browsers on macOS
detect_macos_browsers() {
    local source="$1" user="$2"
    local user_dir="${source}/Users/${user}"
    local browsers=()
    
    [[ -d "${user_dir}/Library/Safari" ]] && browsers+=("safari")
    [[ -d "${user_dir}/Library/Application Support/Google/Chrome" ]] && browsers+=("chrome")
    [[ -d "${user_dir}/Library/Application Support/Firefox/Profiles" ]] && browsers+=("firefox")
    [[ -d "${user_dir}/Library/Application Support/BraveSoftware/Brave-Browser" ]] && browsers+=("brave")
    
    echo "${browsers[*]}"
}

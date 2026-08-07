#!/bin/bash
# settings.sh - Settings migration functions for sanchala-migrate
# Part of SANCHALA OS

# Migrate WiFi profiles from Windows
migrate_windows_wifi() {
    local source="$1"
    local profiles_dir="${source}/ProgramData/Microsoft/Wlansvc/Profiles/Interfaces"
    
    [[ ! -d "$profiles_dir" ]] && { echo "No WiFi profiles found"; return 0; }
    
    echo "Found Windows WiFi profiles"
    echo "Note: NetworkManager uses different format"
    echo
    
    # List available profiles
    local count=0
    for interface in "${profiles_dir}"/*; do
        [[ ! -d "$interface" ]] && continue
        for profile in "${interface}"/*.xml; do
            [[ ! -f "$profile" ]] && continue
            local ssid=$(grep -oP '(?<=<name>)[^<]+' "$profile" 2>/dev/null | head -1)
            [[ -n "$ssid" ]] && { echo "  • $ssid"; count=$((count + 1)); }
        done
    done
    
    echo
    echo "Found ${count} WiFi network(s)"
    echo "Manual reconnection required on Sanchala OS"
}

# Migrate macOS WiFi (requires Keychain export)
migrate_macos_wifi() {
    local source="$1"
    echo "macOS WiFi passwords are stored in Keychain"
    echo "Export them on macOS using Keychain Access before migration"
    echo
    echo "Steps:"
    echo "  1. On macOS: Keychain Access → System → WiFi passwords"
    echo "  2. Export to file"
    echo "  3. Import to Sanchala OS using: nmcli connection import"
}

# Migrate keyboard shortcuts from Windows
migrate_windows_shortcuts() {
    echo "Windows keyboard shortcuts migration:"
    echo
    echo "Common equivalents in Sanchala OS (KDE Plasma):"
    echo "  Win key        → Meta key (opens app launcher)"
    echo "  Win+E          → Dolphin (Meta+E in KDE)"
    echo "  Win+D          → Show Desktop (Meta+D)"
    echo "  Alt+Tab        → Same (window switcher)"
    echo "  Ctrl+C/V/X     → Same (copy/paste/cut)"
    echo "  Print Screen   → Spectacle (screenshot)"
    echo
    echo "Customize in: System Settings → Shortcuts"
}

# Migrate macOS keyboard shortcuts
migrate_macos_shortcuts() {
    echo "macOS keyboard shortcuts migration:"
    echo
    echo "Key mapping changes:"
    echo "  Cmd (⌘)        → Ctrl (for most shortcuts)"
    echo "  Cmd+Space      → Meta (app launcher)"
    echo "  Cmd+Tab        → Alt+Tab (window switcher)"
    echo "  Cmd+C/V/X      → Ctrl+C/V/X"
    echo "  Cmd+Q          → Alt+F4 or Ctrl+Q"
    echo
    echo "Tip: Swap Ctrl/Alt in System Settings → Input Devices → Keyboard"
}

# Migrate display settings
migrate_display_settings() {
    local source="$1" os_type="$2"
    
    echo "Display settings migration:"
    echo
    
    case "$os_type" in
        windows*)
            echo "Windows display settings detected"
            echo "Configure in: System Settings → Display and Monitor"
            ;;
        macos*)
            echo "macOS display settings detected"
            echo "Configure in: System Settings → Display and Monitor"
            echo
            echo "Note: HiDPI scaling is automatic on Sanchala OS"
            ;;
    esac
}

# Generate settings migration report
generate_settings_report() {
    local source="$1" os_type="$2" output="$3"
    
    cat > "$output" << EOF
# Sanchala OS Settings Migration Report
Generated: $(date)
Source: ${source}
Source OS: ${os_type}

## Keyboard Shortcuts
See System Settings → Shortcuts

## Display Settings  
See System Settings → Display and Monitor

## WiFi Networks
Reconnect manually via network indicator

## Printers
Add via System Settings → Printers

## Default Applications
Configure in System Settings → Default Applications
EOF
    
    echo "Settings report saved to: ${output}"
}

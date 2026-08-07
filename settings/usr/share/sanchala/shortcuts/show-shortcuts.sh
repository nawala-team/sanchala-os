#!/bin/bash
# ============================================
# SANCHALA OS - Shortcut Cheat Sheet Overlay
# ============================================
# Shows a visual overlay of keyboard shortcuts
# ============================================

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"

# Check if kdialog is available, fallback to zenity
show_with_kdialog() {
    kdialog --title "Sanchala OS Keyboard Shortcuts" \
            --textbox "$SCRIPT_DIR/shortcuts-cheatsheet.txt" 800 600
}

show_with_zenity() {
    zenity --text-info \
           --title="Sanchala OS Keyboard Shortcuts" \
           --filename="$SCRIPT_DIR/shortcuts-cheatsheet.txt" \
           --width=800 --height=600
}

show_with_qml() {
    if command -v qmlscene &> /dev/null; then
        qmlscene "$SCRIPT_DIR/ShortcutOverlay.qml" &
        sleep 5
        pkill -f "ShortcutOverlay.qml" 2>/dev/null
    else
        show_with_kdialog || show_with_zenity
    fi
}

# Try QML overlay first, then fallback
if [ -f "$SCRIPT_DIR/ShortcutOverlay.qml" ]; then
    show_with_qml
elif command -v kdialog &> /dev/null; then
    show_with_kdialog
elif command -v zenity &> /dev/null; then
    show_with_zenity
else
    notify-send "Shortcut Help" "Press Super+F1 for shortcuts. Install kdialog for overlay."
fi

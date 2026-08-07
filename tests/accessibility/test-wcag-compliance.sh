#!/usr/bin/env bash
# ══════════════════════════════════════════════════════════════════════════════
# Accessibility Tests: WCAG Compliance
# ══════════════════════════════════════════════════════════════════════════════

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../framework/core.sh"
source "$SCRIPT_DIR/../../framework/accessibility.sh"

TOOLS_DIR="$SANCHALA_ROOT/tools"

# Test for accessible Python GUIs
test_qt_accessibility() {
    local tools_with_a11y=0
    local total_qt_tools=0
    
    while IFS= read -r -d '' file; do
        if grep -qE 'PyQt|PySide|QApplication|QWidget' "$file" 2>/dev/null; then
            ((total_qt_tools++))
            if grep -qE 'setAccessible|accessibleName|accessibleDescription|QAccessible' "$file" 2>/dev/null; then
                ((tools_with_a11y++))
            fi
        fi
    done < <(find "$TOOLS_DIR" -name "*.py" -type f -print0 2>/dev/null)
    
    log_info "Qt tools with accessibility: $tools_with_a11y/$total_qt_tools"
    return 0  # Informational
}

# Test for GTK accessibility
test_gtk_accessibility() {
    local tools_with_a11y=0
    local total_gtk_tools=0
    
    while IFS= read -r -d '' file; do
        if grep -qE 'Gtk|gi\.repository' "$file" 2>/dev/null; then
            ((total_gtk_tools++))
            if grep -qE 'set_accessible|atk|Atk|accessible' "$file" 2>/dev/null; then
                ((tools_with_a11y++))
            fi
        fi
    done < <(find "$TOOLS_DIR" -name "*.py" -type f -print0 2>/dev/null)
    
    log_info "GTK tools with accessibility: $tools_with_a11y/$total_gtk_tools"
    return 0
}

# Test for keyboard shortcuts documentation
test_keyboard_shortcuts() {
    local tools_with_shortcuts=0
    
    while IFS= read -r -d '' file; do
        if grep -qiE 'shortcut|hotkey|keybind|Ctrl\+|Alt\+|QShortcut' "$file" 2>/dev/null; then
            ((tools_with_shortcuts++))
        fi
    done < <(find "$TOOLS_DIR" -type f \( -name "*.py" -o -name "*.sh" \) -print0 2>/dev/null)
    
    log_info "Tools with keyboard shortcuts: $tools_with_shortcuts"
    (( tools_with_shortcuts > 0 ))
}

# Test for high contrast support
test_high_contrast_support() {
    local tools_with_theme=0
    
    while IFS= read -r -d '' file; do
        if grep -qiE 'high.?contrast|theme|dark.?mode|color.?scheme' "$file" 2>/dev/null; then
            ((tools_with_theme++))
        fi
    done < <(find "$TOOLS_DIR" -type f \( -name "*.py" -o -name "*.css" -o -name "*.qss" \) -print0 2>/dev/null)
    
    log_info "Tools with theme support: $tools_with_theme"
    return 0
}

# Test for screen reader hints
test_screen_reader_hints() {
    local hints_found=0
    
    while IFS= read -r -d '' file; do
        if grep -qiE 'tooltip|whatsThis|statusTip|aria-|role=' "$file" 2>/dev/null; then
            ((hints_found++))
        fi
    done < <(find "$TOOLS_DIR" -type f \( -name "*.py" -o -name "*.html" -o -name "*.ui" \) -print0 2>/dev/null)
    
    log_info "Files with screen reader hints: $hints_found"
    return 0
}

# Test for font size scalability
test_font_scalability() {
    local scalable_found=0
    
    while IFS= read -r -d '' file; do
        if grep -qiE 'font.?size|scalable|em\b|rem\b|pt\b' "$file" 2>/dev/null; then
            ((scalable_found++))
        fi
    done < <(find "$TOOLS_DIR" -type f \( -name "*.css" -o -name "*.qss" -o -name "*.py" \) -print0 2>/dev/null)
    
    log_info "Files with scalable fonts: $scalable_found"
    return 0
}

# Test for focus indicators
test_focus_indicators() {
    local focus_found=0
    
    while IFS= read -r -d '' file; do
        if grep -qiE ':focus|focus.?style|setFocus|focusPolicy' "$file" 2>/dev/null; then
            ((focus_found++))
        fi
    done < <(find "$TOOLS_DIR" -type f \( -name "*.css" -o -name "*.qss" -o -name "*.py" \) -print0 2>/dev/null)
    
    log_info "Files with focus indicators: $focus_found"
    return 0
}

# Test desktop entry accessibility
test_desktop_entry_accessibility() {
    local entries_ok=0
    local total_entries=0
    
    while IFS= read -r -d '' file; do
        ((total_entries++))
        # Check for GenericName (helps screen readers)
        if grep -q "^GenericName=" "$file" 2>/dev/null && \
           grep -q "^Comment=" "$file" 2>/dev/null; then
            ((entries_ok++))
        fi
    done < <(find "$TOOLS_DIR" -name "*.desktop" -type f -print0 2>/dev/null)
    
    log_info "Accessible desktop entries: $entries_ok/$total_entries"
    (( total_entries == 0 || entries_ok * 2 >= total_entries ))
}

# Run tests
run_test "Qt accessibility support" test_qt_accessibility
run_test "GTK accessibility support" test_gtk_accessibility
run_test "Keyboard shortcuts defined" test_keyboard_shortcuts
run_test "High contrast support" test_high_contrast_support
run_test "Screen reader hints" test_screen_reader_hints
run_test "Font scalability" test_font_scalability
run_test "Focus indicators" test_focus_indicators
run_test "Desktop entry accessibility" test_desktop_entry_accessibility

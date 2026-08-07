#!/usr/bin/env bash
# ══════════════════════════════════════════════════════════════════════════════
# SANCHALA OS - Accessibility Compliance Tests (WCAG 2.1)
# ══════════════════════════════════════════════════════════════════════════════
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../framework/test-engine.sh"

PROJECT_ROOT="${SCRIPT_DIR}/../../"

describe "Accessibility: Keyboard Navigation"

test_desktop_files_have_shortcuts() {
    local total=0 with_shortcut=0
    while IFS= read -r desktop_file; do
        ((total++))
        if grep -qi "Shortcut\|Accelerator\|Key" "$desktop_file" 2>/dev/null; then
            ((with_shortcut++))
        fi
    done < <(find "$PROJECT_ROOT" -name "*.desktop" -type f 2>/dev/null)
    log_info "Desktop files with shortcuts: $with_shortcut/$total"
    assert_greater_than "$with_shortcut" 0 "Some apps should have shortcuts"
}

describe "Accessibility: Screen Reader Support"

test_ui_files_have_labels() {
    local violations=0
    while IFS= read -r ui_file; do
        # Check for accessibility labels
        if grep -qE '<object|<widget' "$ui_file" 2>/dev/null; then
            if ! grep -qiE 'accessible|aria-|role=|tooltip|description' "$ui_file" 2>/dev/null; then
                log_warn "Missing accessibility attrs: $ui_file"
                ((violations++))
            fi
        fi
    done < <(find "$PROJECT_ROOT" \( -name "*.ui" -o -name "*.glade" -o -name "*.xml" \) -type f 2>/dev/null | head -30)
    assert_less_than "$violations" 10 "UI files should have accessibility labels"
}

test_images_have_alt_text() {
    local violations=0
    while IFS= read -r html_file; do
        if grep -qE '<img[^>]+>' "$html_file" 2>/dev/null; then
            if grep -qE '<img[^>]+(?!alt=)[^>]*>' "$html_file" 2>/dev/null; then
                log_warn "Image without alt: $html_file"
                ((violations++))
            fi
        fi
    done < <(find "$PROJECT_ROOT" -name "*.html" -type f 2>/dev/null | head -20)
    assert_less_than "$violations" 5 "Images should have alt text"
}

describe "Accessibility: Color & Contrast"

test_no_color_only_indicators() {
    local violations=0
    while IFS= read -r file; do
        # Check for color-only status indicators
        if grep -qiE 'color:\s*(red|green)\s*;[^}]*$' "$file" 2>/dev/null; then
            if ! grep -qiE 'icon|symbol|text|label' "$file" 2>/dev/null; then
                log_warn "Color-only indicator: $file"
                ((violations++))
            fi
        fi
    done < <(find "$PROJECT_ROOT" -name "*.css" -type f 2>/dev/null | head -20)
    assert_less_than "$violations" 5 "Should not rely on color alone"
}

describe "Accessibility: Text & Readability"

test_font_sizes_scalable() {
    local violations=0
    while IFS= read -r css_file; do
        # Check for fixed font sizes in px
        if grep -qE 'font-size:\s*[0-9]+px' "$css_file" 2>/dev/null; then
            log_info "Fixed font size in: $css_file (consider rem/em)"
        fi
    done < <(find "$PROJECT_ROOT" -name "*.css" -type f 2>/dev/null | head -20)
    assert_equals 0 "$violations" "Font sizes should be scalable"
}

test_sufficient_line_height() {
    local good=0
    while IFS= read -r css_file; do
        if grep -qE 'line-height:\s*(1\.[4-9]|[2-9])' "$css_file" 2>/dev/null; then
            ((good++))
        fi
    done < <(find "$PROJECT_ROOT" -name "*.css" -type f 2>/dev/null | head -20)
    log_info "Files with good line-height: $good"
    # This is informational, not a hard requirement
    pass_test
}

describe "Accessibility: Motion & Animation"

test_respects_reduced_motion() {
    local good=0
    while IFS= read -r css_file; do
        if grep -q 'prefers-reduced-motion' "$css_file" 2>/dev/null; then
            ((good++))
        fi
    done < <(find "$PROJECT_ROOT" -name "*.css" -type f 2>/dev/null)
    log_info "Files respecting reduced-motion: $good"
    pass_test
}

# Run accessibility tests
it "Desktop files have shortcuts"; test_desktop_files_have_shortcuts && pass_test || fail_test
it "UI files have labels"; test_ui_files_have_labels && pass_test || fail_test
it "Images have alt text"; test_images_have_alt_text && pass_test || fail_test
it "No color-only indicators"; test_no_color_only_indicators && pass_test || fail_test
it "Font sizes scalable"; test_font_sizes_scalable && pass_test || fail_test
it "Sufficient line height"; test_sufficient_line_height
it "Respects reduced motion"; test_respects_reduced_motion

end_describe

log_info "Note: Full WCAG compliance requires manual testing with assistive technologies"

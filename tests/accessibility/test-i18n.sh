#!/usr/bin/env bash
# ══════════════════════════════════════════════════════════════════════════════
# SANCHALA OS - Accessibility Tests: Internationalization
# ══════════════════════════════════════════════════════════════════════════════
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../framework/test-engine.sh"

PROJECT_ROOT="${SCRIPT_DIR}/../../"

describe "Internationalization (i18n) Tests"

test_translation_files_exist() {
    local count=0
    for pattern in "*.po" "*.pot" "*.mo" "translations" "locales" "i18n" "l10n"; do
        count=$((count + $(find "$PROJECT_ROOT" \( -name "$pattern" -o -type d -name "$pattern" \) 2>/dev/null | wc -l)))
    done
    assert_greater_than "$count" 0 "Translation files should exist"
}

test_no_hardcoded_strings_in_ui() {
    local violations=0
    while IFS= read -r py_file; do
        # Check for untranslated strings in UI code
        if grep -qE "setText\(['\"][A-Z]" "$py_file" 2>/dev/null; then
            if ! grep -qE "_([\'\"]|tr\()" "$py_file" 2>/dev/null; then
                log_warn "Possible untranslated string: $py_file"
                ((violations++))
            fi
        fi
    done < <(find "$PROJECT_ROOT" -name "*.py" -type f 2>/dev/null | head -50)
    assert_less_than "$violations" 10 "UI strings should be translatable"
}

test_rtl_support() {
    local rtl_ready=0
    while IFS= read -r css_file; do
        if grep -qE 'direction:\s*rtl|dir=.rtl|\[dir=.rtl\]' "$css_file" 2>/dev/null; then
            ((rtl_ready++))
        fi
    done < <(find "$PROJECT_ROOT" -name "*.css" -type f 2>/dev/null)
    log_info "CSS files with RTL support: $rtl_ready"
    pass_test
}

it "Translation files exist"; test_translation_files_exist && pass_test || fail_test
it "No hardcoded UI strings"; test_no_hardcoded_strings_in_ui && pass_test || fail_test
it "RTL support"; test_rtl_support

end_describe

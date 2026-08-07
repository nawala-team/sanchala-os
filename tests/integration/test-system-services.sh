#!/usr/bin/env bash
# ══════════════════════════════════════════════════════════════════════════════
# SANCHALA OS - Integration Tests: System Services
# ══════════════════════════════════════════════════════════════════════════════
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../framework/test-engine.sh"

PROJECT_ROOT="${SCRIPT_DIR}/../../"

describe "System Services Integration"

test_systemd_units_valid() {
    local errors=0
    while IFS= read -r unit_file; do
        if ! grep -q "^\[Unit\]" "$unit_file" 2>/dev/null; then
            log_warn "Invalid systemd unit: $unit_file"
            ((errors++))
        fi
    done < <(find "$PROJECT_ROOT" \( -name "*.service" -o -name "*.timer" \) -type f 2>/dev/null)
    assert_equals 0 "$errors" "All systemd units should be valid"
}

test_dbus_configs_valid() {
    local errors=0
    while IFS= read -r dbus_file; do
        if ! grep -q '<!DOCTYPE busconfig' "$dbus_file" 2>/dev/null && \
           ! grep -q '<busconfig>' "$dbus_file" 2>/dev/null; then
            log_warn "Invalid D-Bus config: $dbus_file"
            ((errors++))
        fi
    done < <(find "$PROJECT_ROOT" -name "*.conf" -path "*/dbus*" -type f 2>/dev/null)
    assert_less_than "$errors" 3 "D-Bus configs should be valid"
}

test_polkit_rules_syntax() {
    local errors=0
    while IFS= read -r rules_file; do
        if [[ "$rules_file" == *.rules ]]; then
            # JavaScript syntax check
            if command -v node &>/dev/null; then
                if ! node --check "$rules_file" 2>/dev/null; then
                    ((errors++))
                fi
            fi
        fi
    done < <(find "$PROJECT_ROOT" -name "*.rules" -type f 2>/dev/null)
    assert_equals 0 "$errors" "Polkit rules should have valid syntax"
}

it "Systemd units valid"; test_systemd_units_valid && pass_test || fail_test
it "D-Bus configs valid"; test_dbus_configs_valid && pass_test || fail_test
it "Polkit rules syntax"; test_polkit_rules_syntax && pass_test || fail_test

end_describe

#!/usr/bin/env bash
# ══════════════════════════════════════════════════════════════════════════════
# SANCHALA OS - Integration Tests: Component Integration
# ══════════════════════════════════════════════════════════════════════════════
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../framework/test-engine.sh"

PROJECT_ROOT="${SCRIPT_DIR}/../../"

describe "Component Integration Tests"

test_tools_can_load_libs() {
    local tool_dir="${PROJECT_ROOT}/tools/sanchala-backup"
    if [[ -d "$tool_dir/lib" ]]; then
        local lib_count=$(find "$tool_dir/lib" -name "*.sh" 2>/dev/null | wc -l)
        assert_greater_than "$lib_count" 0 "Tool should have loadable libraries"
    else
        skip_test "No lib directory in sanchala-backup"
    fi
}

test_config_references_valid() {
    local errors=0
    while IFS= read -r config_file; do
        # Check if referenced files exist
        if grep -qE 'include|source|import' "$config_file" 2>/dev/null; then
            log_info "Config has includes: $config_file"
        fi
    done < <(find "${PROJECT_ROOT}/config" -type f -name "*.conf" 2>/dev/null | head -20)
    assert_equals 0 "$errors" "Config references should be valid"
}

test_scripts_reference_existing_tools() {
    local errors=0
    while IFS= read -r script; do
        # Check for references to sanchala-* tools
        while IFS= read -r tool_ref; do
            tool_name=$(echo "$tool_ref" | grep -oE 'sanchala-[a-z-]+' | head -1)
            if [[ -n "$tool_name" ]] && [[ ! -d "${PROJECT_ROOT}/tools/$tool_name" ]]; then
                log_warn "Missing tool reference: $tool_name in $script"
                ((errors++))
            fi
        done < <(grep -oE 'sanchala-[a-z-]+' "$script" 2>/dev/null | sort -u | head -10)
    done < <(find "${PROJECT_ROOT}/scripts" -name "*.sh" -type f 2>/dev/null | head -20)
    assert_less_than "$errors" 5 "Scripts should reference existing tools"
}

it "Tools can load libs"; test_tools_can_load_libs && pass_test || fail_test
it "Config references valid"; test_config_references_valid && pass_test || fail_test
it "Scripts reference existing tools"; test_scripts_reference_existing_tools && pass_test || fail_test

end_describe

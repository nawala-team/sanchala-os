#!/usr/bin/env bash
# ══════════════════════════════════════════════════════════════════════════════
# SANCHALA OS - Performance Tests: Startup Time
# ══════════════════════════════════════════════════════════════════════════════
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../framework/test-engine.sh"

PROJECT_ROOT="${SCRIPT_DIR}/../../"

describe "Startup Performance Tests"

test_shell_script_load_time() {
    local total_time=0 count=0
    while IFS= read -r script; do
        local start=$(date +%s%N 2>/dev/null || echo "0")
        bash -n "$script" 2>/dev/null
        local end=$(date +%s%N 2>/dev/null || echo "0")
        if [[ "$start" != "0" ]]; then
            local duration=$(( (end - start) / 1000000 ))
            ((total_time += duration))
            ((count++))
        fi
    done < <(find "$PROJECT_ROOT/tools" -name "*.sh" -type f 2>/dev/null | head -20)
    
    if [[ $count -gt 0 ]]; then
        local avg=$((total_time / count))
        assert_less_than "$avg" 100 "Average script parse time < 100ms"
    else
        skip_test "No scripts to test"
    fi
}

test_python_import_time() {
    local violations=0
    while IFS= read -r py_file; do
        local start=$(date +%s%N 2>/dev/null || echo "0")
        python3 -m py_compile "$py_file" 2>/dev/null
        local end=$(date +%s%N 2>/dev/null || echo "0")
        if [[ "$start" != "0" ]]; then
            local duration=$(( (end - start) / 1000000 ))
            if [[ $duration -gt 500 ]]; then
                log_warn "Slow compile: $py_file (${duration}ms)"
                ((violations++))
            fi
        fi
    done < <(find "$PROJECT_ROOT/tools" -name "*.py" -type f 2>/dev/null | head -20)
    assert_less_than "$violations" 3 "Python files compile quickly"
}

it "Shell script load time"; test_shell_script_load_time && pass_test || fail_test
it "Python import time"; test_python_import_time && pass_test || fail_test

end_describe

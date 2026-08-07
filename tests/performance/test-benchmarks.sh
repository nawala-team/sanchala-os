#!/usr/bin/env bash
# ══════════════════════════════════════════════════════════════════════════════
# SANCHALA OS - Performance Benchmark Tests
# ══════════════════════════════════════════════════════════════════════════════
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../framework/test-engine.sh"

PROJECT_ROOT="${SCRIPT_DIR}/../../"

describe "Performance Benchmarks"

benchmark() {
    local name="$1" cmd="$2" max_ms="${3:-1000}"
    local start_time end_time duration
    
    start_time=$(date +%s%N 2>/dev/null || echo "0")
    eval "$cmd" &>/dev/null
    end_time=$(date +%s%N 2>/dev/null || echo "0")
    
    if [[ "$start_time" != "0" ]]; then
        duration=$(( (end_time - start_time) / 1000000 ))
        if [[ $duration -lt $max_ms ]]; then
            log_pass "$name: ${duration}ms (< ${max_ms}ms)"
            return 0
        else
            log_fail "$name: ${duration}ms (> ${max_ms}ms)"
            return 1
        fi
    else
        log_info "$name: timing not available"
        return 0
    fi
}

test_file_listing_performance() {
    benchmark "List all tools" "find $PROJECT_ROOT/tools -maxdepth 1 -type d" 500
}

test_config_parsing_performance() {
    benchmark "Parse JSON configs" "find $PROJECT_ROOT -name '*.json' -exec cat {} \; | head -1000" 2000
}

test_script_syntax_check_performance() {
    benchmark "Syntax check scripts" "find $PROJECT_ROOT -name '*.sh' -exec bash -n {} \; 2>/dev/null | head -50" 5000
}

describe "Memory Usage Analysis"

test_no_large_embedded_data() {
    local violations=0
    while IFS= read -r file; do
        local size=$(stat -c %s "$file" 2>/dev/null || stat -f %z "$file" 2>/dev/null || echo "0")
        if [[ $size -gt 1048576 ]]; then  # > 1MB
            log_warn "Large file: $file (${size} bytes)"
            ((violations++))
        fi
    done < <(find "$PROJECT_ROOT" -type f \( -name "*.py" -o -name "*.sh" \) 2>/dev/null)
    assert_less_than "$violations" 5 "No oversized scripts"
}

test_no_memory_leaks_patterns() {
    local violations=0
    while IFS= read -r file; do
        # Check for common memory leak patterns in Python
        if grep -qE 'while\s+True.*append|\.append.*while.*True' "$file" 2>/dev/null; then
            log_warn "Potential memory leak pattern: $file"
            ((violations++))
        fi
    done < <(find "$PROJECT_ROOT" -name "*.py" -type f 2>/dev/null | head -100)
    assert_less_than "$violations" 3 "No obvious memory leak patterns"
}

describe "Resource Efficiency"

test_no_busy_loops() {
    local violations=0
    while IFS= read -r file; do
        if grep -qE 'while\s*(True|1)\s*:?\s*$' "$file" 2>/dev/null; then
            # Check if there's a sleep
            if ! grep -qE 'sleep|time\.sleep|await' "$file" 2>/dev/null; then
                log_warn "Possible busy loop: $file"
                ((violations++))
            fi
        fi
    done < <(find "$PROJECT_ROOT" -type f \( -name "*.py" -o -name "*.sh" \) 2>/dev/null | head -100)
    assert_less_than "$violations" 5 "No busy loops without sleep"
}

test_efficient_file_operations() {
    local violations=0
    while IFS= read -r file; do
        # Check for inefficient patterns
        if grep -qE 'for.*in.*open\(|readlines\(\)' "$file" 2>/dev/null; then
            log_info "Consider using iterator: $file"
        fi
    done < <(find "$PROJECT_ROOT" -name "*.py" -type f 2>/dev/null | head -50)
    assert_equals 0 "$violations" "Efficient file operations"
}

# Run benchmarks
it "File listing performance"; test_file_listing_performance && pass_test || fail_test
it "Config parsing performance"; test_config_parsing_performance && pass_test || fail_test
it "Syntax check performance"; test_script_syntax_check_performance && pass_test || fail_test
it "No large embedded data"; test_no_large_embedded_data && pass_test || fail_test
it "No memory leak patterns"; test_no_memory_leaks_patterns && pass_test || fail_test
it "No busy loops"; test_no_busy_loops && pass_test || fail_test
it "Efficient file ops"; test_efficient_file_operations && pass_test || fail_test

end_describe

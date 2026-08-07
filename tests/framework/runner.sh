#!/usr/bin/env bash
# SANCHALA OS - Zero Bug Framework - Test Runner
set -euo pipefail

declare -g TEST_TIMEOUT=30
declare -ga BEFORE_EACH_HOOKS=()
declare -ga AFTER_EACH_HOOKS=()
declare -ga BEFORE_ALL_HOOKS=()
declare -ga AFTER_ALL_HOOKS=()

before_all() { BEFORE_ALL_HOOKS+=("$1"); }
after_all() { AFTER_ALL_HOOKS+=("$1"); }
before_each() { BEFORE_EACH_HOOKS+=("$1"); }
after_each() { AFTER_EACH_HOOKS+=("$1"); }

_run_hooks() {
    local -n hooks=$1
    for hook in "${hooks[@]}"; do
        eval "$hook" || log_error "Hook failed: $hook"
    done
}

run_test() {
    local name="$1" func="$2" timeout="${3:-$TEST_TIMEOUT}"
    CURRENT_TEST_NAME="$name"
    ((TOTAL_TESTS++))
    TEST_START_TIME=$(date +%s%N 2>/dev/null || echo "$(date +%s)000000000")
    
    _run_hooks BEFORE_EACH_HOOKS
    
    local result=0 output=""
    if command -v timeout &>/dev/null; then
        output=$(timeout "$timeout" bash -c "$func" 2>&1) || result=$?
    else
        output=$(bash -c "$func" 2>&1) || result=$?
    fi
    
    local end_time duration_ms
    end_time=$(date +%s%N 2>/dev/null || echo "$(date +%s)000000000")
    duration_ms=$(( (end_time - TEST_START_TIME) / 1000000 ))
    
    case $result in
        0) ((PASSED_TESTS++)); log_pass "$name (${duration_ms}ms)" ;;
        124) ((FAILED_TESTS++)); log_fail "$name - TIMEOUT"; FAILURE_LOG+=("$name: Timeout") ;;
        *) ((FAILED_TESTS++)); log_fail "$name"; [[ -n "$output" ]] && echo "    $output" | head -3; FAILURE_LOG+=("$name: $output") ;;
    esac
    
    _run_hooks AFTER_EACH_HOOKS
    CURRENT_TEST_NAME=""
    return $result
}

skip_test() {
    local name="$1" reason="${2:-Skipped}"
    ((TOTAL_TESTS++)); ((SKIPPED_TESTS++))
    log_skip "$name - $reason"
}

run_test_file() {
    local file="$1"
    [[ -f "$file" ]] || { log_error "Test file not found: $file"; return 1; }
    log_info "Running: $(basename "$file")"
    source "$file"
}

run_test_dir() {
    local dir="$1" pattern="${2:-test-*.sh}"
    [[ -d "$dir" ]] || { log_error "Test dir not found: $dir"; return 1; }
    _run_hooks BEFORE_ALL_HOOKS
    for file in "$dir"/$pattern; do
        [[ -f "$file" ]] && run_test_file "$file"
    done
    _run_hooks AFTER_ALL_HOOKS
}

export -f before_all after_all before_each after_each _run_hooks
export -f run_test skip_test run_test_file run_test_dir

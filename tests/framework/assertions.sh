#!/usr/bin/env bash
# SANCHALA OS - Zero Bug Framework - Assertions
set -euo pipefail

_assertion_result() {
    local status="$1" message="$2" details="${3:-}"
    ((TOTAL_ASSERTIONS++))
    if [[ "$status" == "pass" ]]; then
        ((PASSED_ASSERTIONS++))
        [[ "${VERBOSE:-0}" == "1" ]] && log_pass "$message"
        return 0
    else
        ((FAILED_ASSERTIONS++))
        log_fail "$message"
        [[ -n "$details" ]] && echo "    Details: $details" >&2
        FAILURE_LOG+=("[$CURRENT_SUITE] $CURRENT_TEST_NAME: $message")
        return 1
    fi
}

assert_equals() {
    local expected="$1" actual="$2" message="${3:-Values should be equal}"
    [[ "$expected" == "$actual" ]] && _assertion_result "pass" "$message" || \
        _assertion_result "fail" "$message" "Expected: '$expected', Got: '$actual'"
}

assert_not_equals() {
    local unexpected="$1" actual="$2" message="${3:-Values should differ}"
    [[ "$unexpected" != "$actual" ]] && _assertion_result "pass" "$message" || \
        _assertion_result "fail" "$message" "Got unexpected: '$actual'"
}

assert_true() {
    local condition="$1" message="${2:-Should be true}"
    eval "$condition" 2>/dev/null && _assertion_result "pass" "$message" || \
        _assertion_result "fail" "$message" "Condition false"
}

assert_false() {
    local condition="$1" message="${2:-Should be false}"
    ! eval "$condition" 2>/dev/null && _assertion_result "pass" "$message" || \
        _assertion_result "fail" "$message" "Condition true"
}

assert_empty() {
    local value="$1" message="${2:-Should be empty}"
    [[ -z "$value" ]] && _assertion_result "pass" "$message" || \
        _assertion_result "fail" "$message" "Got: '$value'"
}

assert_not_empty() {
    local value="$1" message="${2:-Should not be empty}"
    [[ -n "$value" ]] && _assertion_result "pass" "$message" || \
        _assertion_result "fail" "$message" "Value empty"
}

assert_greater_than() {
    local actual="$1" threshold="$2" message="${3:-Should be > $threshold}"
    (( actual > threshold )) && _assertion_result "pass" "$message" || \
        _assertion_result "fail" "$message" "Got: $actual"
}

assert_contains() {
    local haystack="$1" needle="$2" message="${3:-Should contain substring}"
    [[ "$haystack" == *"$needle"* ]] && _assertion_result "pass" "$message" || \
        _assertion_result "fail" "$message" "'$needle' not found"
}

assert_matches() {
    local string="$1" pattern="$2" message="${3:-Should match pattern}"
    [[ "$string" =~ $pattern ]] && _assertion_result "pass" "$message" || \
        _assertion_result "fail" "$message" "No match"
}

assert_file_exists() {
    local path="$1" message="${2:-File should exist}"
    [[ -f "$path" ]] && _assertion_result "pass" "$message" || \
        _assertion_result "fail" "$message" "Not found: $path"
}

assert_dir_exists() {
    local path="$1" message="${2:-Dir should exist}"
    [[ -d "$path" ]] && _assertion_result "pass" "$message" || \
        _assertion_result "fail" "$message" "Not found: $path"
}

assert_file_executable() {
    local path="$1" message="${2:-Should be executable}"
    [[ -x "$path" ]] && _assertion_result "pass" "$message" || \
        _assertion_result "fail" "$message" "Not executable: $path"
}

assert_file_contains() {
    local path="$1" pattern="$2" message="${3:-File should contain pattern}"
    [[ -f "$path" ]] && grep -qE "$pattern" "$path" 2>/dev/null && \
        _assertion_result "pass" "$message" || _assertion_result "fail" "$message" "Pattern not found"
}

assert_command_exists() {
    local cmd="$1" message="${2:-Command should exist}"
    command -v "$cmd" &>/dev/null && _assertion_result "pass" "$message" || \
        _assertion_result "fail" "$message" "Not found: $cmd"
}

assert_command_succeeds() {
    local cmd="$1" message="${2:-Command should succeed}"
    eval "$cmd" &>/dev/null && _assertion_result "pass" "$message" || \
        _assertion_result "fail" "$message" "Command failed"
}

assert_exit_code() {
    local expected="$1" cmd="$2" message="${3:-Exit code should be $expected}"
    set +e; eval "$cmd" &>/dev/null; local actual=$?; set -e
    (( actual == expected )) && _assertion_result "pass" "$message" || \
        _assertion_result "fail" "$message" "Got: $actual"
}

export -f _assertion_result assert_equals assert_not_equals assert_true assert_false
export -f assert_empty assert_not_empty assert_greater_than assert_contains assert_matches
export -f assert_file_exists assert_dir_exists assert_file_executable assert_file_contains
export -f assert_command_exists assert_command_succeeds assert_exit_code

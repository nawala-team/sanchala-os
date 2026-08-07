#!/usr/bin/env bash
# ══════════════════════════════════════════════════════════════════════════════
# SANCHALA OS - Test Assertion Functions
# ══════════════════════════════════════════════════════════════════════════════

assert_eq() {
    local actual="$1" expected="$2" description="${3:-Values should be equal}"
    if [[ "$actual" == "$expected" ]]; then pass "$description"; return 0
    else fail "$description" "Expected '$expected' but got '$actual'"; return 1; fi
}

assert_ne() {
    local actual="$1" unexpected="$2" description="${3:-Values should not be equal}"
    if [[ "$actual" != "$unexpected" ]]; then pass "$description"; return 0
    else fail "$description" "Got unexpected value '$unexpected'"; return 1; fi
}

assert_true() {
    local condition="$1" description="${2:-Condition should be true}"
    if eval "$condition"; then pass "$description"; return 0
    else fail "$description" "Condition evaluated to false"; return 1; fi
}

assert_false() {
    local condition="$1" description="${2:-Condition should be false}"
    if ! eval "$condition"; then pass "$description"; return 0
    else fail "$description" "Condition evaluated to true"; return 1; fi
}

assert_file_exists() {
    local path="$1" description="${2:-File should exist: $path}"
    if [[ -f "$path" ]]; then pass "$description"; return 0
    else fail "$description" "File not found: $path"; return 1; fi
}

assert_dir_exists() {
    local path="$1" description="${2:-Directory should exist: $path}"
    if [[ -d "$path" ]]; then pass "$description"; return 0
    else fail "$description" "Directory not found: $path"; return 1; fi
}

assert_file_not_empty() {
    local path="$1" description="${2:-File should not be empty: $path}"
    if [[ -s "$path" ]]; then pass "$description"; return 0
    else fail "$description" "File is empty or missing: $path"; return 1; fi
}

assert_file_contains() {
    local path="$1" pattern="$2" description="${3:-File should contain pattern}"
    if [[ ! -f "$path" ]]; then fail "$description" "File not found: $path"; return 1; fi
    if grep -qE "$pattern" "$path"; then pass "$description"; return 0
    else fail "$description" "Pattern '$pattern' not found in $path"; return 1; fi
}

assert_file_not_contains() {
    local path="$1" pattern="$2" description="${3:-File should not contain pattern}"
    if [[ ! -f "$path" ]]; then fail "$description" "File not found: $path"; return 1; fi
    if ! grep -qE "$pattern" "$path"; then pass "$description"; return 0
    else fail "$description" "Pattern '$pattern' found in $path"; return 1; fi
}

assert_command_exists() {
    local cmd="$1" description="${2:-Command should exist: $cmd}"
    if command -v "$cmd" &>/dev/null; then pass "$description"; return 0
    else fail "$description" "Command not found: $cmd"; return 1; fi
}

assert_command_succeeds() {
    local cmd="$1" description="${2:-Command should succeed}"
    if eval "$cmd" &>/dev/null; then pass "$description"; return 0
    else fail "$description" "Command failed: $cmd"; return 1; fi
}

assert_command_fails() {
    local cmd="$1" description="${2:-Command should fail}"
    if ! eval "$cmd" &>/dev/null; then pass "$description"; return 0
    else fail "$description" "Command succeeded (expected failure)"; return 1; fi
}

assert_exit_code() {
    local expected_code="$1" cmd="$2" description="${3:-Exit code should be $expected_code}"
    set +e; eval "$cmd" &>/dev/null; local actual_code=$?; set -e
    if [[ "$actual_code" -eq "$expected_code" ]]; then pass "$description"; return 0
    else fail "$description" "Expected exit code $expected_code but got $actual_code"; return 1; fi
}

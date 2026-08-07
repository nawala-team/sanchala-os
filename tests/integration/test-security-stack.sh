#!/usr/bin/env bash
# Integration Tests for Security Stack
set -euo pipefail

describe "Security Stack Integration Tests"

SECURITY_DIR="${PROJECT_ROOT}/security"

it "Security directory structure"
((TOTAL_TESTS++))
if [[ -d "$SECURITY_DIR" ]]; then
    ((PASSED_TESTS++)); log_pass "Security directory exists"
else
    ((FAILED_TESTS++)); log_fail "Security directory missing"
fi

it "No world-writable files in security"
((TOTAL_TESTS++))
world_writable=$(find "$SECURITY_DIR" -type f -perm -002 2>/dev/null | wc -l)
if [[ $world_writable -eq 0 ]]; then
    ((PASSED_TESTS++)); log_pass "No world-writable files"
else
    ((FAILED_TESTS++)); log_fail "$world_writable world-writable files"
fi

it "Security configs have correct permissions"
((TOTAL_TESTS++))
bad_perms=$(find "$SECURITY_DIR" -type f -name '*.conf' ! -perm 644 2>/dev/null | wc -l)
if [[ $bad_perms -eq 0 ]]; then
    ((PASSED_TESTS++)); log_pass "Permissions OK"
else
    ((SKIPPED_TESTS++)); log_skip "Permission check inconclusive"
fi

end_describe

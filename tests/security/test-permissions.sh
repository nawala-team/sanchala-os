#!/usr/bin/env bash
# File Permission Security Tests
set -euo pipefail

describe "Permission Security Tests"

it "No SUID binaries in tools"
((TOTAL_TESTS++))
suid=$(find "$PROJECT_ROOT/tools" -perm -4000 2>/dev/null | wc -l)
if [[ $suid -eq 0 ]]; then
    ((PASSED_TESTS++)); log_pass "No SUID binaries"
else
    ((FAILED_TESTS++)); log_fail "$suid SUID binaries found"
fi

it "No SGID binaries in tools"
((TOTAL_TESTS++))
sgid=$(find "$PROJECT_ROOT/tools" -perm -2000 2>/dev/null | wc -l)
if [[ $sgid -eq 0 ]]; then
    ((PASSED_TESTS++)); log_pass "No SGID binaries"
else
    ((FAILED_TESTS++)); log_fail "$sgid SGID binaries found"
fi

it "No world-writable executables"
((TOTAL_TESTS++))
ww=$(find "$PROJECT_ROOT/tools" -type f -perm -002 -executable 2>/dev/null | wc -l)
if [[ $ww -eq 0 ]]; then
    ((PASSED_TESTS++)); log_pass "No world-writable executables"
else
    ((FAILED_TESTS++)); log_fail "$ww world-writable executables"
fi

end_describe

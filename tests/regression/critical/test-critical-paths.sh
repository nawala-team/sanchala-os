#!/usr/bin/env bash
# Critical Path Regression Tests
set -euo pipefail

describe "Critical Path Tests"

it "Security module integrity"
((TOTAL_TESTS++))
if [[ -d "$PROJECT_ROOT/security" ]] && [[ $(ls "$PROJECT_ROOT/security" | wc -l) -gt 0 ]]; then
    ((PASSED_TESTS++)); log_pass "Security module intact"
else
    ((FAILED_TESTS++)); log_fail "Security module compromised"
fi

it "Config integrity"
((TOTAL_TESTS++))
if [[ -d "$PROJECT_ROOT/config" ]]; then
    ((PASSED_TESTS++)); log_pass "Config intact"
else
    ((FAILED_TESTS++)); log_fail "Config missing"
fi

it "Installer integrity"
((TOTAL_TESTS++))
if [[ -d "$PROJECT_ROOT/installer" ]]; then
    ((PASSED_TESTS++)); log_pass "Installer intact"
else
    ((SKIPPED_TESTS++)); log_skip "Installer not present"
fi

it "Core tools present"
((TOTAL_TESTS++))
core_tools=("sanchala-backup" "sanchala-firewall" "sanchala-cleaner")
missing=0
for tool in "${core_tools[@]}"; do
    [[ -e "$PROJECT_ROOT/tools/$tool" ]] || ((missing++))
done
if [[ $missing -eq 0 ]]; then
    ((PASSED_TESTS++)); log_pass "All core tools present"
else
    ((FAILED_TESTS++)); log_fail "$missing core tools missing"
fi

end_describe

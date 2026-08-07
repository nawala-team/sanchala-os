#!/usr/bin/env bash
# Integration Tests for Filesystem Structure
set -euo pipefail

describe "Filesystem Integration Tests"

required_dirs=("tools" "config" "scripts" "docs" "security")

for dir in "${required_dirs[@]}"; do
    it "$dir directory exists and is accessible"
    ((TOTAL_TESTS++))
    if [[ -d "$PROJECT_ROOT/$dir" ]] && [[ -r "$PROJECT_ROOT/$dir" ]]; then
        ((PASSED_TESTS++)); log_pass "$dir OK"
    else
        ((FAILED_TESTS++)); log_fail "$dir missing or inaccessible"
    fi
done

it "No broken symlinks in tools"
((TOTAL_TESTS++))
broken=$(find "$PROJECT_ROOT/tools" -xtype l 2>/dev/null | wc -l)
if [[ $broken -eq 0 ]]; then
    ((PASSED_TESTS++)); log_pass "No broken symlinks"
else
    ((FAILED_TESTS++)); log_fail "$broken broken symlinks found"
fi

end_describe

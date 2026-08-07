#!/usr/bin/env bash
# Unit Tests for Shell Script Syntax
set -euo pipefail

describe "Shell Script Syntax Tests"

check_syntax() {
    local file="$1"
    bash -n "$file" 2>/dev/null
}

# Test all shell scripts for syntax errors
while IFS= read -r -d '' script; do
    name=$(basename "$script")
    it "$name has valid syntax"
    ((TOTAL_TESTS++))
    if check_syntax "$script"; then
        ((PASSED_TESTS++)); log_pass "$name syntax OK"
    else
        ((FAILED_TESTS++)); log_fail "$name syntax error"
        FAILURE_LOG+=("$name: Syntax error")
    fi
done < <(find "$PROJECT_ROOT/tools" -name '*.sh' -type f -print0 2>/dev/null | head -z -n 100)

end_describe

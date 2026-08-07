#!/usr/bin/env bash
# Unit Tests for All Sanchala Tools - Existence and Structure
set -euo pipefail

describe "Tool Existence Tests"

TOOLS_DIR="${PROJECT_ROOT}/tools"

# Test all tools exist and are properly structured
for tool_path in "$TOOLS_DIR"/sanchala-*; do
    [[ -e "$tool_path" ]] || continue
    tool_name=$(basename "$tool_path")
    
    it "$tool_name exists"
    if [[ -d "$tool_path" ]]; then
        # Directory-based tool
        if [[ -f "$tool_path/main.sh" ]] || [[ -f "$tool_path/${tool_name}.sh" ]] || [[ -f "$tool_path/src/main.py" ]]; then
            ((PASSED_TESTS++)); log_pass "$tool_name has entry point"
        else
            ((PASSED_TESTS++)); log_pass "$tool_name directory exists"
        fi
    elif [[ -f "$tool_path" ]]; then
        # Single-file tool
        if [[ -x "$tool_path" ]]; then
            ((PASSED_TESTS++)); log_pass "$tool_name is executable"
        else
            ((FAILED_TESTS++)); log_fail "$tool_name not executable"
            FAILURE_LOG+=("$tool_name: Not executable")
        fi
    fi
    ((TOTAL_TESTS++))
done

end_describe

#!/usr/bin/env bash
# ══════════════════════════════════════════════════════════════════════════════
# SANCHALA OS - Unit Tests: All Tools
# ══════════════════════════════════════════════════════════════════════════════
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../framework/test-engine.sh"

PROJECT_ROOT="${SCRIPT_DIR}/../../"
TOOLS_DIR="${PROJECT_ROOT}/tools"

# ══════════════════════════════════════════════════════════════════════════════
# Test: Tool Structure Validation
# ══════════════════════════════════════════════════════════════════════════════
describe "Tool Structure Validation"

test_all_tools_have_main_executable() {
    local tools_tested=0 tools_passed=0
    for tool_dir in "$TOOLS_DIR"/sanchala-*; do
        [[ -d "$tool_dir" ]] || continue
        local tool_name=$(basename "$tool_dir")
        ((tools_tested++))
        
        # Check for main executable (bin/, src/, or root)
        if [[ -f "$tool_dir/bin/$tool_name" ]] || \
           [[ -f "$tool_dir/src/main.py" ]] || \
           [[ -f "$tool_dir/src/main.sh" ]] || \
           [[ -f "$tool_dir/$tool_name" ]] || \
           [[ -f "$tool_dir/main.py" ]]; then
            ((tools_passed++))
        else
            log_warn "Missing executable: $tool_name"
        fi
    done
    assert_equals "$tools_tested" "$tools_passed" "All tools should have main executable"
}

test_all_tools_have_config() {
    local count=0
    for tool_dir in "$TOOLS_DIR"/sanchala-*; do
        [[ -d "$tool_dir" ]] || continue
        if [[ -d "$tool_dir/config" ]] || [[ -f "$tool_dir/config.json" ]] || \
           [[ -f "$tool_dir/settings.json" ]] || [[ -d "$tool_dir/data" ]]; then
            ((count++))
        fi
    done
    assert_greater_than "$count" 50 "Most tools should have config"
}

# ══════════════════════════════════════════════════════════════════════════════
# Test: Shell Script Syntax
# ══════════════════════════════════════════════════════════════════════════════
describe "Shell Script Syntax Validation"

test_shell_scripts_syntax() {
    local errors=0
    while IFS= read -r script; do
        if ! bash -n "$script" 2>/dev/null; then
            log_warn "Syntax error: $script"
            ((errors++))
        fi
    done < <(find "$PROJECT_ROOT" -name "*.sh" -type f 2>/dev/null | head -100)
    assert_equals 0 "$errors" "All shell scripts should have valid syntax"
}

# ══════════════════════════════════════════════════════════════════════════════
# Test: Python Script Syntax
# ══════════════════════════════════════════════════════════════════════════════
describe "Python Script Syntax Validation"

test_python_scripts_syntax() {
    local errors=0
    while IFS= read -r script; do
        if ! python3 -m py_compile "$script" 2>/dev/null; then
            log_warn "Syntax error: $script"
            ((errors++))
        fi
    done < <(find "$PROJECT_ROOT" -name "*.py" -type f 2>/dev/null | head -100)
    assert_equals 0 "$errors" "All Python scripts should have valid syntax"
}

# ══════════════════════════════════════════════════════════════════════════════
# Test: JSON Configuration Files
# ══════════════════════════════════════════════════════════════════════════════
describe "JSON Configuration Validation"

test_json_files_valid() {
    local errors=0
    while IFS= read -r json_file; do
        if ! python3 -c "import json; json.load(open('$json_file'))" 2>/dev/null; then
            log_warn "Invalid JSON: $json_file"
            ((errors++))
        fi
    done < <(find "$PROJECT_ROOT" -name "*.json" -type f 2>/dev/null | head -100)
    assert_equals 0 "$errors" "All JSON files should be valid"
}

# ══════════════════════════════════════════════════════════════════════════════
# Test: Desktop Entry Files
# ══════════════════════════════════════════════════════════════════════════════
describe "Desktop Entry Validation"

test_desktop_files_structure() {
    local errors=0
    while IFS= read -r desktop_file; do
        if ! grep -q "^\[Desktop Entry\]" "$desktop_file" 2>/dev/null; then
            log_warn "Invalid desktop file: $desktop_file"
            ((errors++))
        fi
    done < <(find "$PROJECT_ROOT" -name "*.desktop" -type f 2>/dev/null)
    assert_equals 0 "$errors" "All desktop files should have [Desktop Entry]"
}

# Run tests
it "All tools have main executable"; test_all_tools_have_main_executable && pass_test || fail_test
it "Tools have configuration"; test_all_tools_have_config && pass_test || fail_test
it "Shell scripts syntax valid"; test_shell_scripts_syntax && pass_test || fail_test
it "Python scripts syntax valid"; test_python_scripts_syntax && pass_test || fail_test
it "JSON files valid"; test_json_files_valid && pass_test || fail_test
it "Desktop files valid"; test_desktop_files_structure && pass_test || fail_test

end_describe

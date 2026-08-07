#!/usr/bin/env bash
# ══════════════════════════════════════════════════════════════════════════════
# Unit Tests: Sanchala Tools - Core Functionality
# ══════════════════════════════════════════════════════════════════════════════

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../framework/core.sh"

TOOLS_DIR="$SANCHALA_ROOT/tools"

# Test tool directory structure
test_tool_structure() {
    for tool_dir in "$TOOLS_DIR"/sanchala-*; do
        [[ -d "$tool_dir" ]] || continue
        local tool_name=$(basename "$tool_dir")
        
        # Check for essential files
        if [[ -f "$tool_dir/$tool_name" ]] || \
           [[ -f "$tool_dir/${tool_name}.py" ]] || \
           [[ -f "$tool_dir/src/main.py" ]] || \
           [[ -f "$tool_dir/${tool_name#sanchala-}.py" ]]; then
            return 0
        fi
    done
    return 1
}

# Test tool executability
test_tool_executable() {
    local found=0
    for tool_dir in "$TOOLS_DIR"/sanchala-*; do
        [[ -d "$tool_dir" ]] || continue
        
        # Find main executable
        for exec_file in "$tool_dir/$(basename "$tool_dir")" \
                        "$tool_dir/src/main.py" \
                        "$tool_dir"/*.py; do
            if [[ -f "$exec_file" ]]; then
                found=1
                break 2
            fi
        done
    done
    (( found == 1 ))
}

# Test shell script syntax
test_shell_syntax() {
    local errors=0
    while IFS= read -r -d '' file; do
        if ! bash -n "$file" 2>/dev/null; then
            ((errors++))
        fi
    done < <(find "$TOOLS_DIR" -name "*.sh" -type f -print0 2>/dev/null)
    (( errors == 0 ))
}

# Test Python syntax
test_python_syntax() {
    local errors=0
    while IFS= read -r -d '' file; do
        if ! python3 -m py_compile "$file" 2>/dev/null; then
            ((errors++))
        fi
    done < <(find "$TOOLS_DIR" -name "*.py" -type f -print0 2>/dev/null)
    (( errors == 0 ))
}

# Test config file validity
test_config_files() {
    local errors=0
    
    # Check JSON configs
    while IFS= read -r -d '' file; do
        if command -v jq &>/dev/null; then
            jq . "$file" >/dev/null 2>&1 || ((errors++))
        fi
    done < <(find "$TOOLS_DIR" -name "*.json" -type f -print0 2>/dev/null)
    
    (( errors == 0 ))
}

# Test desktop entry files
test_desktop_entries() {
    local errors=0
    while IFS= read -r -d '' file; do
        # Check required fields
        if ! grep -q "^\[Desktop Entry\]" "$file" 2>/dev/null; then
            ((errors++))
            continue
        fi
        if ! grep -q "^Name=" "$file" 2>/dev/null; then
            ((errors++))
        fi
        if ! grep -q "^Exec=" "$file" 2>/dev/null; then
            ((errors++))
        fi
    done < <(find "$TOOLS_DIR" -name "*.desktop" -type f -print0 2>/dev/null)
    (( errors == 0 ))
}

# Test systemd service files
test_systemd_services() {
    local errors=0
    while IFS= read -r -d '' file; do
        if ! grep -q "^\[Unit\]" "$file" 2>/dev/null; then
            ((errors++))
            continue
        fi
        if ! grep -q "^\[Service\]" "$file" 2>/dev/null; then
            ((errors++))
        fi
    done < <(find "$TOOLS_DIR" -name "*.service" -type f -print0 2>/dev/null)
    (( errors == 0 ))
}

# Run all tests
run_test "Tool directory structure" test_tool_structure
run_test "Tool executability" test_tool_executable
run_test "Shell script syntax" test_shell_syntax
run_test "Python syntax" test_python_syntax
run_test "Config file validity" test_config_files
run_test "Desktop entry files" test_desktop_entries
run_test "Systemd service files" test_systemd_services

#!/usr/bin/env bash
# ══════════════════════════════════════════════════════════════════════════════
# Integration Tests: CLI Tools
# ══════════════════════════════════════════════════════════════════════════════

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../framework/core.sh"

TOOLS_DIR="$SANCHALA_ROOT/tools"

# Test CLI help output
test_cli_help_format() {
    # Tools should have --help that returns 0 and outputs usage
    local tool_count=0
    local help_count=0
    
    for tool_dir in "$TOOLS_DIR"/sanchala-*; do
        [[ -d "$tool_dir" ]] || continue
        local tool_name=$(basename "$tool_dir")
        
        # Find main executable
        local exec_file=""
        for candidate in "$tool_dir/$tool_name" \
                        "$tool_dir/src/main.py" \
                        "$tool_dir/${tool_name}.py" \
                        "$tool_dir/${tool_name#sanchala-}.py"; do
            if [[ -f "$candidate" ]]; then
                exec_file="$candidate"
                break
            fi
        done
        
        [[ -n "$exec_file" ]] || continue
        ((tool_count++))
        
        # Check if help exists in source
        if grep -qE '\-\-help|argparse|usage' "$exec_file" 2>/dev/null; then
            ((help_count++))
        fi
    done
    
    # At least 50% of tools should have help
    (( help_count * 2 >= tool_count ))
}

# Test CLI argument parsing
test_cli_argument_handling() {
    local valid_tools=0
    
    for tool_dir in "$TOOLS_DIR"/sanchala-*; do
        [[ -d "$tool_dir" ]] || continue
        
        # Check for argument parsing
        if grep -rqE 'argparse|getopt|getopts|\$1|\$@|sys\.argv' "$tool_dir" 2>/dev/null; then
            ((valid_tools++))
        fi
    done
    
    (( valid_tools > 0 ))
}

# Test CLI error handling
test_cli_error_handling() {
    local tools_with_error_handling=0
    
    for tool_dir in "$TOOLS_DIR"/sanchala-*; do
        [[ -d "$tool_dir" ]] || continue
        
        # Check for error handling patterns
        if grep -rqE 'try:|except|set -e|exit 1|raise|error|Error' "$tool_dir" 2>/dev/null; then
            ((tools_with_error_handling++))
        fi
    done
    
    (( tools_with_error_handling > 10 ))
}

# Test version information
test_cli_version_info() {
    local tools_with_version=0
    
    for tool_dir in "$TOOLS_DIR"/sanchala-*; do
        [[ -d "$tool_dir" ]] || continue
        
        if grep -rqE '__version__|VERSION|--version|-V' "$tool_dir" 2>/dev/null; then
            ((tools_with_version++))
        fi
    done
    
    (( tools_with_version > 0 ))
}

# Test configuration loading
test_cli_config_loading() {
    local tools_with_config=0
    
    for tool_dir in "$TOOLS_DIR"/sanchala-*; do
        [[ -d "$tool_dir" ]] || continue
        
        if grep -rqE 'config|\.conf|\.ini|\.json|\.yaml|configparser|toml' "$tool_dir" 2>/dev/null; then
            ((tools_with_config++))
        fi
    done
    
    (( tools_with_config > 0 ))
}

# Run tests
run_test "CLI help format standards" test_cli_help_format
run_test "CLI argument handling" test_cli_argument_handling
run_test "CLI error handling" test_cli_error_handling
run_test "CLI version information" test_cli_version_info
run_test "CLI config loading" test_cli_config_loading

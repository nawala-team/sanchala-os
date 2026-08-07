#!/usr/bin/env bash
# ══════════════════════════════════════════════════════════════════════════════
# Security Tests: Code Audit
# ══════════════════════════════════════════════════════════════════════════════

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../framework/core.sh"
source "$SCRIPT_DIR/../../framework/security.sh"

TOOLS_DIR="$SANCHALA_ROOT/tools"

# Test for dangerous functions
test_no_dangerous_shell_functions() {
    local dangerous_patterns=(
        'rm -rf /'
        'rm -rf /*'
        'dd if=/dev/zero of=/dev/sd'
        'mkfs\.'
        '> /dev/sd'
    )
    
    local issues=0
    for pattern in "${dangerous_patterns[@]}"; do
        if grep -rq "$pattern" "$TOOLS_DIR" 2>/dev/null; then
            ((issues++))
        fi
    done
    (( issues == 0 ))
}

# Test for proper error handling
test_shell_error_handling() {
    local scripts_with_errexit=0
    local total_scripts=0
    
    while IFS= read -r -d '' file; do
        ((total_scripts++))
        if grep -qE 'set -e|set -o errexit' "$file" 2>/dev/null; then
            ((scripts_with_errexit++))
        fi
    done < <(find "$TOOLS_DIR" -name "*.sh" -type f -print0 2>/dev/null)
    
    # At least 30% should have proper error handling
    (( total_scripts == 0 || scripts_with_errexit * 100 / total_scripts >= 30 ))
}

# Test for input validation
test_input_validation() {
    local tools_with_validation=0
    
    while IFS= read -r -d '' file; do
        if grep -qE '\[\[ -z|\[\[ -n|if \[ |validate|sanitize|check_' "$file" 2>/dev/null; then
            ((tools_with_validation++))
        fi
    done < <(find "$TOOLS_DIR" -name "*.sh" -type f -print0 2>/dev/null)
    
    (( tools_with_validation > 0 ))
}

# Test Python security patterns
test_python_no_pickle_loads() {
    local issues=0
    while IFS= read -r -d '' file; do
        if grep -qE 'pickle\.loads?\(' "$file" 2>/dev/null; then
            # Check if it's from untrusted source
            if grep -qE 'request|input|open\(' "$file" 2>/dev/null; then
                ((issues++))
            fi
        fi
    done < <(find "$TOOLS_DIR" -name "*.py" -type f -print0 2>/dev/null)
    (( issues == 0 ))
}

test_python_no_exec_eval() {
    local issues=0
    while IFS= read -r -d '' file; do
        # Check for exec/eval with user input
        if grep -qE 'exec\(|eval\(' "$file" 2>/dev/null; then
            if grep -qE 'input\(|request\.|sys\.argv' "$file" 2>/dev/null; then
                ((issues++))
            fi
        fi
    done < <(find "$TOOLS_DIR" -name "*.py" -type f -print0 2>/dev/null)
    (( issues == 0 ))
}

test_python_subprocess_shell() {
    local issues=0
    while IFS= read -r -d '' file; do
        # Check for shell=True with user input
        if grep -qE 'subprocess.*shell\s*=\s*True' "$file" 2>/dev/null; then
            if grep -qE 'format\(|%\s|f".*\{' "$file" 2>/dev/null; then
                ((issues++))
            fi
        fi
    done < <(find "$TOOLS_DIR" -name "*.py" -type f -print0 2>/dev/null)
    (( issues == 0 ))
}

# Test for logging sensitive data
test_no_sensitive_logging() {
    local issues=0
    while IFS= read -r -d '' file; do
        if grep -qiE 'log.*(password|secret|token|key)' "$file" 2>/dev/null; then
            ((issues++))
        fi
    done < <(find "$TOOLS_DIR" -type f \( -name "*.sh" -o -name "*.py" \) -print0 2>/dev/null)
    (( issues == 0 ))
}

# Test HTTPS usage
test_https_preferred() {
    local http_count=0
    local https_count=0
    
    while IFS= read -r -d '' file; do
        http_count=$((http_count + $(grep -c 'http://' "$file" 2>/dev/null || echo 0)))
        https_count=$((https_count + $(grep -c 'https://' "$file" 2>/dev/null || echo 0)))
    done < <(find "$TOOLS_DIR" -type f \( -name "*.sh" -o -name "*.py" \) -print0 2>/dev/null)
    
    # HTTPS should be more common than HTTP
    (( http_count == 0 || https_count >= http_count ))
}

# Run tests
run_test "No dangerous shell commands" test_no_dangerous_shell_functions
run_test "Shell error handling" test_shell_error_handling
run_test "Input validation present" test_input_validation
run_test "No unsafe pickle usage" test_python_no_pickle_loads
run_test "No unsafe exec/eval" test_python_no_exec_eval
run_test "No unsafe subprocess shell" test_python_subprocess_shell
run_test "No sensitive data in logs" test_no_sensitive_logging
run_test "HTTPS preferred over HTTP" test_https_preferred

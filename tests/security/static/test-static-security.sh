#!/usr/bin/env bash
# ══════════════════════════════════════════════════════════════════════════════
# Security Tests: Static Analysis
# ══════════════════════════════════════════════════════════════════════════════

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../framework/core.sh"
source "$SCRIPT_DIR/../../framework/security.sh"

TOOLS_DIR="$SANCHALA_ROOT/tools"

# Test for hardcoded credentials
test_no_hardcoded_passwords() {
    local issues=0
    while IFS= read -r -d '' file; do
        if grep -qiE 'password\s*=\s*["\x27][a-zA-Z0-9]+["\x27]' "$file" 2>/dev/null; then
            ((issues++))
        fi
    done < <(find "$TOOLS_DIR" -type f \( -name "*.sh" -o -name "*.py" \) -print0 2>/dev/null)
    (( issues == 0 ))
}

test_no_hardcoded_api_keys() {
    local issues=0
    while IFS= read -r -d '' file; do
        if grep -qiE 'api_key\s*=\s*["\x27][a-zA-Z0-9]{20,}["\x27]' "$file" 2>/dev/null; then
            ((issues++))
        fi
    done < <(find "$TOOLS_DIR" -type f \( -name "*.sh" -o -name "*.py" \) -print0 2>/dev/null)
    (( issues == 0 ))
}

test_no_private_keys() {
    local issues=0
    while IFS= read -r -d '' file; do
        if grep -q 'BEGIN.*PRIVATE KEY' "$file" 2>/dev/null; then
            ((issues++))
        fi
    done < <(find "$SANCHALA_ROOT" -type f -print0 2>/dev/null)
    (( issues == 0 ))
}

# Test for command injection vulnerabilities
test_no_unsafe_eval() {
    local issues=0
    while IFS= read -r -d '' file; do
        # Check for eval with unquoted variables
        if grep -qE 'eval\s+\$[^"'\''(]' "$file" 2>/dev/null; then
            ((issues++))
        fi
    done < <(find "$TOOLS_DIR" -name "*.sh" -type f -print0 2>/dev/null)
    (( issues == 0 ))
}

test_no_unsafe_bash_c() {
    local issues=0
    while IFS= read -r -d '' file; do
        if grep -qE 'bash\s+-c\s+\$[^"'\''(]' "$file" 2>/dev/null; then
            ((issues++))
        fi
    done < <(find "$TOOLS_DIR" -name "*.sh" -type f -print0 2>/dev/null)
    (( issues == 0 ))
}

# Test for SQL injection patterns
test_no_sql_injection() {
    local issues=0
    while IFS= read -r -d '' file; do
        # Check for string concatenation in SQL
        if grep -qE 'execute.*\+.*\$|cursor\.execute.*%' "$file" 2>/dev/null; then
            ((issues++))
        fi
    done < <(find "$TOOLS_DIR" -name "*.py" -type f -print0 2>/dev/null)
    (( issues == 0 ))
}

# Test file permissions
test_no_world_writable_scripts() {
    local issues=0
    while IFS= read -r -d '' file; do
        if [[ -w "$file" ]] && stat -c %a "$file" 2>/dev/null | grep -qE '[2367]$'; then
            ((issues++))
        fi
    done < <(find "$TOOLS_DIR" -type f \( -name "*.sh" -o -name "*.py" \) -print0 2>/dev/null)
    (( issues == 0 ))
}

# Test for path traversal
test_no_path_traversal() {
    local issues=0
    while IFS= read -r -d '' file; do
        if grep -qE '\.\./\.\.' "$file" 2>/dev/null; then
            ((issues++))
        fi
    done < <(find "$TOOLS_DIR" -type f \( -name "*.sh" -o -name "*.py" \) -print0 2>/dev/null)
    (( issues == 0 ))
}

# Test for insecure temp file creation
test_secure_temp_files() {
    local issues=0
    while IFS= read -r -d '' file; do
        # Check for insecure temp patterns
        if grep -qE '/tmp/[a-zA-Z]+\$' "$file" 2>/dev/null; then
            if ! grep -qE 'mktemp|tempfile' "$file" 2>/dev/null; then
                ((issues++))
            fi
        fi
    done < <(find "$TOOLS_DIR" -name "*.sh" -type f -print0 2>/dev/null)
    (( issues == 0 ))
}

# Run tests
run_test "No hardcoded passwords" test_no_hardcoded_passwords
run_test "No hardcoded API keys" test_no_hardcoded_api_keys
run_test "No private keys in repo" test_no_private_keys
run_test "No unsafe eval usage" test_no_unsafe_eval
run_test "No unsafe bash -c" test_no_unsafe_bash_c
run_test "No SQL injection patterns" test_no_sql_injection
run_test "No world-writable scripts" test_no_world_writable_scripts
run_test "No path traversal patterns" test_no_path_traversal
run_test "Secure temp file creation" test_secure_temp_files

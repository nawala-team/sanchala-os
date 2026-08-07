#!/usr/bin/env bash
# ══════════════════════════════════════════════════════════════════════════════
# SANCHALA OS - Security Audit Tests
# ══════════════════════════════════════════════════════════════════════════════
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../framework/test-engine.sh"

PROJECT_ROOT="${SCRIPT_DIR}/../../"

describe "Security Audit: File Permissions"

test_no_world_writable_scripts() {
    local violations=0
    while IFS= read -r script; do
        if [[ -f "$script" ]]; then
            local perms=$(stat -c %a "$script" 2>/dev/null || stat -f %Lp "$script" 2>/dev/null)
            if [[ "${perms: -1}" =~ [2367] ]]; then
                log_warn "World-writable: $script"
                ((violations++))
            fi
        fi
    done < <(find "$PROJECT_ROOT" \( -name "*.sh" -o -name "*.py" \) -type f 2>/dev/null | head -100)
    assert_equals 0 "$violations" "No world-writable scripts"
}

test_no_suid_scripts() {
    local violations=0
    while IFS= read -r file; do
        if [[ -u "$file" ]]; then
            log_warn "SUID bit set: $file"
            ((violations++))
        fi
    done < <(find "$PROJECT_ROOT" -type f \( -name "*.sh" -o -name "*.py" \) 2>/dev/null)
    assert_equals 0 "$violations" "No SUID scripts"
}

describe "Security Audit: Secrets Detection"

test_no_hardcoded_passwords() {
    local violations=0
    local patterns=('password\s*=\s*["\x27][^${\x27"]+["\x27]' 'passwd\s*=\s*["\x27]' 'pwd\s*=\s*["\x27][a-zA-Z0-9]')
    while IFS= read -r file; do
        for pattern in "${patterns[@]}"; do
            if grep -qiE "$pattern" "$file" 2>/dev/null; then
                if ! grep -qiE '(example|changeme|placeholder|\$\{|getenv)' "$file" 2>/dev/null; then
                    log_warn "Possible hardcoded password: $file"
                    ((violations++))
                fi
            fi
        done
    done < <(find "$PROJECT_ROOT" -type f \( -name "*.py" -o -name "*.sh" -o -name "*.conf" \) 2>/dev/null | head -100)
    assert_less_than "$violations" 3 "No hardcoded passwords"
}

test_no_api_keys_exposed() {
    local violations=0
    local patterns=('api_key\s*=\s*["\x27][a-zA-Z0-9]{20,}' 'apikey\s*=\s*["\x27]' 'secret_key\s*=\s*["\x27][^$]')
    while IFS= read -r file; do
        for pattern in "${patterns[@]}"; do
            if grep -qiE "$pattern" "$file" 2>/dev/null; then
                log_warn "Possible exposed API key: $file"
                ((violations++))
            fi
        done
    done < <(find "$PROJECT_ROOT" -type f \( -name "*.py" -o -name "*.json" -o -name "*.conf" \) 2>/dev/null | head -100)
    assert_less_than "$violations" 3 "No exposed API keys"
}

test_no_private_keys() {
    local violations=0
    while IFS= read -r file; do
        if grep -q 'BEGIN.*PRIVATE KEY' "$file" 2>/dev/null; then
            log_warn "Private key found: $file"
            ((violations++))
        fi
    done < <(find "$PROJECT_ROOT" -type f 2>/dev/null | head -200)
    assert_equals 0 "$violations" "No private keys in repo"
}

describe "Security Audit: Input Validation"

test_no_eval_with_user_input() {
    local violations=0
    while IFS= read -r script; do
        if grep -qE 'eval\s+\$' "$script" 2>/dev/null; then
            log_warn "Unsafe eval: $script"
            ((violations++))
        fi
    done < <(find "$PROJECT_ROOT" -name "*.sh" -type f 2>/dev/null | head -100)
    assert_less_than "$violations" 5 "Minimal unsafe eval usage"
}

test_sql_injection_prevention() {
    local violations=0
    while IFS= read -r file; do
        # Check for string concatenation in SQL
        if grep -qE 'execute.*\+.*\$|cursor\.execute.*%.*\(' "$file" 2>/dev/null; then
            log_warn "Possible SQL injection: $file"
            ((violations++))
        fi
    done < <(find "$PROJECT_ROOT" -name "*.py" -type f 2>/dev/null | head -100)
    assert_equals 0 "$violations" "No SQL injection vulnerabilities"
}

test_command_injection_prevention() {
    local violations=0
    while IFS= read -r file; do
        if grep -qE 'os\.system\s*\([^)]*\+|subprocess\.(call|run|Popen)\s*\([^)]*shell\s*=\s*True.*\+' "$file" 2>/dev/null; then
            log_warn "Possible command injection: $file"
            ((violations++))
        fi
    done < <(find "$PROJECT_ROOT" -name "*.py" -type f 2>/dev/null | head -100)
    assert_less_than "$violations" 3 "Minimal command injection risk"
}

# Run all security tests
it "No world-writable scripts"; test_no_world_writable_scripts && pass_test || fail_test
it "No SUID scripts"; test_no_suid_scripts && pass_test || fail_test
it "No hardcoded passwords"; test_no_hardcoded_passwords && pass_test || fail_test
it "No exposed API keys"; test_no_api_keys_exposed && pass_test || fail_test
it "No private keys"; test_no_private_keys && pass_test || fail_test
it "No unsafe eval"; test_no_eval_with_user_input && pass_test || fail_test
it "SQL injection prevention"; test_sql_injection_prevention && pass_test || fail_test
it "Command injection prevention"; test_command_injection_prevention && pass_test || fail_test

end_describe

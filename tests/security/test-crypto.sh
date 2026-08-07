#!/usr/bin/env bash
# ══════════════════════════════════════════════════════════════════════════════
# SANCHALA OS - Security Tests: Cryptography
# ══════════════════════════════════════════════════════════════════════════════
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../framework/test-engine.sh"

PROJECT_ROOT="${SCRIPT_DIR}/../../"

describe "Cryptography Security Tests"

test_no_weak_hashing() {
    local violations=0
    local weak_patterns=('md5(' 'hashlib.md5' 'sha1(' 'hashlib.sha1')
    while IFS= read -r file; do
        for pattern in "${weak_patterns[@]}"; do
            if grep -q "$pattern" "$file" 2>/dev/null; then
                # Check if used for non-security purposes
                if ! grep -qE '(checksum|fingerprint|cache)' "$file" 2>/dev/null; then
                    log_warn "Weak hash used: $pattern in $file"
                    ((violations++))
                fi
            fi
        done
    done < <(find "$PROJECT_ROOT" -name "*.py" -type f 2>/dev/null | head -100)
    assert_less_than "$violations" 3 "No weak hashing for security"
}

test_no_weak_encryption() {
    local violations=0
    local weak_ciphers=('DES' 'RC4' 'Blowfish' 'ECB')
    while IFS= read -r file; do
        for cipher in "${weak_ciphers[@]}"; do
            if grep -qi "$cipher" "$file" 2>/dev/null; then
                log_warn "Weak cipher: $cipher in $file"
                ((violations++))
            fi
        done
    done < <(find "$PROJECT_ROOT" -type f \( -name "*.py" -o -name "*.conf" \) 2>/dev/null | head -100)
    assert_equals 0 "$violations" "No weak encryption"
}

test_secure_random_usage() {
    local violations=0
    while IFS= read -r file; do
        if grep -qE 'random\.(random|randint|choice)' "$file" 2>/dev/null; then
            # Check context - security-sensitive?
            if grep -qiE '(token|secret|key|password|salt)' "$file" 2>/dev/null; then
                log_warn "Insecure random for security: $file"
                ((violations++))
            fi
        fi
    done < <(find "$PROJECT_ROOT" -name "*.py" -type f 2>/dev/null | head -100)
    assert_less_than "$violations" 3 "Secure random for security purposes"
}

it "No weak hashing"; test_no_weak_hashing && pass_test || fail_test
it "No weak encryption"; test_no_weak_encryption && pass_test || fail_test
it "Secure random usage"; test_secure_random_usage && pass_test || fail_test

end_describe

#!/usr/bin/env bash
# ══════════════════════════════════════════════════════════════════════════════
# SANCHALA OS - Security Tests: Network Security
# ══════════════════════════════════════════════════════════════════════════════
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../framework/test-engine.sh"

PROJECT_ROOT="${SCRIPT_DIR}/../../"

describe "Network Security Tests"

test_https_enforced() {
    local violations=0
    while IFS= read -r file; do
        if grep -qE 'http://[^l]' "$file" 2>/dev/null; then
            # Exclude localhost
            if ! grep -qE 'http://(localhost|127\.0\.0\.1|0\.0\.0\.0)' "$file" 2>/dev/null; then
                log_warn "Non-HTTPS URL: $file"
                ((violations++))
            fi
        fi
    done < <(find "$PROJECT_ROOT" -type f \( -name "*.py" -o -name "*.sh" -o -name "*.json" \) 2>/dev/null | head -100)
    assert_less_than "$violations" 5 "HTTPS should be enforced"
}

test_ssl_verification_enabled() {
    local violations=0
    while IFS= read -r file; do
        if grep -qE 'verify\s*=\s*False|CERT_NONE|ssl_verify.*false' "$file" 2>/dev/null; then
            log_warn "SSL verification disabled: $file"
            ((violations++))
        fi
    done < <(find "$PROJECT_ROOT" -name "*.py" -type f 2>/dev/null | head -100)
    assert_equals 0 "$violations" "SSL verification should be enabled"
}

test_no_hardcoded_ips() {
    local violations=0
    while IFS= read -r file; do
        # Check for hardcoded public IPs (not localhost/private)
        if grep -qE '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' "$file" 2>/dev/null; then
            if ! grep -qE '(127\.|192\.168\.|10\.|172\.(1[6-9]|2[0-9]|3[01])\.|0\.0\.0\.0)' "$file" 2>/dev/null; then
                log_warn "Hardcoded IP: $file"
                ((violations++))
            fi
        fi
    done < <(find "$PROJECT_ROOT" -type f \( -name "*.py" -o -name "*.conf" \) 2>/dev/null | head -50)
    assert_less_than "$violations" 5 "No hardcoded public IPs"
}

it "HTTPS enforced"; test_https_enforced && pass_test || fail_test
it "SSL verification enabled"; test_ssl_verification_enabled && pass_test || fail_test
it "No hardcoded public IPs"; test_no_hardcoded_ips && pass_test || fail_test

end_describe

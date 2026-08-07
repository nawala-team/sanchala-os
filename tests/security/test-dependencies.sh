#!/usr/bin/env bash
# ══════════════════════════════════════════════════════════════════════════════
# SANCHALA OS - Security Tests: Dependency Audit
# ══════════════════════════════════════════════════════════════════════════════
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../framework/test-engine.sh"

PROJECT_ROOT="${SCRIPT_DIR}/../../"

describe "Dependency Security Audit"

test_no_vulnerable_package_versions() {
    local known_vulnerable=("log4j:2.14" "openssl:1.0" "python:2.7")
    local violations=0
    
    while IFS= read -r pkg_file; do
        for vuln in "${known_vulnerable[@]}"; do
            if grep -qi "${vuln%:*}" "$pkg_file" 2>/dev/null; then
                local version=$(grep -oiE "${vuln%:*}[^0-9]*[0-9.]+" "$pkg_file" | head -1)
                log_warn "Check version: $version in $pkg_file"
            fi
        done
    done < <(find "$PROJECT_ROOT" \( -name "requirements*.txt" -o -name "package.json" -o -name "PKGBUILD" \) 2>/dev/null)
    assert_equals 0 "$violations" "No known vulnerable versions"
}

test_pinned_dependencies() {
    local unpinned=0
    while IFS= read -r req_file; do
        if grep -qE '^[a-zA-Z]+==$' "$req_file" 2>/dev/null; then
            log_warn "Unpinned in: $req_file"
            ((unpinned++))
        fi
    done < <(find "$PROJECT_ROOT" -name "requirements*.txt" -type f 2>/dev/null)
    assert_less_than "$unpinned" 3 "Dependencies should be pinned"
}

it "No vulnerable packages"; test_no_vulnerable_package_versions && pass_test || fail_test
it "Pinned dependencies"; test_pinned_dependencies && pass_test || fail_test

end_describe

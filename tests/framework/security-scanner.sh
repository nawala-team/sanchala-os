#!/usr/bin/env bash
# SANCHALA OS - Security Scanner Module
set -euo pipefail

run_shellcheck() {
    local file="$1"
    command -v shellcheck &>/dev/null || { log_warn "shellcheck not installed"; return 0; }
    shellcheck -f gcc "$file" 2>/dev/null
}

check_hardcoded_secrets() {
    local file="$1"
    grep -iE "(password|secret|api_key|token)\s*=\s*[\"'][^\"']+[\"']" "$file" 2>/dev/null && return 1 || return 0
}

check_command_injection() {
    local file="$1"
    grep -E 'eval\s+"\$' "$file" 2>/dev/null && return 1 || return 0
}

run_security_scan() {
    local file="$1" issues=0
    check_hardcoded_secrets "$file" || ((issues++))
    check_command_injection "$file" || ((issues++))
    return $issues
}

scan_directory() {
    local dir="$1" total=0 issues=0
    log_section "Security Scan: $dir"
    for file in "$dir"/*.sh; do
        [[ -f "$file" ]] || continue
        ((total++))
        run_security_scan "$file" || ((issues++))
    done
    log_info "Scanned $total files, $issues with issues"
}

export -f run_shellcheck check_hardcoded_secrets check_command_injection run_security_scan scan_directory

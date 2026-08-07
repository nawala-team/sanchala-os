#!/usr/bin/env bash
# ══════════════════════════════════════════════════════════════════════════════
# SANCHALA OS - Automated Security Audit Script
# ══════════════════════════════════════════════════════════════════════════════
# Usage: sudo sanchala-security-audit [--full|--quick|--kernel|--network]
# ══════════════════════════════════════════════════════════════════════════════

set -euo pipefail

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; NC='\033[0m'
PASS=0; FAIL=0; WARN=0

log_pass() { echo -e "${GREEN}[✓]${NC} $1"; ((PASS++)); }
log_fail() { echo -e "${RED}[✗]${NC} $1"; ((FAIL++)); }
log_warn() { echo -e "${YELLOW}[!]${NC} $1"; ((WARN++)); }
log_info() { echo -e "${BLUE}[i]${NC} $1"; }
log_header() { echo -e "\n${BLUE}═══ $1 ═══${NC}"; }

check_root() { [[ $EUID -eq 0 ]] || { echo "Run as root"; exit 1; }; }

check_kernel_hardening() {
    log_header "KERNEL HARDENING"
    local checks=(
        "kernel.kptr_restrict:2:Hide kernel pointers"
        "kernel.dmesg_restrict:1:Restrict dmesg"
        "kernel.yama.ptrace_scope:2:Restrict ptrace"
        "kernel.randomize_va_space:2:Full ASLR"
        "fs.suid_dumpable:0:No SUID core dumps"
        "fs.protected_symlinks:1:Symlink protection"
        "net.ipv4.tcp_syncookies:1:SYN flood protection"
        "net.ipv4.conf.all.rp_filter:1:Reverse path filter"
        "net.ipv4.conf.all.accept_redirects:0:No ICMP redirects"
    )
    for check in "${checks[@]}"; do
        IFS=':' read -r key expected desc <<< "$check"
        actual=$(sysctl -n "$key" 2>/dev/null || echo "N/A")
        [[ "$actual" == "$expected" ]] && log_pass "$desc" || log_fail "$desc ($actual != $expected)"
    done
}

check_cpu_vulns() {
    log_header "CPU VULNERABILITIES"
    for vuln in /sys/devices/system/cpu/vulnerabilities/*; do
        [[ -f "$vuln" ]] || continue
        name=$(basename "$vuln"); status=$(cat "$vuln")
        [[ "$status" == *"Not affected"* || "$status" == *"Mitigation"* ]] \
            && log_pass "$name" || log_warn "$name: $status"
    done
}

check_apparmor() {
    log_header "APPARMOR STATUS"
    if command -v aa-status &>/dev/null && aa-enabled &>/dev/null; then
        log_pass "AppArmor enabled"
    else
        log_fail "AppArmor not enabled"
    fi
}

check_firewall() {
    log_header "FIREWALL STATUS"
    if systemctl is-active --quiet nftables 2>/dev/null; then
        log_pass "nftables active"
    elif systemctl is-active --quiet firewalld 2>/dev/null; then
        log_pass "firewalld active"
    else
        log_fail "No firewall active"
    fi
}

check_audit() {
    log_header "AUDIT SYSTEM"
    systemctl is-active --quiet auditd 2>/dev/null && log_pass "auditd active" || log_fail "auditd not running"
}

check_permissions() {
    log_header "FILE PERMISSIONS"
    for entry in "/etc/passwd:644" "/etc/shadow:640"; do
        IFS=':' read -r file expected <<< "$entry"
        [[ -f "$file" ]] || continue
        actual=$(stat -c %a "$file")
        [[ "$actual" == "$expected" ]] && log_pass "$file: $actual" || log_fail "$file: $actual != $expected"
    done
}

print_summary() {
    log_header "SUMMARY"
    echo -e "Passed: ${GREEN}$PASS${NC} | Failed: ${RED}$FAIL${NC} | Warnings: ${YELLOW}$WARN${NC}"
    local total=$((PASS + FAIL)); [[ $total -gt 0 ]] && echo -e "Score: ${BLUE}$((PASS * 100 / total))%${NC}"
}

main() {
    check_root
    echo "══════════════════════════════════════════════════════════════"
    echo "        SANCHALA OS - Security Audit | $(date +%Y-%m-%d)"
    echo "══════════════════════════════════════════════════════════════"
    check_kernel_hardening; check_cpu_vulns; check_apparmor
    check_firewall; check_audit; check_permissions; print_summary
}

main "$@"

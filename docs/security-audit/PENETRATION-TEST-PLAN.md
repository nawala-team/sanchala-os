# SANCHALA OS - Penetration Test Plan

## Internal Security Testing Methodology

**Version:** 1.0  
**Classification:** Confidential  

---

## 1. Test Scope

### 1.1 In-Scope

| Target | Description |
|--------|-------------|
| Kernel | linux-hardened, sysctl, modules |
| Services | systemd services, daemons |
| Network | Firewall, DNS, network stack |
| Applications | Default apps, Flatpak sandbox |
| Authentication | PAM, sudo, polkit |
| Encryption | LUKS, fscrypt, TLS |

### 1.2 Out-of-Scope

- Physical attacks requiring hardware access
- Social engineering
- Third-party cloud services
- Denial of service (production systems)

---

## 2. Test Categories

### 2.1 Privilege Escalation

| Test ID | Test Case | Method |
|---------|-----------|--------|
| PE-001 | SUID binary exploitation | `find / -perm -4000` |
| PE-002 | Sudo misconfiguration | `sudo -l` analysis |
| PE-003 | Capability abuse | `getcap -r /` |
| PE-004 | Kernel exploit (CVE) | Known exploit check |
| PE-005 | Service escalation | Misconfigured daemons |
| PE-006 | Polkit bypass | CVE checks |

### 2.2 Sandbox Escape

| Test ID | Test Case | Target |
|---------|-----------|--------|
| SE-001 | Flatpak escape | Portal abuse |
| SE-002 | AppArmor bypass | Profile gaps |
| SE-003 | Seccomp bypass | Filter analysis |
| SE-004 | Namespace escape | User namespace |
| SE-005 | D-Bus exploitation | Service interfaces |

### 2.3 Network Security

| Test ID | Test Case | Tool |
|---------|-----------|------|
| NS-001 | Port scanning | nmap |
| NS-002 | Service enumeration | nmap scripts |
| NS-003 | Firewall bypass | nftables analysis |
| NS-004 | DNS security | dnsenum, dig |
| NS-005 | TLS configuration | testssl.sh |

### 2.4 Authentication Attacks

| Test ID | Test Case | Method |
|---------|-----------|--------|
| AU-001 | Password brute force | Lockout verification |
| AU-002 | PAM bypass | Configuration review |
| AU-003 | Session hijacking | Token analysis |
| AU-004 | Credential storage | Memory inspection |

---

## 3. Test Procedures

### 3.1 Pre-Test Setup

```bash
# Create test snapshot
sudo btrfs subvolume snapshot / /snapshots/pentest-$(date +%Y%m%d)

# Enable verbose logging
sudo auditctl -e 1
sudo journalctl -f &

# Document baseline
ss -tlnp > baseline-ports.txt
ps aux > baseline-processes.txt
```

### 3.2 Privilege Escalation Tests

```bash
# SUID enumeration
find / -perm -4000 -type f 2>/dev/null | tee suid-files.txt

# Check each SUID for known exploits
for f in $(cat suid-files.txt); do
    echo "=== $f ==="
    ls -la "$f"
    # Check GTFOBins
done

# Sudo analysis
sudo -l
cat /etc/sudoers.d/* 2>/dev/null

# Capabilities
getcap -r / 2>/dev/null | tee capabilities.txt

# Writable paths in $PATH
echo $PATH | tr ':' '\n' | xargs -I{} find {} -writable 2>/dev/null
```

### 3.3 Sandbox Escape Tests

```bash
# Flatpak permissions audit
flatpak list --app --columns=application | while read app; do
    echo "=== $app ==="
    flatpak info --show-permissions "$app"
done

# AppArmor gaps
aa-status
# Check for unconfined processes
ps aux | grep -v '\[' | awk '{print $11}' | sort -u | while read proc; do
    aa-status 2>/dev/null | grep -q "$proc" || echo "Unconfined: $proc"
done
```

### 3.4 Network Tests

```bash
# Internal port scan
nmap -sV -sC -p- 127.0.0.1

# Firewall rule analysis
sudo nft list ruleset > firewall-rules.txt

# Check for listening services
ss -tlnp | grep -v "127.0.0.1"

# DNS security
dig +dnssec example.com
resolvectl status
```

---

## 4. Findings Template

```
┌──────────────────────────────────────────────┐
│ Finding ID: PT-XXXX                          │
│ Title: [Finding Title]                       │
│ Severity: ☐ Critical ☐ High ☐ Medium ☐ Low  │
│ CVSS: X.X                                    │
├──────────────────────────────────────────────┤
│ Category: [Privilege Escalation/Sandbox/etc] │
│ Affected Component: [component]              │
├──────────────────────────────────────────────┤
│ Description:                                 │
│ [Detailed description]                       │
│                                              │
│ Steps to Reproduce:                          │
│ 1. [Step 1]                                  │
│ 2. [Step 2]                                  │
│                                              │
│ Impact:                                      │
│ [What an attacker could achieve]             │
│                                              │
│ Recommendation:                              │
│ [How to fix]                                 │
├──────────────────────────────────────────────┤
│ Status: ☐ Open ☐ Fixed ☐ Accepted           │
└──────────────────────────────────────────────┘
```

---

## 5. Reporting

### 5.1 Executive Summary

- Total findings by severity
- Critical/High findings summary
- Overall security posture assessment
- Comparison to previous test

### 5.2 Detailed Findings

- Full finding details per template
- Evidence (screenshots, logs)
- Remediation recommendations

### 5.3 Remediation Tracking

| Finding | Severity | Owner | Due | Status |
|---------|----------|-------|-----|--------|
| PT-001 | Critical | | | |
| PT-002 | High | | | |

---

## 6. Test Schedule

| Phase | Duration | Activities |
|-------|----------|------------|
| Planning | 1 day | Scope, rules of engagement |
| Recon | 1 day | Information gathering |
| Testing | 3 days | Active testing |
| Analysis | 1 day | Finding validation |
| Reporting | 1 day | Report generation |
| Retest | 1 day | Verify fixes |

---

**Tester:** ________  
**Test Date:** ________  
**Approved By:** ________

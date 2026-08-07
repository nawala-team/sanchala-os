# SANCHALA OS - CIS Benchmark Compliance

## CIS Linux Benchmark Verification

**Benchmark:** CIS Distribution Independent Linux v2.0  
**Target Level:** Level 2 (Server/Workstation)  

---

## Compliance Summary

| Section | Controls | Compliant | Non-Compliant | N/A |
|---------|----------|-----------|---------------|-----|
| 1. Initial Setup | 25 | | | |
| 2. Services | 20 | | | |
| 3. Network | 35 | | | |
| 4. Logging | 20 | | | |
| 5. Access Control | 30 | | | |
| 6. Maintenance | 15 | | | |
| **TOTAL** | **145** | | | |

---

## 1. Initial Setup

### 1.1 Filesystem Configuration

| ID | Control | Status | Command |
|----|---------|--------|---------|
| 1.1.1 | Disable cramfs | ☐ | `lsmod \| grep cramfs` |
| 1.1.2 | Disable freevxfs | ☐ | `lsmod \| grep freevxfs` |
| 1.1.3 | Disable jffs2 | ☐ | `lsmod \| grep jffs2` |
| 1.1.4 | Disable hfs/hfsplus | ☐ | `lsmod \| grep hfs` |
| 1.1.5 | /tmp separate partition | ☐ | `mount \| grep /tmp` |
| 1.1.6 | /tmp nodev,nosuid,noexec | ☐ | `mount \| grep /tmp` |

### 1.2 Software Updates

| ID | Control | Status | Command |
|----|---------|--------|---------|
| 1.2.1 | Package manager configured | ☐ | `cat /etc/pacman.conf` |
| 1.2.2 | GPG keys configured | ☐ | `pacman-key --list-keys` |
| 1.2.3 | Package signatures required | ☐ | `grep SigLevel /etc/pacman.conf` |

### 1.3 Process Hardening

| ID | Control | Status | Sysctl |
|----|---------|--------|--------|
| 1.3.1 | ASLR enabled | ☐ | `kernel.randomize_va_space = 2` |
| 1.3.2 | ptrace restricted | ☐ | `kernel.yama.ptrace_scope = 2` |
| 1.3.3 | Core dumps restricted | ☐ | `fs.suid_dumpable = 0` |

---

## 2. Services

| ID | Control | Status | Command |
|----|---------|--------|---------|
| 2.1.1 | Avahi disabled | ☐ | `systemctl is-enabled avahi-daemon` |
| 2.1.2 | CUPS disabled (if unused) | ☐ | `systemctl is-enabled cups` |
| 2.1.3 | DHCP server disabled | ☐ | `systemctl is-enabled dhcpd` |
| 2.1.4 | NFS disabled | ☐ | `systemctl is-enabled nfs-server` |
| 2.1.5 | FTP server disabled | ☐ | `systemctl is-enabled vsftpd` |
| 2.1.6 | HTTP server disabled | ☐ | `systemctl is-enabled httpd` |
| 2.2.1 | NIS client removed | ☐ | `pacman -Q ypbind` |
| 2.2.2 | telnet client removed | ☐ | `pacman -Q telnet` |

---

## 3. Network Configuration

### 3.1 Network Parameters

| ID | Control | Status | Sysctl Value |
|----|---------|--------|--------------|
| 3.1.1 | IP forwarding disabled | ☐ | `net.ipv4.ip_forward = 0` |
| 3.1.2 | Send redirects disabled | ☐ | `net.ipv4.conf.all.send_redirects = 0` |
| 3.2.1 | Source routing rejected | ☐ | `net.ipv4.conf.all.accept_source_route = 0` |
| 3.2.2 | ICMP redirects rejected | ☐ | `net.ipv4.conf.all.accept_redirects = 0` |
| 3.2.3 | Martians logged | ☐ | `net.ipv4.conf.all.log_martians = 1` |
| 3.2.4 | Broadcast ICMP ignored | ☐ | `net.ipv4.icmp_echo_ignore_broadcasts = 1` |
| 3.2.5 | RP filtering enabled | ☐ | `net.ipv4.conf.all.rp_filter = 1` |
| 3.2.6 | TCP SYN cookies | ☐ | `net.ipv4.tcp_syncookies = 1` |
| 3.2.7 | IPv6 RA disabled | ☐ | `net.ipv6.conf.all.accept_ra = 0` |

### 3.2 Firewall

| ID | Control | Status | Command |
|----|---------|--------|---------|
| 3.3.1 | Firewall installed | ☐ | `pacman -Q nftables` |
| 3.3.2 | Firewall enabled | ☐ | `systemctl is-enabled nftables` |
| 3.3.3 | Default deny policy | ☐ | `nft list ruleset` |

---

## 4. Logging and Auditing

### 4.1 Audit Configuration

| ID | Control | Status | Command |
|----|---------|--------|---------|
| 4.1.1 | auditd installed | ☐ | `pacman -Q audit` |
| 4.1.2 | auditd enabled | ☐ | `systemctl is-enabled auditd` |
| 4.1.3 | Time changes audited | ☐ | `auditctl -l \| grep time` |
| 4.1.4 | User/group changes audited | ☐ | `auditctl -l \| grep identity` |
| 4.1.5 | Network changes audited | ☐ | `auditctl -l \| grep network` |
| 4.1.6 | Login events audited | ☐ | `auditctl -l \| grep logins` |
| 4.1.7 | Privilege escalation audited | ☐ | `auditctl -l \| grep sudo` |
| 4.1.8 | Kernel modules audited | ☐ | `auditctl -l \| grep module` |

---

## 5. Access Control

### 5.1 SSH Server

| ID | Control | Status | Setting |
|----|---------|--------|---------|
| 5.1.1 | PermitRootLogin no | ☐ | `/etc/ssh/sshd_config` |
| 5.1.2 | PermitEmptyPasswords no | ☐ | Default |
| 5.1.3 | MaxAuthTries 4 | ☐ | |
| 5.1.4 | X11Forwarding no | ☐ | |

### 5.2 User Accounts

| ID | Control | Status | Command |
|----|---------|--------|---------|
| 5.2.1 | Password complexity | ☐ | `/etc/security/pwquality.conf` |
| 5.2.2 | Account lockout | ☐ | pam_faillock |
| 5.2.3 | Root only UID 0 | ☐ | `awk -F: '$3==0' /etc/passwd` |

---

## 6. System Maintenance

| ID | Control | Status | Expected |
|----|---------|--------|----------|
| 6.1.1 | /etc/passwd perms | ☐ | 644 |
| 6.1.2 | /etc/shadow perms | ☐ | 640 |
| 6.1.3 | No world-writable files | ☐ | `find / -perm -002` |
| 6.1.4 | No unowned files | ☐ | `find / -nouser` |
| 6.1.5 | SUID files audited | ☐ | `find / -perm -4000` |

---

## Quick Compliance Check

```bash
#!/usr/bin/env bash
# Check critical CIS controls
for mod in cramfs freevxfs jffs2 hfs hfsplus; do
    lsmod | grep -q "^$mod" && echo "✗ $mod loaded" || echo "✓ $mod disabled"
done

for c in "kernel.randomize_va_space:2" "net.ipv4.tcp_syncookies:1"; do
    k="${c%:*}"; v="${c#*:}"
    [[ "$(sysctl -n $k)" == "$v" ]] && echo "✓ $k" || echo "✗ $k"
done
```

---

**Audit Date:** ________ | **Auditor:** ________

# SANCHALA OS - Security Audit Checklist

## Enterprise-Grade Security Verification Checklist

**Audit Version:** 1.0  
**Target:** SANCHALA OS 1.x  
**Classification:** Internal Use  

---

## Audit Information

| Field | Value |
|-------|-------|
| Auditor Name | |
| Audit Date | |
| System Version | |
| Audit Type | ☐ Initial ☐ Periodic ☐ Post-Incident |

---

## Layer 0: Hardware Security

### TPM 2.0 Integration
| ID | Check Item | Status | Evidence |
|----|------------|--------|----------|
| HW-001 | TPM 2.0 detected and functional | ☐ Pass ☐ Fail ☐ N/A | `tpm2_getcap properties-fixed` |
| HW-002 | TPM ownership established | ☐ Pass ☐ Fail ☐ N/A | |
| HW-003 | PCR banks configured (SHA-256 min) | ☐ Pass ☐ Fail ☐ N/A | |
| HW-004 | TPM-sealed keys functional | ☐ Pass ☐ Fail ☐ N/A | |

### IOMMU/DMA Protection
| ID | Check Item | Status | Evidence |
|----|------------|--------|----------|
| HW-005 | IOMMU enabled in BIOS | ☐ Pass ☐ Fail ☐ N/A | VT-d/AMD-Vi |
| HW-006 | IOMMU active in kernel | ☐ Pass ☐ Fail ☐ N/A | `dmesg \| grep -i iommu` |
| HW-007 | DMA protection enforced | ☐ Pass ☐ Fail ☐ N/A | Thunderbolt restrictions |

### Hardware Authentication
| ID | Check Item | Status | Evidence |
|----|------------|--------|----------|
| HW-008 | FIDO2/WebAuthn supported | ☐ Pass ☐ Fail ☐ N/A | |
| HW-009 | YubiKey integration functional | ☐ Pass ☐ Fail ☐ N/A | |
| HW-010 | Smart card support (PIV) | ☐ Pass ☐ Fail ☐ N/A | |

---

## Layer 1: Secure Boot

| ID | Check Item | Status | Evidence |
|----|------------|--------|----------|
| SB-001 | Secure Boot enabled | ☐ Pass ☐ Fail ☐ N/A | `mokutil --sb-state` |
| SB-002 | Bootloader signed | ☐ Pass ☐ Fail ☐ N/A | GRUB/systemd-boot |
| SB-003 | Kernel images signed | ☐ Pass ☐ Fail ☐ N/A | |
| SB-004 | Initramfs signed/verified | ☐ Pass ☐ Fail ☐ N/A | |
| SB-005 | Custom Secure Boot keys | ☐ Pass ☐ Fail ☐ N/A | Optional |
| SB-006 | TPM PCR measurements recorded | ☐ Pass ☐ Fail ☐ N/A | |
| SB-007 | Boot log available | ☐ Pass ☐ Fail ☐ N/A | |
| SB-008 | UKI (Unified Kernel Image) | ☐ Pass ☐ Fail ☐ N/A | Optional |

---

## Layer 2: Data Protection

### Full Disk Encryption
| ID | Check Item | Status | Evidence |
|----|------------|--------|----------|
| DP-001 | LUKS2 encryption enabled | ☐ Pass ☐ Fail ☐ N/A | `cryptsetup luksDump` |
| DP-002 | AES-256-XTS cipher | ☐ Pass ☐ Fail ☐ N/A | |
| DP-003 | Argon2id key derivation | ☐ Pass ☐ Fail ☐ N/A | Memory-hard KDF |
| DP-004 | TPM-sealed key slot | ☐ Pass ☐ Fail ☐ N/A | |
| DP-005 | Recovery key generated | ☐ Pass ☐ Fail ☐ N/A | |
| DP-006 | Passphrase complexity | ☐ Pass ☐ Fail ☐ N/A | pwquality |
| DP-007 | fscrypt available | ☐ Pass ☐ Fail ☐ N/A | |
| DP-008 | Swap encrypted | ☐ Pass ☐ Fail ☐ N/A | |
| DP-009 | Core dumps disabled | ☐ Pass ☐ Fail ☐ N/A | fs.suid_dumpable=0 |

---

## Layer 3: System Integrity

| ID | Check Item | Status | Evidence |
|----|------------|--------|----------|
| SI-001 | IMA enabled | ☐ Pass ☐ Fail ☐ N/A | Kernel config |
| SI-002 | IMA policy loaded | ☐ Pass ☐ Fail ☐ N/A | `/etc/ima/ima-policy` |
| SI-003 | EVM enabled | ☐ Pass ☐ Fail ☐ N/A | |
| SI-004 | auditd service running | ☐ Pass ☐ Fail ☐ N/A | `systemctl status auditd` |
| SI-005 | Sanchala audit rules loaded | ☐ Pass ☐ Fail ☐ N/A | `auditctl -l` |
| SI-006 | Audit log rotation | ☐ Pass ☐ Fail ☐ N/A | |
| SI-007 | Audit logs protected (600) | ☐ Pass ☐ Fail ☐ N/A | |

---

## Layer 4: Kernel Fortress

### Kernel Self-Protection
| ID | Check Item | Status | Evidence |
|----|------------|--------|----------|
| KH-001 | kernel.kptr_restrict = 2 | ☐ Pass ☐ Fail ☐ N/A | Hide kernel pointers |
| KH-002 | kernel.dmesg_restrict = 1 | ☐ Pass ☐ Fail ☐ N/A | Restrict dmesg |
| KH-003 | kernel.perf_event_paranoid = 3 | ☐ Pass ☐ Fail ☐ N/A | Restrict perf |
| KH-004 | kernel.kexec_load_disabled = 1 | ☐ Pass ☐ Fail ☐ N/A | Disable kexec |
| KH-005 | kernel.yama.ptrace_scope = 2 | ☐ Pass ☐ Fail ☐ N/A | Restrict ptrace |
| KH-006 | kernel.sysrq = 0 | ☐ Pass ☐ Fail ☐ N/A | Disable SysRq |
| KH-007 | kernel.unprivileged_bpf_disabled = 1 | ☐ Pass ☐ Fail ☐ N/A | |
| KH-008 | net.core.bpf_jit_harden = 2 | ☐ Pass ☐ Fail ☐ N/A | |
| KH-009 | kernel.randomize_va_space = 2 | ☐ Pass ☐ Fail ☐ N/A | Full ASLR |
| KH-010 | kernel.io_uring_disabled = 2 | ☐ Pass ☐ Fail ☐ N/A | |

### Memory Protection
| ID | Check Item | Status | Evidence |
|----|------------|--------|----------|
| KH-011 | fs.protected_symlinks = 1 | ☐ Pass ☐ Fail ☐ N/A | |
| KH-012 | fs.protected_hardlinks = 1 | ☐ Pass ☐ Fail ☐ N/A | |
| KH-013 | fs.protected_fifos = 2 | ☐ Pass ☐ Fail ☐ N/A | |
| KH-014 | vm.unprivileged_userfaultfd = 0 | ☐ Pass ☐ Fail ☐ N/A | |
| KH-015 | vm.mmap_min_addr = 65536 | ☐ Pass ☐ Fail ☐ N/A | |

### Network Hardening
| ID | Check Item | Status | Evidence |
|----|------------|--------|----------|
| KH-016 | net.ipv4.tcp_syncookies = 1 | ☐ Pass ☐ Fail ☐ N/A | SYN flood protection |
| KH-017 | net.ipv4.conf.all.rp_filter = 1 | ☐ Pass ☐ Fail ☐ N/A | Anti-spoofing |
| KH-018 | net.ipv4.conf.all.accept_redirects = 0 | ☐ Pass ☐ Fail ☐ N/A | |
| KH-019 | net.ipv4.conf.all.send_redirects = 0 | ☐ Pass ☐ Fail ☐ N/A | |
| KH-020 | Module blacklist configured | ☐ Pass ☐ Fail ☐ N/A | |

---

## Layer 5: Access Control

### AppArmor
| ID | Check Item | Status | Evidence |
|----|------------|--------|----------|
| AC-001 | AppArmor enabled | ☐ Pass ☐ Fail ☐ N/A | `aa-status` |
| AC-002 | Default profile loaded | ☐ Pass ☐ Fail ☐ N/A | sanchala-default |
| AC-003 | Browser profiles enforced | ☐ Pass ☐ Fail ☐ N/A | Firefox, Brave |
| AC-004 | No profiles in complain mode | ☐ Pass ☐ Fail ☐ N/A | Production |

### User Security
| ID | Check Item | Status | Evidence |
|----|------------|--------|----------|
| AC-005 | Root login disabled (SSH) | ☐ Pass ☐ Fail ☐ N/A | |
| AC-006 | Password policy enforced | ☐ Pass ☐ Fail ☐ N/A | pwquality |
| AC-007 | Account lockout configured | ☐ Pass ☐ Fail ☐ N/A | faillock |
| AC-008 | Sudo configured securely | ☐ Pass ☐ Fail ☐ N/A | No NOPASSWD |
| AC-009 | SUID binaries audited | ☐ Pass ☐ Fail ☐ N/A | Minimal |

---

## Layer 6: Supply Chain Security

| ID | Check Item | Status | Evidence |
|----|------------|--------|----------|
| SC-001 | Pacman signature verification | ☐ Pass ☐ Fail ☐ N/A | SigLevel = Required |
| SC-002 | Trusted keyring configured | ☐ Pass ☐ Fail ☐ N/A | |
| SC-003 | Flatpak repo signatures | ☐ Pass ☐ Fail ☐ N/A | |
| SC-004 | Reproducible builds | ☐ Pass ☐ Fail ☐ N/A | |
| SC-005 | SLSA provenance | ☐ Pass ☐ Fail ☐ N/A | Target: Level 3 |
| SC-006 | Secure update transport | ☐ Pass ☐ Fail ☐ N/A | HTTPS only |

---

## Layer 7: Application Security

| ID | Check Item | Status | Evidence |
|----|------------|--------|----------|
| AS-001 | Flatpak runtime updated | ☐ Pass ☐ Fail ☐ N/A | |
| AS-002 | Bubblewrap isolation | ☐ Pass ☐ Fail ☐ N/A | |
| AS-003 | Seccomp filtering active | ☐ Pass ☐ Fail ☐ N/A | |
| AS-004 | Portal-based permissions | ☐ Pass ☐ Fail ☐ N/A | |
| AS-005 | Seccomp base profile | ☐ Pass ☐ Fail ☐ N/A | sanchala-base.json |
| AS-006 | TCC service running | ☐ Pass ☐ Fail ☐ N/A | |

---

## Layer 8: Zero Trust Network

| ID | Check Item | Status | Evidence |
|----|------------|--------|----------|
| NW-001 | nftables service active | ☐ Pass ☐ Fail ☐ N/A | |
| NW-002 | Default DROP incoming | ☐ Pass ☐ Fail ☐ N/A | |
| NW-003 | DoH enabled by default | ☐ Pass ☐ Fail ☐ N/A | |
| NW-004 | DNSSEC validation | ☐ Pass ☐ Fail ☐ N/A | |
| NW-005 | MAC randomization | ☐ Pass ☐ Fail ☐ N/A | |
| NW-006 | IPv6 privacy extensions | ☐ Pass ☐ Fail ☐ N/A | use_tempaddr=2 |
| NW-007 | WireGuard available | ☐ Pass ☐ Fail ☐ N/A | |

---

## Privacy & Telemetry

| ID | Check Item | Status | Evidence |
|----|------------|--------|----------|
| PV-001 | No telemetry by default | ☐ Pass ☐ Fail ☐ N/A | |
| PV-002 | No analytics endpoints | ☐ Pass ☐ Fail ☐ N/A | |
| PV-003 | Opt-in data collection only | ☐ Pass ☐ Fail ☐ N/A | |

---

## Audit Summary

| Category | Total | Pass | Fail | N/A |
|----------|-------|------|------|-----|
| Hardware Security | 10 | | | |
| Secure Boot | 8 | | | |
| Data Protection | 9 | | | |
| System Integrity | 7 | | | |
| Kernel Fortress | 20 | | | |
| Access Control | 9 | | | |
| Supply Chain | 6 | | | |
| Application Security | 6 | | | |
| Network Security | 7 | | | |
| Privacy | 3 | | | |
| **TOTAL** | **85** | | | |

### Sign-Off

| Role | Name | Signature | Date |
|------|------|-----------|------|
| Auditor | | | |
| Security Lead | | | |

---
**Document Version:** 1.0 | **Classification:** Internal Use

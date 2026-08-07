# ============================================================================
# SANCHALA OS - Threat Model Document
# ============================================================================
# Version: 2.0 | Classification: Public
# ============================================================================

## 1. Executive Summary

This document defines the threat model for Sanchala OS, identifying adversaries,
attack vectors, and defensive measures to achieve security exceeding macOS.

## 2. Security Objectives

### 2.1 Primary Goals
- **Confidentiality**: Protect user data from unauthorized access
- **Integrity**: Ensure system and data cannot be tampered with
- **Availability**: Maintain system usability under attack
- **Privacy**: Minimize data collection and tracking

### 2.2 Security Posture
- Defense in depth (8 security layers)
- Zero trust architecture
- Least privilege principle
- Fail-secure defaults

## 3. Adversary Profiles

### 3.1 Opportunistic Attacker
| Attribute | Description |
|-----------|-------------|
| Motivation | Financial gain, data theft |
| Capability | Low to medium |
| Resources | Limited, automated tools |
| Examples | Malware, phishing, drive-by downloads |

**Mitigations:** Application sandboxing, seccomp, auto-updates, secure DNS

### 3.2 Targeted Attacker
| Attribute | Description |
|-----------|-------------|
| Motivation | Espionage, targeted theft |
| Capability | High |
| Resources | Significant, custom tools |
| Examples | APT groups, corporate espionage |

**Mitigations:** TPM attestation, kernel lockdown, IMA/EVM, network isolation

### 3.3 Physical Attacker
| Attribute | Description |
|-----------|-------------|
| Motivation | Device theft, data extraction |
| Capability | Variable |
| Resources | Physical access |
| Examples | Theft, evil maid attacks |

**Mitigations:** LUKS2+TPM encryption, Secure Boot, IOMMU, DMA restrictions

### 3.4 Nation-State Actor
| Attribute | Description |
|-----------|-------------|
| Motivation | Intelligence, disruption |
| Capability | Very high |
| Resources | Unlimited, zero-days |

**Mitigations:** Open source transparency, reproducible builds, SLSA, defense in depth

## 4. Attack Surface Analysis

### 4.1 Network Attack Surface
| Vector | Risk | Mitigation |
|--------|------|------------|


## 5. Trust Boundaries

```
┌─────────────────────────────────────────────────────────┐
│                 UNTRUSTED ZONE                          │
│  Internet, External Networks, Unknown USB Devices       │
└────────────────────────┬────────────────────────────────┘
                         │
               ┌─────────▼─────────┐
               │    FIREWALL       │ ← nftables, DROP default
               └─────────┬─────────┘
                         │
┌────────────────────────▼────────────────────────────────┐
│                 SEMI-TRUSTED ZONE                       │
│  User Applications (Sandboxed via Flatpak+AppArmor)     │
└────────────────────────┬────────────────────────────────┘
                         │
               ┌─────────▼─────────┐
               │  PORTAL/DBUS      │ ← Permission mediation
               └─────────┬─────────┘
                         │
┌────────────────────────▼────────────────────────────────┐
│                 TRUSTED ZONE                            │
│  Kernel (linux-hardened) + AppArmor LSM + seccomp       │
└────────────────────────┬────────────────────────────────┘
                         │
┌────────────────────────▼────────────────────────────────┐
│              HARDWARE TRUST ZONE                        │
│  TPM 2.0 | IOMMU/VT-d | CPU (Secure Boot)               │
└─────────────────────────────────────────────────────────┘
```

## 6. Risk Assessment Matrix

| Threat | Likelihood | Impact | Risk | Status |
|--------|------------|--------|------|--------|
| Malware infection | Medium | High | HIGH | Mitigated |
| Phishing | High | Medium | HIGH | Mitigated |
| Kernel exploit | Low | Critical | MEDIUM | Mitigated |
| Physical theft | Medium | High | HIGH | Mitigated |
| Supply chain | Low | Critical | MEDIUM | Mitigated |
| Zero-day exploit | Low | Critical | MEDIUM | Monitored |

## 7. STRIDE Analysis Summary

- **Spoofing**: MFA, strong auth, TLS verification
- **Tampering**: IMA/EVM, AppArmor, audit logs
- **Repudiation**: Comprehensive logging, remote syslog
- **Info Disclosure**: Encryption, access control, kernel hardening
- **Denial of Service**: cgroups, rate limiting, SYN cookies
- **Elevation of Privilege**: Hardened kernel, minimal SUID, capabilities

## 8. Residual Risks

| Risk | Acceptance Rationale |
|------|---------------------|
| Zero-day exploits | Defense in depth limits impact |
| Hardware backdoors | Cannot fully address in software |
| User error | User autonomy preserved |

## 9. Security Monitoring

**Audit Points:** Auth events, privilege escalation, file integrity, network anomalies

**Incident Response:**
1. Detect via audit logs
2. Contain via network isolation
3. Preserve with Btrfs snapshot
4. Analyze forensic data
5. Recover from clean snapshot
6. Report via security@sanchala.id

---
**Review:** Annually | **Owner:** Security Team | **Classification:** Public

| Open ports | High | Default deny firewall (nftables) |
| DNS poisoning | Medium | DoH/DoT with DNSSEC |
| MITM | High | TLS everywhere |
| WiFi attacks | Medium | WPA3, MAC randomization |

### 4.2 Local Attack Surface
| Vector | Risk | Mitigation |
|--------|------|------------|
| Malicious apps | High | Sandboxing, seccomp, AppArmor |
| Privilege escalation | High | Kernel hardening, restricted sudo |
| USB attacks | Medium | USBGuard, module restrictions |
| Kernel exploits | High | linux-hardened, sysctl hardening |

### 4.3 Supply Chain Attack Surface
| Vector | Risk | Mitigation |
|--------|------|------------|
| Compromised packages | High | Signed packages, SLSA verification |
| Build tampering | Medium | Reproducible builds |
| Update hijacking | High | Signed updates, secure transport |

### 4.4 Physical Attack Surface
| Vector | Risk | Mitigation |
|--------|------|------------|
| Disk extraction | High | LUKS2 + TPM-sealed keys |
| Cold boot | Medium | Memory encryption |
| DMA attacks | High | IOMMU, Thunderbolt restrictions |
| Evil maid | Medium | Measured boot |

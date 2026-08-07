# ============================================================================
# SANCHALA OS - Security Whitepaper
# ============================================================================
# Version: 2.0 | Classification: Public
# ============================================================================

## Abstract

Sanchala OS is a security-focused Linux distribution based on Arch Linux,
designed to provide security that exceeds Apple macOS through transparent,
auditable, and user-controlled security mechanisms.

## 1. Design Philosophy

### 1.1 Principles
- **Defense in Depth**: 8 independent security layers
- **Zero Trust**: Verify everything, trust nothing by default
- **Least Privilege**: Minimal permissions for all processes
- **Transparency**: Open source, auditable security
- **User Control**: Security that serves users, not vendors

### 1.2 Comparison with macOS
| Aspect | macOS | Sanchala OS |
|--------|-------|-------------|
| Source | Closed | Open |
| Audit | Not possible | Full audit |
| Telemetry | Default ON | Default OFF |
| Custom keys | No | Yes |
| Reproducible | No | Yes |

## 2. Security Architecture

### Layer 0: Hardware Security
- TPM 2.0 for key storage and attestation
- IOMMU/VT-d for DMA protection
- FIDO2/WebAuthn hardware key support

### Layer 1: Secure Boot
- UEFI Secure Boot with signed components
- Measured boot with TPM PCR measurements
- Unified Kernel Images (UKI) support

### Layer 2: Data Protection
- LUKS2 with AES-256-XTS encryption
- Argon2id key derivation
- TPM-sealed keys with PCR binding
- Per-directory fscrypt encryption

### Layer 3: System Integrity
- IMA (Integrity Measurement Architecture)
- EVM (Extended Verification Module)
- Comprehensive audit logging

### Layer 4: Kernel Fortress
- linux-hardened kernel
- Extensive sysctl hardening
- Module signature enforcement
- Kernel lockdown mode

### Layer 5: Process Isolation
- AppArmor mandatory access control
- Seccomp system call filtering
- Linux namespaces (user, PID, net, mount)
- Capability restrictions

### Layer 6: Supply Chain
- Signed packages with GPG verification
- SLSA Level 3 build verification target
- Reproducible builds

### Layer 7: Application Security
- Flatpak sandboxing by default
- Portal-based permission system
- 18+ permission categories (vs macOS 12)

### Layer 8: Network Security
- nftables firewall (default DROP)
- DNS-over-HTTPS/TLS with DNSSEC
- WireGuard VPN built-in
- MAC/hostname randomization

## 3. Key Differentiators

### 3.1 vs macOS
- Full source code audit capability
- User-controlled Secure Boot keys
- No mandatory telemetry
- Post-quantum cryptography ready
- Reproducible builds for verification

### 3.2 vs Other Linux
- Pre-configured security (not DIY)
- Hardened by default
- Comprehensive threat model
- macOS-like UX with Linux security

## 4. Verification

Users can verify security claims:
```bash
# Check kernel hardening
sysctl -a | grep -E "kptr_restrict|dmesg_restrict"

# Check AppArmor
aa-status

# Check Secure Boot
mokutil --sb-state

# Check TPM
tpm2_getcap properties-fixed

# Full audit
sanchala-guardian --audit
```

## 5. Conclusion

Sanchala OS achieves security beyond macOS through:
- Transparency (open source)
- Defense in depth (8 layers)
- User control (no vendor lock-in)
- Verifiability (reproducible builds)

---
**Contact:** security@sanchala.id
**License:** Documentation under CC-BY-SA 4.0

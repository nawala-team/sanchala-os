# 🔒 SANCHALA OS - Security Documentation

## Overview

Sanchala OS dirancang dengan keamanan sebagai prioritas utama, mengimplementasikan **8-layer security architecture** yang melampaui standar industri termasuk macOS.

---

## 🆚 Security Comparison: Sanchala vs macOS

| Feature | macOS | Sanchala OS | Winner |
|---------|-------|-------------|--------|
| **Open Source** | ❌ Closed | ✅ Full | 🏆 Sanchala |
| **Kernel Hardening** | Good | Excellent (linux-hardened) | 🏆 Sanchala |
| **App Sandboxing** | App Sandbox | Flatpak + Bubblewrap + AppArmor | 🏆 Sanchala |
| **Permission System** | TCC (12 categories) | Sanchala TCC (18+ categories) | 🏆 Sanchala |
| **Telemetry** | ON by default | OFF by default | 🏆 Sanchala |
| **Post-Quantum Crypto** | ❌ | ✅ Ready | 🏆 Sanchala |
| **Full Audit Trail** | Limited | ✅ Complete | 🏆 Sanchala |
| **Reproducible Builds** | ❌ | ✅ Verified | 🏆 Sanchala |
| **Supply Chain Security** | Notarization | SLSA + Signatures | 🏆 Sanchala |
| **Disk Encryption** | FileVault 2 | LUKS2 + TPM | Tie |
| **Secure Boot** | T2/Apple Silicon | UEFI + TPM | Tie |

---

## 🛡️ Layer-by-Layer Security

### Layer 0: Hardware Security

```yaml
Features:
  TPM 2.0:
    - Secure key storage
    - Measured boot attestation
    - Disk encryption key sealing
    - Platform integrity verification
  
  IOMMU/VT-d:
    - DMA attack protection
    - Device isolation
    - PCI passthrough security
  
  Hardware Keys:
    - FIDO2/WebAuthn support
    - YubiKey integration
    - PIV smart cards
```

### Layer 1: Secure Boot

```yaml
UEFI Secure Boot:
  - Signed bootloader (GRUB/systemd-boot)
  - Signed kernel images
  - Signed initramfs
  - Custom Secure Boot keys (optional)

Measured Boot:
  - TPM PCR measurements
  - Boot log attestation
  - Remote attestation ready

Unified Kernel Images (UKI):
  - Single signed EFI binary
  - Kernel + initramfs + cmdline
  - Tamper-evident boot
```

### Layer 2: Data Protection

```yaml
Full Disk Encryption:
  Algorithm: AES-256-XTS
  Implementation: LUKS2
  Key Derivation: Argon2id
  
  TPM Integration:
    - Key sealed to TPM PCRs
    - Auto-unlock on verified boot
    - Fallback to passphrase
  
  Recovery:
    - Recovery key generation
    - Secure key escrow (optional)

Per-File Encryption:
  - fscrypt for sensitive directories
  - Separate keys per directory
  - User-controlled encryption
```

### Layer 3: System Integrity

```yaml
Immutable System (Optional):
  - Read-only /usr
  - Overlay for modifications
  - Atomic updates

Integrity Measurement:
  IMA (Integrity Measurement Architecture):
    - File hash logging
    - Policy enforcement
    - Remote attestation
  
  EVM (Extended Verification Module):
    - Extended attribute protection
    - Digital signatures
    - Tamper detection

Audit System:
  - Comprehensive audit logging
  - Security event tracking
  - SIEM integration ready
```

### Layer 4: Kernel Fortress

```yaml
Hardened Kernel:
  Package: linux-hardened
  Features:
    - Kernel lockdown mode
    - Restricted /dev/mem
    - Disabled kexec
    - Module signature enforcement

Sysctl Hardening:
  Kernel:
    - kernel.kptr_restrict=2
    - kernel.dmesg_restrict=1
    - kernel.perf_event_paranoid=3
    - kernel.yama.ptrace_scope=2
    - kernel.unprivileged_bpf_disabled=1
  
  Network:
    - net.ipv4.tcp_syncookies=1
    - net.ipv4.conf.all.rp_filter=1
    - net.ipv4.conf.all.accept_redirects=0
    - net.ipv6.conf.all.accept_ra=0

Module Restrictions:
  Blacklisted:
    - Uncommon filesystems (cramfs, freevxfs, etc.)
    - Uncommon protocols (dccp, sctp, rds)
    - Firewire modules (DMA attack prevention)
```

### Layer 5: Memory Protection

```yaml
ASLR (Address Space Layout Randomization):
  - Full randomization
  - kernel.randomize_va_space=2

Stack Protection:
  - Stack canaries (SSP)
  - Stack clash protection
  - Shadow stacks (CET)

Control-Flow Integrity:
  - CFI enforcement
  - Forward-edge protection
  - Backward-edge protection

Memory Allocator:
  - Hardened malloc
  - Guard pages
  - Memory tagging (MTE on ARM)
```

### Layer 6: Code Integrity

```yaml
Package Verification:
  Pacman:
    - GPG signature verification
    - SigLevel = Required DatabaseOptional
    - Trusted keyring
  
  Flatpak:
    - Repository signatures
    - OSTree verification
    - Runtime verification

Reproducible Builds:
  - Build verification
  - Binary transparency
  - SLSA Level 3 target

Code Signing:
  - Kernel modules signed
  - EFI binaries signed
  - Application signatures (optional)
```

### Layer 7: Application Security

```yaml
Sandboxing:
  Flatpak (Primary):
    - Bubblewrap isolation
    - Seccomp filtering
    - Portal-based permissions
    - Sanchala strict defaults
  
  Bubblewrap (Non-Flatpak):
    - Namespace isolation
    - Filesystem restrictions
    - Network filtering
  
  AppArmor:
    - Mandatory Access Control
    - Per-application profiles
    - Deny-by-default

Permission System (Sanchala TCC):
  Categories:
    - Camera
    - Microphone
    - Location
    - Contacts
    - Calendar
    - Photos
    - Documents
    - Downloads
    - Desktop
    - Removable Media
    - Network
    - Bluetooth
    - USB Devices
    - Screen Recording
    - Input Monitoring
    - Accessibility
    - System Events
    - Background Execution
```

### Layer 8: Zero Trust Network

```yaml
Firewall:
  Backend: nftables
  Management: firewalld
  Default: DROP incoming
  Per-App Rules: Yes

DNS Security:
  - DNS-over-HTTPS (DoH) default
  - DNS-over-TLS (DoT) option
  - DNSSEC validation
  - Custom DNS easy setup

VPN:
  - WireGuard built-in
  - OpenVPN support
  - Auto-connect options
  - Kill switch

Network Privacy:
  - MAC address randomization
  - Hostname randomization
  - IPv6 privacy extensions
```

---

## 🔧 Security Configuration Files

### Location Map

```
/etc/
├── apparmor.d/              # AppArmor profiles
│   ├── sanchala-default     # Default profile
│   ├── usr.bin.brave        # Brave browser profile
│   └── ...                  # Other profiles
├── sysctl.d/
│   └── 99-sanchala-hardening.conf  # Kernel hardening
├── modprobe.d/
│   └── module-blacklist.conf       # Blocked modules
├── nftables.conf            # Firewall rules
├── security/
│   ├── limits.conf          # Resource limits
│   └── pwquality.conf       # Password policy
└── sanchala/
    └── tcc.conf             # Permission settings
```

---

## 📊 Security Audit

### Self-Assessment Commands

```bash
# Check kernel hardening
sudo sysctl -a | grep -E "kptr_restrict|dmesg_restrict|ptrace_scope"

# Check AppArmor status
sudo aa-status

# Check firewall status
sudo firewall-cmd --state
sudo nft list ruleset

# Check disk encryption
lsblk -o NAME,FSTYPE,MOUNTPOINT | grep crypt

# Check Secure Boot
mokutil --sb-state

# Check TPM
tpm2_getcap properties-fixed

# Full security audit
sanchala-guardian --audit
```

---

## 🚨 Security Incident Response

1. **Isolate** - Disconnect from network if compromised
2. **Preserve** - Take Btrfs snapshot for forensics
3. **Analyze** - Check audit logs in /var/log/audit/
4. **Recover** - Rollback to clean snapshot
5. **Report** - File issue at security@sanchala.id

---

**Document Version:** 1.0  
**Last Updated:** August 2026  
**Security Contact:** security@sanchala.id

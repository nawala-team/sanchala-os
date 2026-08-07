# ============================================================================
# SANCHALA OS - TPM 2.0 Integration Specification
# ============================================================================
# Version: 2.0
# Security Level: Hardware Root of Trust
# ============================================================================

## Overview

Sanchala OS leverages TPM 2.0 (Trusted Platform Module) to provide hardware-backed
security that exceeds macOS T2/Apple Silicon Secure Enclave capabilities in
transparency and user control.

## TPM Features Utilized

### 1. Measured Boot (PCR Measurements)

PCR (Platform Configuration Register) assignments for Sanchala OS:

| PCR | Description | Measured Components |
|-----|-------------|---------------------|
| 0 | BIOS/UEFI firmware | Firmware code and data |
| 1 | BIOS configuration | UEFI settings |
| 2 | Option ROMs | Additional firmware |
| 3 | Option ROM config | GPU BIOS, NIC firmware |
| 4 | MBR/GPT | Boot partition table |
| 5 | MBR/GPT config | Partition configuration |
| 7 | Secure Boot state | Secure Boot keys/policy |
| 8 | Kernel command line | GRUB/systemd-boot params |
| 9 | Kernel + initramfs | linux-hardened + initrd |
| 11 | Unified Kernel Image | UKI hash (if used) |
| 12 | Kernel modules | Loaded module hashes |
| 14 | Sanchala integrity | IMA aggregate |

### 2. Disk Encryption (LUKS2 + TPM)

```yaml
Configuration:
  Encryption: AES-256-XTS
  Key Derivation: Argon2id
  TPM Sealing:
    - Key sealed to PCRs 0,1,2,7,8,9
    - Auto-unlock on verified boot
    - Fallback to passphrase
    
Setup Commands:
  # Initialize TPM for LUKS
  systemd-cryptenroll /dev/nvme0n1p3 --tpm2-device=auto --tpm2-pcrs=0+1+2+7+8+9
  
  # Verify enrollment
  systemd-cryptenroll /dev/nvme0n1p3 --tpm2-device=auto

Recovery:
  # Recovery key (store securely offline)
  systemd-cryptenroll /dev/nvme0n1p3 --recovery-key
  
  # Remove TPM binding (if compromised)
  systemd-cryptenroll /dev/nvme0n1p3 --wipe-slot=tpm2
```

### 3. Secure Boot Integration

```yaml
Chain of Trust:
  1. UEFI Secure Boot verifies shim/GRUB
  2. GRUB verifies kernel signature
  3. Kernel verifies module signatures
  4. TPM measures each stage into PCRs
  5. LUKS key released only if PCRs match

Key Management:
  Platform Key (PK): Microsoft or custom
  Key Exchange Key (KEK): Microsoft + Sanchala
  Database (db): Allowed signatures
  Forbidden (dbx): Revoked signatures
  
Custom Secure Boot:
  # Generate custom keys
  /usr/share/sanchala/secure-boot/generate-keys.sh
  
  # Enroll keys in UEFI
  /usr/share/sanchala/secure-boot/enroll-keys.sh
```

### 4. Remote Attestation

```yaml
Purpose:
  - Prove system integrity to remote services
  - Zero-trust network access
  - Compliance verification

Implementation:
  Attestation Server: Keylime (optional)
  Protocol: TPM 2.0 Quote
  
Quote Generation:
  # Generate attestation quote
  tpm2_quote -c ak.ctx -l sha256:0,1,2,7,8,9 -q <nonce> -m quote.msg -s quote.sig
  
  # Verify quote
  tpm2_checkquote -u ak.pub -m quote.msg -s quote.sig -q <nonce>
```

### 5. Secure Key Storage

```yaml
TPM Key Hierarchy:
  Storage Root Key (SRK):
    - Never leaves TPM
    - Protects child keys
    
  Attestation Identity Key (AIK):
    - Used for quotes/attestation
    - Privacy-preserving
    
  User Keys:
    - SSH keys (TPM-backed)
    - GPG keys (TPM-backed)
    - FIDO2/WebAuthn

SSH with TPM:
  # Create TPM-backed SSH key
  tpm2_ptool addkey --algorithm=ecc256 --label=ssh-key --userpin=<pin>
  ssh-keygen -D /usr/lib/pkcs11/libtpm2_pkcs11.so
  
  # Configure SSH to use TPM
  # ~/.ssh/config
  PKCS11Provider /usr/lib/pkcs11/libtpm2_pkcs11.so

GPG with TPM:
  # Create GPG key with TPM backend
  gpg --card-edit  # With TPM as smartcard
```

## Required Packages

```bash
# Core TPM stack
tpm2-tss              # TPM2 Software Stack
tpm2-tools            # TPM2 CLI tools
tpm2-abrmd            # Access Broker & Resource Manager
tpm2-pkcs11           # PKCS#11 interface

# Integration
systemd               # cryptenroll, PCR policy
clevis                # Alternative auto-unlock
clevis-luks           # LUKS integration
clevis-tpm2           # TPM2 pin

# Optional attestation
keylime-agent         # Remote attestation agent
keylime-verifier      # Attestation verifier
```

## Systemd Services

```ini
# /etc/systemd/system/tpm2-abrmd.service.d/override.conf
[Service]
ExecStart=
ExecStart=/usr/bin/tpm2-abrmd --tcti=device:/dev/tpmrm0

# Enable services
systemctl enable tpm2-abrmd.service
```

## Security Considerations

### TPM Vulnerability Mitigations

1. **TPM Reset Attacks**: PCR policy includes PCR 0 (firmware)
2. **Cold Boot Attacks**: Memory encryption (AMD SME/SEV if available)
3. **Evil Maid**: Measured boot detects tampering
4. **TPM Interposer**: Physical security required

### Fallback Procedures

```yaml
If TPM fails:
  1. Boot prompts for LUKS passphrase
  2. Log TPM failure to audit
  3. Alert user to verify hardware
  
If PCR mismatch:
  1. Deny auto-unlock (expected after updates)
  2. Prompt for passphrase
  3. Re-enroll after verification:
     systemd-cryptenroll /dev/nvme0n1p3 --wipe-slot=tpm2
     systemd-cryptenroll /dev/nvme0n1p3 --tpm2-device=auto --tpm2-pcrs=0+1+2+7+8+9
```

## Comparison with macOS

| Feature | macOS T2/Apple Silicon | Sanchala OS + TPM2 |
|---------|------------------------|-------------------|
| Secure Boot | Yes (closed) | Yes (auditable) |
| Disk Encryption | FileVault | LUKS2 + TPM |
| Key Storage | Secure Enclave | TPM + PKCS#11 |
| Remote Attestation | No | Yes (Keylime) |
| User Control | Limited | Full |
| Open Source | No | Yes |
| Custom Keys | No | Yes |
| PCR Audit | No | Yes |

## Installation Script

See: /usr/share/sanchala/scripts/setup-tpm.sh

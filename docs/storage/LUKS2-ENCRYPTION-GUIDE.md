# 🔐 SANCHALA OS - LUKS2 Encryption Setup Guide

## Overview

Sanchala OS uses LUKS2 (Linux Unified Key Setup version 2) for full disk encryption, providing enterprise-grade security with modern cryptographic standards.

---

## 🛡️ Encryption Specifications

| Component | Specification |
|-----------|---------------|
| **LUKS Version** | LUKS2 |
| **Cipher** | AES-256-XTS |
| **Key Derivation** | Argon2id |
| **Hash** | SHA-256 |
| **Key Size** | 512 bits (256-bit AES + 256-bit XTS) |
| **Sector Size** | 4096 bytes (for modern drives) |

---

## 🏗️ Partition Layout

```
┌─────────────────────────────────────────────────────────────────┐
│ GPT Partition Table                                              │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌──────────────┐  ┌──────────────────────────────────────────┐ │
│  │     EFI      │  │              LUKS2 Encrypted             │ │
│  │   Partition  │  │                                          │ │
│  │              │  │  ┌────────────────────────────────────┐  │ │
│  │  /boot/efi   │  │  │         Btrfs Filesystem          │  │ │
│  │              │  │  │                                    │  │ │
│  │   512 MiB    │  │  │   @, @home, @log, @cache, etc.    │  │ │
│  │    FAT32     │  │  │                                    │  │ │
│  │              │  │  └────────────────────────────────────┘  │ │
│  └──────────────┘  └──────────────────────────────────────────┘ │
│      nvme0n1p1                    nvme0n1p2                     │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🔧 Manual Setup Commands

### 1. Create LUKS2 Container

```bash
# Wipe existing signatures
wipefs -a /dev/nvme0n1p2

# Create LUKS2 container with Argon2id
cryptsetup luksFormat --type luks2 \
    --cipher aes-xts-plain64 \
    --key-size 512 \
    --hash sha256 \
    --pbkdf argon2id \
    --pbkdf-memory 1048576 \
    --pbkdf-time 5000 \
    --pbkdf-parallel 4 \
    --sector-size 4096 \
    --label SANCHALA_CRYPT \
    /dev/nvme0n1p2
```

### 2. Open Encrypted Container

```bash
cryptsetup open /dev/nvme0n1p2 cryptroot
```

### 3. Create Btrfs Filesystem

```bash
mkfs.btrfs -L SANCHALA_ROOT /dev/mapper/cryptroot
```

---

## 🔑 Key Management

### Add Recovery Key
```bash
# Generate recovery key
cryptsetup luksAddKey /dev/nvme0n1p2 --key-slot 1

# Or use a keyfile
dd if=/dev/urandom of=/root/recovery.key bs=4096 count=1
cryptsetup luksAddKey /dev/nvme0n1p2 /root/recovery.key --key-slot 1
```

### Key Slot Layout
| Slot | Purpose | Notes |
|------|---------|-------|
| 0 | User passphrase | Primary unlock method |
| 1 | Recovery key | Secure backup location |
| 2 | TPM key (optional) | Auto-unlock on verified boot |
| 3-7 | Reserved | Future use |

---

## 🔒 TPM2 Integration (Optional)

### Enroll TPM Key
```bash
# Install systemd-cryptenroll
sudo systemd-cryptenroll --tpm2-device=auto \
    --tpm2-pcrs=0+7 \
    /dev/nvme0n1p2
```

### PCR Bindings
| PCR | Measures | Purpose |
|-----|----------|---------|
| 0 | UEFI firmware | Detect firmware tampering |
| 7 | Secure Boot state | Detect Secure Boot changes |
| 11 | Unified Kernel Image | Detect kernel/initramfs tampering |

### Auto-unlock with TPM
```bash
# /etc/crypttab.initramfs
cryptroot UUID=<uuid> none tpm2-device=auto,discard
```

---

## 📋 Installer Configuration

The Sanchala installer automatically configures LUKS2 with these settings in `/installer/modules/partition.conf`:

```yaml
preCheckEncryptionAvailability: true
LUKSGenerationPreference: luks2
allowEncryptionAlgorithmChoice: true
```

---

## 🛠️ Maintenance Commands

```bash
# Check LUKS header info
sudo cryptsetup luksDump /dev/nvme0n1p2

# Backup LUKS header (CRITICAL!)
sudo cryptsetup luksHeaderBackup /dev/nvme0n1p2 \
    --header-backup-file /secure/luks-header.backup

# Restore LUKS header
sudo cryptsetup luksHeaderRestore /dev/nvme0n1p2 \
    --header-backup-file /secure/luks-header.backup

# Test passphrase without unlocking
sudo cryptsetup open --test-passphrase /dev/nvme0n1p2
```

---

## ⚠️ Security Recommendations

1. **Backup LUKS header** - Store securely offline
2. **Strong passphrase** - 20+ characters recommended
3. **Recovery key** - Store in secure location (not same disk)
4. **TPM binding** - Use for convenience, not sole protection
5. **Secure Boot** - Enable for full chain of trust

---

**Document Version:** 1.0  
**Last Updated:** August 2026  
**Author:** Storage Systems Engineering Team

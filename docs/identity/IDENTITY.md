# SANCHALA OS - Identity & Authentication

## Overview

Sanchala OS provides unified identity and authentication matching Apple Touch ID
convenience while maintaining full transparency and user control.

## Authentication Methods

### 1. Fingerprint (Touch ID-like)

| Feature | macOS Touch ID | Sanchala OS |
|---------|---------------|-------------|
| Login unlock | ✓ | ✓ |
| Sudo auth | ✓ | ✓ |
| Screen unlock | ✓ | ✓ |
| Keychain unlock | ✓ | ✓ |
| Max fingerprints | 5 | 10 |
| Open source | ✗ | ✓ (fprintd) |

**Setup:** `sanchala-fingerprint setup`

**Supported:** Goodix, Synaptics, Elan, Validity scanners

### 2. FIDO2/WebAuthn Keys

Strongest protection against phishing.

| Feature | macOS | Sanchala OS |
|---------|-------|-------------|
| Login auth | Limited | ✓ |
| Sudo auth | ✗ | ✓ |
| Passkeys | Safari only | System-wide |

**Setup:** `sanchala-fido2 setup`

**Supported:** YubiKey, SoloKey, Titan, any FIDO2 key

### 3. Password (Fallback)

NIST 800-63B compliant:
- Minimum 12 characters
- 3+ character classes
- No dictionary words
- 5 failures = 15min lockout

## Authentication Flow

```
Fingerprint ──▶ FIDO2 Key ──▶ Password ──▶ Success ──▶ Keyring Unlock
 (instant)     (touch key)   (fallback)
```

## PAM Configuration

| File | Purpose |
|------|--------|
| system-auth | Core stack |
| sudo | Biometric sudo |
| gdm-password | GNOME login |
| sddm | KDE login |
| polkit-1 | Policy prompts |

## Keyring Integration

- **GNOME Keyring**: Auto-unlocks, stores WiFi/app passwords
- **KWallet**: KDE equivalent
- **Management:** `sanchala-keyring status|lock|unlock`

## Quick Setup

```bash
# Fingerprint
sanchala-fingerprint setup

# Security key
sanchala-fido2 setup

# Verify
sudo -k && sudo echo "Works!"
```

## Security Features

- Account lockout (5 fails = 15min)
- Password history (last 5)
- Auto-lock on suspend/lid close
- TPM integration for secrets

## Troubleshooting

**Fingerprint not working:**
```bash
fprintd-list $USER
systemctl status fprintd
```

**FIDO2 key not detected:**
```bash
fido2-token -L
sudo usermod -aG plugdev $USER
```

**Keyring not unlocking:**
```bash
grep gnome_keyring /etc/pam.d/system-auth
pgrep gnome-keyring
```

## Files

```
/etc/pam.d/           # PAM configs
/etc/security/        # Password policy
/etc/sanchala/identity/  # Identity configs
```

---
Version: 2.0 | Contact: security@sanchala.id

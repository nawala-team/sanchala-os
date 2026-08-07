# 🔐 Cloud Security Guide

## Overview

Sanchala Cloud implements multiple security layers to protect your data during storage and transfer.

---

## 🔑 Credential Security

### OAuth Token Storage

All OAuth tokens are stored in KWallet (KDE's encrypted credential store):

```
KWallet
└── sanchala-cloud/
    ├── gdrive_token
    ├── dropbox_token
    └── onedrive_token
```

### Key Protection

- KWallet uses GPG encryption
- Tokens are never written to plain files
- Auto-lock on screen lock

---

## 🔒 Client-Side Encryption

### How It Works

```
Local File → Encrypt (AES-256) → Upload → Cloud Storage
                ↓
            Filename encrypted
            Content encrypted
            Zero-knowledge to provider
```

### Enable Encryption

```bash
# Enable for existing account
sanchala-cloud encrypt Google_Drive

# Or during setup
sanchala-cloud add gdrive --encrypt
```

### Encryption Settings

```ini
# rclone crypt configuration
filename_encryption = standard  # or obfuscate, off
directory_name_encryption = true
```

### Recovery

**Important:** Back up your encryption password!

```bash
# Export key (store securely!)
sanchala-cloud export-key Google_Drive > ~/backup/cloud-key.txt
```

---

## 🛡️ Transfer Security

- All transfers use TLS 1.3
- Certificate pinning for major providers
- No plaintext data transmission

---

## 🔐 Access Control

### Polkit Integration

Mount operations require user authentication:

```xml
<action id="org.sanchala.cloud.mount">
  <defaults>
    <allow_active>yes</allow_active>
  </defaults>
</action>
```

### File Permissions

```
~/.config/sanchala-cloud/     700 (user only)
~/.config/sanchala-cloud/rclone.conf   600
~/Cloud/                       755 (standard)
```

---

## ⚠️ Security Best Practices

1. **Enable encryption** for sensitive data
2. **Use strong passwords** for encryption keys
3. **Enable 2FA** on cloud provider accounts
4. **Review app permissions** periodically
5. **Revoke access** when no longer needed

---

## 🔍 Audit Logging

All operations are logged:

```bash
journalctl --user -u sanchala-cloudd
```

Logged events:
- Authentication attempts
- Sync operations
- Errors and failures
- Permission changes

---

**See also:** [Security Whitepaper](/docs/security/SECURITY-WHITEPAPER.md)

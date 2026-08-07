# 🔒 SANCHALA OS - Sensitive Data Protection

## Overview

Sanchala OS automatically detects and protects sensitive data in your clipboard. Passwords, API keys, credit cards, and other secrets are auto-cleared to prevent accidental exposure.

## How It Works

```
┌─────────────┐     ┌──────────────┐     ┌─────────────┐
│   Copy      │────▶│   Security   │────▶│  Clipboard  │
│   Action    │     │   Scanner    │     │   History   │
└─────────────┘     └──────┬───────┘     └─────────────┘
                          │
                   Sensitive? ─────Yes────▶ ⏱️ Auto-Clear
                          │                   (30 sec)
                          No
                          │
                          ▼
                   ┌─────────────┐
                   │  Normal     │
                   │  Processing │
                   └─────────────┘
```

## Auto-Clear Timeouts

| Content Type | Timeout | Configurable |
|--------------|---------|--------------|
| Passwords | 30 sec | ✅ |
| API Keys | 30 sec | ✅ |
| Credit Cards | 30 sec | ✅ |
| Private Keys | 30 sec | ✅ |
| OTP/2FA Codes | 60 sec | ✅ |
| Password Manager | Immediate | ✅ |

## Detection Patterns

### Passwords
Detected when copied from:
- Password manager apps (KeePassXC, Bitwarden, 1Password)
- Password fields in browsers
- Text matching password patterns

### Credit Cards
```regex
\b(?:\d{4}[- ]?){3}\d{4}\b
```
Matches: `4111-1111-1111-1111`, `4111 1111 1111 1111`

### API Keys
```regex
\b[A-Za-z0-9_-]{32,}\b
```
Matches long alphanumeric strings typical of API keys.

### Private Keys
```regex
-----BEGIN.*PRIVATE KEY-----
```
Matches PEM-format private keys.

### OTP/2FA Codes
```regex
\b\d{6}\b
```
6-digit codes auto-clear after 60 seconds.

## Password Manager Integration

Apps that trigger immediate clipboard clear:

| App | Package |
|-----|---------|
| KeePassXC | `keepassxc` |
| Bitwarden | `bitwarden` |
| 1Password | `1password` |
| LastPass | `lastpass` |
| KDE Wallet | `org.kde.kwalletmanager5` |

### Adding Custom Apps
```ini
[Security]
PasswordManagerApps=keepassxc,bitwarden,myapp
```

## Configuration

### Basic Settings
```ini
[Security]
# Enable sensitive data protection
Enabled=true

# Auto-clear timeout (seconds)
AutoClearTimeout=30

# Clear on screen lock
ClearOnScreenLock=false

# Clear on logout
ClearOnLogout=true
```

### Detection Settings
```ini
[Security]
# Enable specific detectors
DetectCreditCards=true
DetectSSN=true
DetectAPIKeys=true
DetectPrivateKeys=true
DetectOTP=true

# OTP has separate timeout
OTPClearTimeout=60
```

### History Settings
```ini
[Security]
# Never save sensitive data to history
ExcludeSensitiveFromHistory=true

# Never sync sensitive data
ExcludeSensitiveFromSync=true
```

## Visual Indicators

When sensitive data is detected:

1. **System tray icon** changes to security indicator
2. **Tooltip** shows "Sensitive content - auto-clearing in Xs"
3. **Notification** (optional) confirms auto-clear

```ini
[Security]
ShowSensitiveIndicator=true
SensitiveIndicatorIcon=security-high
NotifyOnAutoClear=true
```

## Manual Clear

Clear clipboard immediately:

```bash
# Keyboard shortcut
Meta+Shift+V

# Command line
sanchala-clipboard clear

# Clear with confirmation
sanchala-clipboard clear --confirm
```

## Secure Memory

Sensitive clipboard data uses secure memory allocation:

```ini
[Security]
UseSecureMemory=true
```

This ensures:
- Memory is not swapped to disk
- Memory is zeroed on clear
- Memory is protected from other processes

## Custom Patterns

Add your own sensitive data patterns:

```ini
[Security]
SensitivePatterns=password,secret,token,api_key,mycompany_secret

# Custom regex patterns
CustomPatterns[company-id]=COMP-\d{8}
CustomPatterns[internal-token]=INT_[A-Z0-9]{16}
```

## Audit Log

Track sensitive data events:

```bash
# View recent sensitive data events
sanchala-clipboard audit --sensitive

# Output example:
# 2024-01-15 10:23:45 - Credit card detected, cleared after 30s
# 2024-01-15 10:25:12 - KeePassXC copy, cleared immediately
# 2024-01-15 10:30:00 - OTP detected, cleared after 60s
```

## Privacy Comparison

| Feature | Sanchala | macOS | Windows | GNOME |
|---------|----------|-------|---------|-------|
| Auto-clear passwords | ✅ 30s | ❌ | ❌ | ❌ |
| Credit card detection | ✅ | ❌ | ❌ | ❌ |
| OTP auto-clear | ✅ 60s | ❌ | ❌ | ❌ |
| Secure memory | ✅ | ❌ | ❌ | ❌ |
| Clear on lock | ✅ | ❌ | ❌ | ❌ |
| No history for secrets | ✅ | ❌ | ❌ | ❌ |

---

**Document Version:** 1.0  
**Part of SANCHALA OS** - Universal Clipboard

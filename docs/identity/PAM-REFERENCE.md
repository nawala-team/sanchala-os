# SANCHALA OS - PAM Configuration Reference

## Overview

PAM (Pluggable Authentication Modules) controls all authentication
in Sanchala OS. Our configuration prioritizes biometric methods
while maintaining secure password fallback.

## Authentication Order

```
1. pam_fprintd.so    → Fingerprint (sufficient)
2. pam_u2f.so        → FIDO2 key (sufficient)  
3. pam_faillock.so   → Brute-force protection
4. pam_unix.so       → Password verification
5. pam_gnome_keyring → Keyring unlock
```

## Module Reference

### pam_fprintd.so

Fingerprint authentication via fprintd.

```
auth sufficient pam_fprintd.so max_tries=3 timeout=10
```

Options:
- `max_tries=N`: Attempts before fallback
- `timeout=N`: Seconds to wait for finger

### pam_u2f.so

FIDO2/U2F hardware key authentication.

```
auth sufficient pam_u2f.so cue authfile=/etc/sanchala/identity/u2f_keys
```

Options:
- `cue`: Show "Touch your key" prompt
- `authfile`: Path to enrolled keys
- `interactive`: Prompt for key

### pam_faillock.so

Account lockout after failed attempts.

```
auth required pam_faillock.so preauth silent deny=5 unlock_time=900
auth required pam_faillock.so authfail deny=5 unlock_time=900
```

Options:
- `deny=N`: Lock after N failures
- `unlock_time=N`: Lockout seconds
- `silent`: Don't show lockout message

### pam_unix.so

Standard password authentication.

```
auth required pam_unix.so try_first_pass nullok
```

Options:
- `try_first_pass`: Use password from previous module
- `nullok`: Allow empty passwords (disabled accounts)
- `sha512`: Use SHA-512 hashing

### pam_pwquality.so

Password strength enforcement.

```
password requisite pam_pwquality.so retry=3 local_users_only
```

See `/etc/security/pwquality.conf` for policy.

### pam_gnome_keyring.so

GNOME Keyring integration.

```
auth optional pam_gnome_keyring.so
session optional pam_gnome_keyring.so auto_start
```

Options:
- `auto_start`: Start daemon on session
- `use_authtok`: Use password for keyring

### pam_kwallet5.so

KDE Wallet integration.

```
auth optional pam_kwallet5.so
session optional pam_kwallet5.so auto_start
```

## Configuration Files

### /etc/pam.d/system-auth

Core authentication - included by other configs.

### /etc/pam.d/sudo

```
# Fingerprint first (like macOS Touch ID)
auth sufficient pam_fprintd.so max_tries=1 timeout=8
auth sufficient pam_u2f.so cue
auth required pam_faillock.so preauth
auth required pam_unix.so try_first_pass
auth required pam_faillock.so authfail
```

### /etc/pam.d/gdm-password

GNOME Display Manager login with all methods.

### /etc/pam.d/sddm

KDE/SDDM login with biometric support.

### /etc/pam.d/polkit-1

System policy prompts (install software, etc).

## Customization

### Disable fingerprint for sudo

Edit `/etc/pam.d/sudo`, comment out:
```
#auth sufficient pam_fprintd.so
```

### Require password + biometric (2FA)

Change `sufficient` to `required`:
```
auth required pam_fprintd.so
auth required pam_unix.so
```

### Increase lockout time

Edit `/etc/security/faillock.conf`:
```
deny = 3
unlock_time = 1800  # 30 minutes
```

## Debugging

```bash
# Test PAM config
pamtester sudo $USER authenticate

# Check faillock status
faillock --user $USER

# Reset lockout
sudo faillock --user $USER --reset

# PAM debug logging
# Add 'debug' to module options temporarily
```

---

Version: 2.0 | See also: IDENTITY.md

# SANCHALA OS - Password Policy Documentation

## Overview

Sanchala OS enforces strong password policies based on NIST 800-63B
guidelines, balancing security with usability.

## Default Policy

| Setting | Value | Rationale |
|---------|-------|-----------|
| Minimum length | 12 chars | NIST recommends 8+, we go higher |
| Character classes | 3 of 4 | Lowercase, uppercase, digit, special |
| Max consecutive same | 3 | Prevents "aaaa" patterns |
| Dictionary check | Yes | Blocks common passwords |
| Username check | Yes | Can't contain username |
| Password history | 5 | Can't reuse last 5 passwords |

## Configuration

### /etc/security/pwquality.conf

```ini
# Minimum length
minlen = 12

# Minimum character classes (of 4 possible)
minclass = 3

# Maximum consecutive identical characters
maxrepeat = 3

# Check against dictionary
dictcheck = 1

# Check for username
usercheck = 1

# Minimum chars different from old password
difok = 5

# Apply to root too
enforce_for_root
```

### Character Class Credits

Credits reduce the effective minimum length requirement:

```ini
dcredit = -1    # Digit gives 1 char credit
ucredit = -1    # Uppercase gives 1 char credit
lcredit = -1    # Lowercase gives 1 char credit
ocredit = -1    # Special char gives 1 char credit
```

With all 4 classes, effective minimum = 12 - 4 = 8 chars.

## Account Lockout

### /etc/security/faillock.conf

```ini
# Lock after 5 failed attempts
deny = 5

# Unlock after 15 minutes
unlock_time = 900

# Count failures within this window
fail_interval = 900

# Local users only
local_users_only
```

### Managing Lockouts

```bash
# Check user lockout status
faillock --user username

# Reset lockout for user
sudo faillock --user username --reset

# View all lockouts
sudo faillock
```

## High Security Mode

For sensitive environments, enable `/etc/security/pwquality.conf.d/10-high-security.conf`:

```ini
minlen = 16
minclass = 4
difok = 8
maxrepeat = 2
```

## Password Aging (Optional)

Not enabled by default (NIST discourages forced rotation).
Enable in `/etc/login.defs` if required:

```ini
PASS_MAX_DAYS   365
PASS_MIN_DAYS   1
PASS_WARN_AGE   14
```

## Good Password Examples

✅ **Good passwords:**
- `correct-horse-battery-staple` (passphrase)
- `MyD0g$Nam3!sMax` (mixed characters)
- `7sunflowers#dancing` (memorable phrase)

❌ **Bad passwords:**
- `password123` (common)
- `admin` (too short)
- `qwerty12345` (keyboard pattern)
- `john1990` (personal info)

## Testing Password Strength

```bash
# Test a password
echo "testpassword" | pwscore

# Check password against policy
pwmake 128  # Generate compliant password
```

---

Version: 2.0 | See also: IDENTITY.md

# Headless Setup Guide

Automated first-run configuration for enterprise/OEM deployments.

## Overview

Headless setup allows pre-configuring Sanchala OS without user interaction, ideal for:
- Enterprise deployments
- OEM pre-installation
- Automated testing
- Kiosk/embedded systems

## Usage

```bash
sanchala-welcome --headless --config=/path/to/setup.toml
```

## Configuration File

### Complete Example

```toml
# /etc/sanchala/automated-setup.toml

[language]
locale = "en_US.UTF-8"

[region]
timezone = "America/New_York"
country = "US"
date_format = "MM/DD/YYYY"
time_format = "12h"
first_day_of_week = "sunday"

[keyboard]
layout = "us"
variant = ""
model = "pc105"

[network]
# Optional - skip if not needed
type = "wifi"  # or "ethernet", "none"
ssid = "CorpNetwork"
security = "wpa-enterprise"
identity = "user@corp.com"
# Password should be in separate secured file
password_file = "/etc/sanchala/network-password"

[account]
full_name = "Corporate User"
username = "corpuser"
# Pre-hashed password (mkpasswd -m sha-512)
password_hash = "$6$rounds=10000$..."
auto_login = false
avatar = "/usr/share/sanchala/avatars/default.png"

[security]
firewall = true
# These are detected, but can be forced
# secure_boot = true
# disk_encryption = true

[privacy]
# All false by default (privacy-first)
telemetry = false
crash_reports = false
location = false
analytics = false

[appearance]
theme = "dark"  # light, dark, auto
accent_color = "#3949AB"
wallpaper = "default-dark"
icon_theme = "sanchala-icons"

[online_accounts]
# Optional - usually skip for enterprise
skip = true

[tour]
auto_start = false
show_offer = false
```

### Minimal Example

```toml
# Minimal config - uses smart defaults

[language]
locale = "en_US.UTF-8"

[region]
timezone = "UTC"

[account]
full_name = "User"
username = "user"
password_hash = "$6$..."
```

## Password Handling

**Never store plaintext passwords in config files.**

### Option 1: Pre-hashed password

```bash
# Generate hash
mkpasswd -m sha-512 "password"

# Use in config
[account]
password_hash = "$6$rounds=10000$salt$hash..."
```

### Option 2: Separate password file

```toml
[account]
password_file = "/etc/sanchala/user-password"
```

```bash
# Create secured password file
echo "plaintext-password" > /etc/sanchala/user-password
chmod 600 /etc/sanchala/user-password
```

### Option 3: Environment variable

```bash
export SANCHALA_USER_PASSWORD="password"
sanchala-welcome --headless --config=setup.toml
```

## OEM Mode

For pre-installed systems that complete setup on first user boot:

```toml
# /etc/sanchala/oem-setup.toml

[oem]
enabled = true
manufacturer = "ACME Computers"
model = "WorkStation Pro"
support_url = "https://support.acme.com"
logo = "/usr/share/oem/acme-logo.png"

# Pre-configure everything except account
[language]
locale = "en_US.UTF-8"

[region]
timezone = "America/New_York"

# Account will be created by user
[account]
skip = true  # User creates account on first boot

[appearance]
theme = "auto"
accent_color = "#FF6600"  # OEM brand color
wallpaper = "/usr/share/oem/wallpaper.png"
```

## Enterprise Integration

### Active Directory Join

```toml
[enterprise]
type = "active_directory"
domain = "corp.example.com"
ou = "OU=Workstations,DC=corp,DC=example,DC=com"
admin_user = "domain-join-account"
admin_password_file = "/etc/sanchala/ad-password"
```

### LDAP Authentication

```toml
[enterprise]
type = "ldap"
server = "ldap://ldap.corp.com"
base_dn = "dc=corp,dc=com"
bind_dn = "cn=admin,dc=corp,dc=com"
```

## Validation

```bash
# Validate config without applying
sanchala-welcome --headless --config=setup.toml --validate

# Dry run - show what would be configured
sanchala-welcome --headless --config=setup.toml --dry-run
```

## Exit Codes

| Code | Meaning |
|------|--------|
| 0 | Success |
| 1 | Config file not found |
| 2 | Config validation error |
| 3 | Account creation failed |
| 4 | Network configuration failed |
| 5 | System error |

## Logging

```bash
# Verbose output
sanchala-welcome --headless --config=setup.toml -v

# Log to file
sanchala-welcome --headless --config=setup.toml 2>&1 | tee /var/log/setup.log
```

---

**Document Version:** 1.0

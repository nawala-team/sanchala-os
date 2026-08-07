# 👥 SANCHALA OS - User Management Documentation

## Overview

Sanchala OS provides macOS-style user management with easy account creation, guest mode, parental controls, and fast user switching.

---

## 🛠️ Tools

| Tool | Purpose |
|------|---------|
| `sanchala-users` | User account management CLI |
| `sanchala-parental` | Parental controls & screen time |
| `sanchala-user-switch` | Fast user switching daemon |

---

## 👤 User Types

### Standard User
- Default account type
- Can install Flatpak apps
- Can customize desktop
- Cannot modify system settings

### Administrator
- Full system access
- Can install system packages
- Can manage other users
- Sudo access with password

### Child (Supervised)
- Parental controls enabled
- Screen time limits
- Content filtering
- Activity tracking

### Guest
- Temporary session
- No password required
- Data erased on logout
- Sandboxed access

---

## 📋 Quick Start

### Create User
```bash
# Standard user
sanchala-users create john --fullname "John Doe"

# Administrator
sanchala-users create admin --fullname "Admin User" --admin

# Child with parental controls
sanchala-users create child --fullname "Child Name" --template child
```

### Manage Users
```bash
# List users
sanchala-users list

# User info
sanchala-users info john

# Delete user
sanchala-users delete john --remove-home
```

### Guest Mode
```bash
# Enable guest login
sanchala-users guest-enable

# Disable guest login
sanchala-users guest-disable
```

---

## 🛡️ Parental Controls

### Setup
```bash
# Add child to supervision
sanchala-parental user add --username child --age 10

# Set screen time (2 hours daily)
sanchala-parental screentime limit --user child --minutes 120

# Set allowed hours
sanchala-parental screentime schedule --user child --start 08:00 --end 20:00

# Set bedtime
sanchala-parental screentime bedtime --user child --time 21:00
```

### Content Filtering
```bash
# Set filter level (strict, moderate, minimal)
sanchala-parental filter level --user child --level moderate

# Block specific site
sanchala-parental filter block --user child --target youtube.com

# View activity report
sanchala-parental activity --user child --days 7
```

---

## 🔄 User Switching

Press `Ctrl+Alt+Delete` or click user name in panel to switch users.

Features:
- Sub-2-second switching
- Session preservation
- Cube animation effect
- Automatic session locking

---

## 📁 Configuration Files

| File | Purpose |
|------|---------|
| `/etc/sanchala/users/guest.conf` | Guest mode settings |
| `/etc/sanchala/users/switch.conf` | User switching settings |
| `/etc/sanchala/parental/config.toml` | Parental controls config |
| `/etc/accountsservice/user-templates.d/` | User templates |

---

## 🔗 Related Documentation

- [Guest Mode Specification](GUEST-MODE-SPEC.md)
- [Guest Mode Security](GUEST-MODE-SECURITY.md)
- [User Switching Optimization](USER-SWITCHING.md)

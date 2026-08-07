# 🔑 Sanchala Permission System

## Overview

Sanchala OS implements a TCC-like (Transparency, Consent, Control) permission system inspired by macOS but with enhanced transparency and user control.

## Permission Categories

### Hardware Access
| Permission | Description | Risk Level |
|------------|-------------|------------|
| Camera | Access camera devices | 🔴 High |
| Microphone | Audio recording | 🔴 High |
| Location | GPS/Network location | 🔴 High |
| Bluetooth | Bluetooth devices | 🟡 Medium |
| USB Devices | USB peripherals | 🟡 Medium |

### Data Access
| Permission | Description | Risk Level |
|------------|-------------|------------|
| Contacts | Address book | 🔴 High |
| Calendar | Calendar events | 🟡 Medium |
| Photos | Photo library | 🟡 Medium |
| Documents | Documents folder | 🟡 Medium |
| Downloads | Downloads folder | 🟢 Low |
| Full Disk | All files | 🔴 Critical |

### System Access
| Permission | Description | Risk Level |
|------------|-------------|------------|
| Screen Recording | Capture screen | 🔴 High |
| Accessibility | System control | 🔴 Critical |
| Input Monitoring | Keyboard/mouse | 🔴 Critical |
| Notifications | Show notifications | 🟢 Low |
| Autostart | Start at login | 🟡 Medium |
| Background | Run in background | 🟡 Medium |

### Network Access
| Permission | Description | Risk Level |
|------------|-------------|------------|
| Network Inbound | Accept connections | 🟡 Medium |
| Network Outbound | Make connections | 🟢 Low |

## How Permissions Work

### 1. First Request
When an app first requests a permission:
```
┌─────────────────────────────────────────────────┐
│  "Brave Browser" wants to access your camera    │
│                                                 │
│  This will allow the app to take photos and    │
│  record video.                                  │
│                                                 │
│  [Don't Allow]  [Allow Once]  [Always Allow]   │
└─────────────────────────────────────────────────┘
```

### 2. Permission States
| State | Meaning |
|-------|---------|
| Allow | Permission granted permanently |
| Deny | Permission denied permanently |
| Ask Every Time | Prompt each time |
| Allow Once | Single-use permission |

### 3. Access Notification
When a permission is used (if notifications enabled):
```
🎥 Brave Browser is using your camera
```

## Managing Permissions

### CLI Commands
```bash
# List all app permissions
sanchala-permissions list

# Show specific app
sanchala-permissions show com.brave.Browser

# Grant permission
sanchala-permissions grant com.brave.Browser camera

# Revoke permission
sanchala-permissions revoke com.brave.Browser camera

# Reset all for an app
sanchala-permissions reset com.brave.Browser
```

### GUI Method
1. **System Settings** → **Privacy & Security** → **App Permissions**
2. Browse by app or by permission type
3. Toggle permissions on/off

## Permission Audit

### Enable Auditing
```bash
# Enabled by default
sanchala-privacy config --set permissions.audit_enabled=true
```

### View Audit Log
```bash
# Recent permission accesses
sanchala-privacy audit --permissions --days 7
```

### Auto-Revoke Unused
Permissions not used in 90 days are automatically revoked:
```bash
# Configure auto-revoke period
sanchala-privacy config --set permissions.auto_revoke_unused_days=90

# Disable auto-revoke
sanchala-privacy config --set permissions.auto_revoke_unused_days=0
```

## Enforcement Layers

```
┌─────────────────────────────────────────┐
│           User Decision                  │
│  (Allow / Deny / Ask)                   │
└─────────────────┬───────────────────────┘
                  │
┌─────────────────▼───────────────────────┐
│        XDG Portals (Flatpak)            │
│  Mediated access for sandboxed apps     │
└─────────────────┬───────────────────────┘
                  │
┌─────────────────▼───────────────────────┐
│           AppArmor                       │
│  MAC enforcement for native apps        │
└─────────────────┬───────────────────────┘
                  │
┌─────────────────▼───────────────────────┐
│          Kernel (LSM)                    │
│  Final enforcement layer                │
└─────────────────────────────────────────┘
```

## High-Risk Permissions

These permissions require extra confirmation:

| Permission | Why It's Sensitive |
|------------|-------------------|
| Full Disk Access | Can read all your files |
| Input Monitoring | Can log keystrokes |
| Accessibility | Can control your system |
| Screen Recording | Can see everything |

---

**Document Version:** 1.0

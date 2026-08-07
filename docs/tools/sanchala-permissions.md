# Sanchala Permissions - TCC-like Permission Manager

## Overview

**sanchala-permissions** is the macOS TCC-inspired permission management system for Sanchala OS. It provides transparent, user-controlled access to sensitive resources like camera, microphone, location, and files.

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                   SANCHALA PERMISSIONS                           │
├─────────────────────────────────────────────────────────────────┤
│  ┌─────────────────────────────────────────────────────────┐    │
│  │              KDE Settings Module                         │    │
│  │  ┌──────────────────────────────────────────────────┐   │    │
│  │  │  Privacy & Security > App Permissions            │   │    │
│  │  └──────────────────────────────────────────────────┘   │    │
│  └─────────────────────────────────────────────────────────┘    │
│                              │                                   │
│                    ┌─────────┴─────────┐                        │
│                    │Permission Daemon  │                        │
│                    │(sanchala-permd)   │                        │
│                    └─────────┬─────────┘                        │
│                              │                                   │
│    ┌─────────────────────────┼─────────────────────────┐        │
│    ▼                         ▼                         ▼        │
│ ┌───────┐              ┌──────────┐              ┌─────────┐   │
│ │Portal │              │ Polkit   │              │AppArmor │   │
│ │(xdg)  │              │Integration│              │ Rules   │   │
│ └───────┘              └──────────┘              └─────────┘   │
└─────────────────────────────────────────────────────────────────┘
```

## Permission Categories

### Hardware Access
| Permission | Description | Portal |
|------------|-------------|--------|
| Camera | Access camera devices | `org.freedesktop.portal.Camera` |
| Microphone | Access audio input | `org.freedesktop.portal.Device` |
| Location | GPS/Network location | `org.freedesktop.portal.Location` |

### Data Access
| Permission | Description |
|------------|-------------|
| Contacts | Address book access |
| Calendar | Calendar data |
| Photos | Photo library |
| Documents | Documents folder |
| Downloads | Downloads folder |
| Full Disk | All files (requires polkit) |

### System Access
| Permission | Description |
|------------|-------------|
| Screen Recording | Capture screen (PipeWire) |
| Accessibility | Input control |
| Input Monitoring | Denied by default |
| Autostart | Login items |
| Background | Run in background |
| Notifications | Show notifications |

### Network Access  
| Permission | Description |
|------------|-------------|
| Network (Inbound) | Accept connections |

## CLI Interface

```bash
# List all permissions
sanchala-permissions list

# Show permissions for app
sanchala-permissions show com.brave.Browser

# Grant permission
sanchala-permissions grant com.brave.Browser camera

# Revoke permission
sanchala-permissions revoke com.brave.Browser camera

# Reset all permissions for app
sanchala-permissions reset com.brave.Browser
```

## D-Bus Interface

**Bus Name:** `id.sanchala.Permissions`

### Methods
- `CheckPermission(app_id: s, permission: s) -> (s)` - Check status
- `RequestPermission(app_id: s, permission: s) -> (s)` - Request with prompt
- `GrantPermission(app_id: s, permission: s) -> (b)` - Grant (requires polkit)
- `RevokePermission(app_id: s, permission: s) -> (b)` - Revoke
- `ListAppPermissions(app_id: s) -> (s)` - List as JSON

### Signals
- `PermissionChanged(app_id: s, permission: s, status: s)`
- `PermissionRequested(app_id: s, permission: s)`

## Configuration

```toml
# /etc/sanchala/permissions.toml

[defaults]
new_app_default = "ask"  # allow, deny, ask

[high_risk]
# Always require explicit user confirmation
full_disk_access = true
input_monitoring = true
accessibility = true
```

## File Locations

| File | Purpose |
|------|---------|
| `/etc/sanchala/permissions.toml` | System config |
| `/etc/sanchala/permissions.json` | Permission database |
| `/usr/share/polkit-1/actions/` | Polkit policies |

## Integration Points

- **XDG Portals**: Primary enforcement for Flatpak apps
- **AppArmor**: Enforcement for native apps
- **Polkit**: Authorization for permission changes
- **sanchala-guardian**: Security status integration
- **PipeWire**: Screen/audio capture control
- **firewalld**: Network permission enforcement

| Network (Outbound) | Make connections |

# Sandboxed Extension Runtime

## Overview

SANCHALA OS runs extensions in a sandboxed environment to protect system integrity and user privacy. This document specifies the runtime isolation mechanisms.

## Security Layers

```
┌─────────────────────────────────────────────────────────────┐
│                  EXTENSION SANDBOX LAYERS                    │
├─────────────────────────────────────────────────────────────┤
│  Layer 5: Resource Limits (cgroups v2)                       │
│           CPU, memory, I/O quotas                            │
├─────────────────────────────────────────────────────────────┤
│  Layer 4: Seccomp Filtering                                  │
│           Syscall allowlist per extension type               │
├─────────────────────────────────────────────────────────────┤
│  Layer 3: Namespace Isolation                                │
│           PID, mount, network namespaces                     │
├─────────────────────────────────────────────────────────────┤
│  Layer 2: Filesystem Restrictions                            │
│           Read-only mounts, tmpfs, path filtering            │
├─────────────────────────────────────────────────────────────┤
│  Layer 1: Permission Enforcement                             │
│           Declared capabilities only                         │
└─────────────────────────────────────────────────────────────┘
```

## Sandbox Profiles

### Plasmoid Profile (Medium Security)

```toml
[sandbox.plasmoid]
# Filesystem
fs_read = [
    "/usr/share/plasma",
    "/usr/share/icons",
    "/usr/share/fonts",
    "~/.local/share/plasma/plasmoids/${id}",
    "~/.config/plasma*"
]
fs_write = [
    "~/.config/${id}",
    "/tmp/sanchala-ext-${id}"
]

# Network (if permission granted)
network = "restricted"  # Only HTTPS, no raw sockets

# D-Bus
dbus_session = ["org.kde.*", "org.freedesktop.Notifications"]
dbus_system = []

# Syscalls blocked
seccomp_deny = ["mount", "ptrace", "reboot", "sethostname"]
```

### KWin Script Profile (Medium Security)

```toml
[sandbox.kwin-script]
# Filesystem
fs_read = [
    "/usr/share/kwin",
    "~/.local/share/kwin/scripts/${id}",
    "~/.config/kwinrc"
]
fs_write = [
    "~/.config/kwin-${id}"
]

# Network
network = "none"

# D-Bus
dbus_session = ["org.kde.KWin"]
dbus_system = []
```

### Theme Profile (High Security)

```toml
[sandbox.theme]
# Static resources only
fs_read = [
    "/usr/share/plasma/desktoptheme/${id}",
    "/usr/share/color-schemes"
]
fs_write = []
network = "none"
dbus_session = []
dbus_system = []
# No code execution
```

## Resource Limits

```toml
[limits.default]
cpu_percent = 10        # Max sustained CPU
memory_mb = 100         # Max memory
io_read_mbps = 10       # Disk read
io_write_mbps = 5       # Disk write
net_bandwidth_kbps = 1024  # Network (if allowed)
max_processes = 5       # Fork limit
max_files = 100         # Open file handles

[limits.trusted]        # Sanchala-signed extensions
cpu_percent = 25
memory_mb = 256
```

## Permission Enforcement

### Runtime Checks

```python
# Pseudo-code for permission check
def check_permission(extension_id, action, resource):
    manifest = load_manifest(extension_id)
    granted = load_user_grants(extension_id)
    
    required_perm = map_action_to_permission(action, resource)
    
    if required_perm in manifest.permissions:
        if required_perm in DANGEROUS_PERMISSIONS:
            return required_perm in granted
        return True
    return False
```

### Permission Prompts

When an extension requests a dangerous permission:

```
┌─────────────────────────────────────────────┐
│  "System Monitor" wants to access:           │
│                                              │
│  🌐 Network Access                           │
│     Connect to the internet                  │
│                                              │
│  [Allow Once] [Allow Always] [Deny]         │
└─────────────────────────────────────────────┘
```

## Audit Logging

All extension actions are logged:

```
/var/log/sanchala/extensions.log
```

Log format:
```json
{
    "timestamp": "2026-08-06T12:34:56Z",
    "extension": "org.sanchala.sysmonitor",
    "action": "network_request",
    "resource": "https://api.example.com",
    "result": "allowed",
    "user": "user1"
}
```

## Violation Handling

| Violation | Response |
|-----------|----------|
| Permission denied | Log + silent fail |
| Seccomp violation | Log + terminate |
| Resource exceeded | Throttle / suspend |
| Repeated violations | Auto-disable extension |

## Configuration

User configuration in `~/.config/sanchala/extensions.toml`:

```toml
[sandbox]
# Global sandbox settings
strict_mode = true
log_violations = true

[sandbox.overrides."org.sanchala.sysmonitor"]
# Per-extension overrides (advanced users)
memory_mb = 150
network = "full"  # User explicitly trusts
```

---
**Version:** 1.0 | **Last Updated:** August 2026

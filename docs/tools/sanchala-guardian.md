# Sanchala Guardian - Security Center

## Overview

**sanchala-guardian** is the central security management daemon for Sanchala OS. It provides real-time security monitoring, system hardening verification, and integration with Linux security subsystems.

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                    SANCHALA GUARDIAN                             │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐           │
│  │   Security   │  │  Permissions │  │    Audit     │           │
│  │   Module     │  │    Module    │  │    Module    │           │
│  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘           │
│         │                 │                 │                    │
│         └─────────────────┼─────────────────┘                    │
│                           │                                      │
│                    ┌──────┴──────┐                               │
│                    │   D-Bus     │                               │
│                    │  Interface  │                               │
│                    └──────┬──────┘                               │
│                           │                                      │
└───────────────────────────┼──────────────────────────────────────┘
                            │
        ┌───────────────────┼───────────────────┐
        │                   │                   │
        ▼                   ▼                   ▼
   ┌─────────┐       ┌───────────┐       ┌──────────┐
   │AppArmor │       │  Auditd   │       │ Firewall │
   └─────────┘       └───────────┘       └──────────┘
```

## Modules

### security.rs
- AppArmor profile management
- Kernel parameter hardening checks
- Secure Boot verification
- Seccomp availability detection
- Security report generation

### permissions.rs
- TCC-like permission management (macOS-inspired)
- Per-application permission tracking
- Permission types: Camera, Microphone, Location, Files, Network, etc.
- Persistent permission database

### audit.rs
- Linux audit subsystem integration
- Security event parsing and classification
- Real-time alert generation
- Audit statistics and reporting

## CLI Interface

```bash
# Run full security audit
sanchala-guardian --audit

# Show security status only
sanchala-guardian --status

# JSON output for integration
sanchala-guardian --audit --json

# Start as daemon
sanchala-guardian --daemon
```

## D-Bus Interface

**Bus Name:** `id.sanchala.Guardian`
**Object Path:** `/id/sanchala/Guardian`

### Methods
- `RunAudit() -> (s)` - Run security audit, return JSON report
- `GetSecurityLevel() -> (s)` - Get current security level
- `GetPermissions(app_id: s) -> (s)` - Get app permissions as JSON
- `SetPermission(app_id: s, permission: s, decision: s) -> (b)`

### Signals
- `SecurityAlert(severity: s, message: s)` - Emitted on security events
- `PermissionRequest(app_id: s, permission: s)` - App requesting permission

## Dependencies

- `auditd` - Linux audit daemon
- `apparmor` - AppArmor LSM
- `firewalld` - Firewall management
- `polkit` - Privilege management

## File Locations

| File | Purpose |
|------|---------|
| `/etc/sanchala/guardian.conf` | Configuration file |
| `/etc/sanchala/permissions.json` | Permission database |
| `/var/log/sanchala/guardian.log` | Log file |
| `/usr/share/sanchala/apparmor/` | AppArmor profiles |

## Security Checks Performed

1. **Kernel Hardening**
   - kptr_restrict, dmesg_restrict
   - ptrace_scope, kexec_load_disabled
   - Network hardening (syncookies, rp_filter)

2. **Firewall Status**
   - firewalld active check
   - Default zone verification

3. **AppArmor Status**
   - Profiles loaded and enforcing
   - Sanchala profiles present

4. **Disk Encryption**
   - LUKS encryption detection
   - Root partition encryption

5. **Secure Boot**
   - EFI secure boot variable check

6. **System Updates**
   - Available security updates

## Integration Points

- **sanchala-settings**: UI for security configuration
- **sanchala-permissions**: Permission management UI
- **KDE Plasma**: System tray integration
- **Polkit**: Privilege escalation dialogs

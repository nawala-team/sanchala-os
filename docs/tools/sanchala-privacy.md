# Sanchala Privacy - Privacy Dashboard & Controls

## Overview

**sanchala-privacy** is the central privacy management tool for Sanchala OS, providing a unified dashboard for privacy settings, permission auditing, telemetry controls, and data transparency.

## Key Features

- **Privacy Score**: Real-time privacy health indicator (0-100)
- **Zero Telemetry Default**: All telemetry OFF out of the box
- **Permission Audit**: Track and review app permissions
- **Data Transparency**: See exactly what data exists
- **Network Privacy**: DoH, MAC randomization, tracker blocking

## CLI Usage

```bash
# Show privacy dashboard
sanchala-privacy status

# Run privacy audit
sanchala-privacy audit
sanchala-privacy audit --format json

# Permission management
sanchala-privacy permissions --list
sanchala-privacy permissions --app com.brave.Browser

# Telemetry controls
sanchala-privacy telemetry --status
sanchala-privacy telemetry --block-all

# Data inventory
sanchala-privacy data --inventory

# Export privacy report
sanchala-privacy report --export ~/privacy-report.json
```

## D-Bus Interface

**Service**: `id.sanchala.Privacy`

Methods:
- `GetPrivacyScore() → (u)` - Get privacy score
- `GetTelemetryStatus() → (s)` - Get telemetry config as JSON
- `SetTelemetryOption(s, b) → (b)` - Enable/disable telemetry option

Signals:
- `PrivacyScoreChanged(u)` - Score updated
- `TelemetryBlocked(s, s)` - Telemetry attempt blocked

## Configuration

- System config: `/etc/sanchala/privacy.toml`
- Telemetry config: `/etc/sanchala/telemetry.toml`
- Domain blocklist: `/etc/sanchala/telemetry-blocklist.conf`

## Integration

- **sanchala-guardian**: Security integration
- **sanchala-permissions**: Permission enforcement
- **firewalld**: Network-level blocking
- **AppArmor**: Application sandboxing

## Files

| Path | Purpose |
|------|---------|
| `/usr/bin/sanchala-privacy` | CLI tool |
| `/usr/bin/sanchala-privd` | Privacy daemon |
| `/etc/sanchala/privacy.toml` | Configuration |
| `/var/lib/sanchala/privacy/` | Audit database |

## See Also

- sanchala-guardian(1) - Security center
- sanchala-permissions(1) - Permission manager

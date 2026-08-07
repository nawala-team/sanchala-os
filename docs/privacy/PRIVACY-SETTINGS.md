# ⚙️ Sanchala Privacy Settings Reference

## Overview

Complete reference for all privacy-related settings in Sanchala OS.

## Configuration File

Location: `/etc/sanchala/privacy.toml`

User override: `~/.config/sanchala/privacy.toml`

## Settings Reference

### Telemetry Settings

| Setting | Default | Description |
|---------|---------|-------------|
| `telemetry.crash_reports` | `false` | Send crash reports |
| `telemetry.usage_statistics` | `false` | Anonymous usage data |
| `telemetry.hardware_info` | `false` | Hardware survey |
| `telemetry.app_diagnostics` | `false` | App performance data |
| `telemetry.location_services` | `false` | Location tracking |
| `telemetry.search_suggestions` | `false` | Cloud search suggestions |
| `telemetry.spell_check_cloud` | `false` | Cloud spell checking |
| `telemetry.font_rendering_cloud` | `false` | Cloud font services |

### Permission Settings

| Setting | Default | Description |
|---------|---------|-------------|
| `permissions.audit_enabled` | `true` | Track permission usage |
| `permissions.audit_retention_days` | `30` | Days to keep audit logs |
| `permissions.notify_on_access` | `true` | Notify when permissions used |
| `permissions.auto_revoke_unused_days` | `90` | Auto-revoke after N days |

### Network Privacy Settings

| Setting | Default | Description |
|---------|---------|-------------|
| `network.dns_over_https` | `true` | Encrypt DNS queries |
| `network.mac_randomization` | `true` | Randomize MAC address |
| `network.hostname_randomization` | `true` | Randomize hostname |
| `network.ipv6_privacy_extensions` | `true` | IPv6 privacy |
| `network.block_telemetry_domains` | `true` | Block known trackers |

### Data Retention Settings

| Setting | Default | Description |
|---------|---------|-------------|
| `data_retention.recent_files_days` | `7` | Recent files history |
| `data_retention.browser_history_days` | `30` | Browser history |
| `data_retention.search_history_days` | `7` | Search history |
| `data_retention.clipboard_history_enabled` | `false` | Store clipboard |
| `data_retention.thumbnail_cache_enabled` | `true` | Cache thumbnails |

## CLI Configuration

### View Current Settings
```bash
sanchala-privacy config --show
```

### Modify Settings
```bash
# Set a value
sanchala-privacy config --set telemetry.crash_reports=false

# Reset to defaults
sanchala-privacy config --reset
```

## GUI Configuration

**System Settings** → **Privacy & Security** → **Privacy Settings**

Sections:
1. **Telemetry** - All OFF by default
2. **Permissions** - Audit and notification settings
3. **Network** - Privacy features
4. **Data** - Retention policies

## Privacy Profiles

### Maximum Privacy (Default)
```toml
[telemetry]
crash_reports = false
usage_statistics = false
# ... all false

[network]
dns_over_https = true
mac_randomization = true
# ... all true
```

### Contributor Mode
For users who want to help improve Sanchala:
```toml
[telemetry]
crash_reports = true  # Help fix bugs
usage_statistics = false  # Still private
```

## Environment Variables

| Variable | Effect |
|----------|--------|
| `SANCHALA_PRIVACY_STRICT=1` | Force maximum privacy |
| `SANCHALA_NO_TELEMETRY=1` | Block all telemetry |

## Systemd Integration

Privacy daemon status:
```bash
systemctl status sanchala-privd
```

---

**Document Version:** 1.0

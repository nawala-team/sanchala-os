# Critical Alerts Guide

> Emergency notifications that always get through

## Overview

Critical alerts are high-priority notifications that bypass all filtering, Do Not Disturb, and Focus modes. They're reserved for emergencies and system-critical events.

## Critical Categories

| Category | Icon | Trigger Examples |
|----------|------|------------------|
| 🔒 Security | `security-high` | Breach detected, unauthorized access |
| 🔋 Battery | `battery-empty` | Battery below 5% |
| 💾 Disk | `drive-harddisk` | Storage above 95% full |
| 🧠 Memory | `memory` | RAM critically low |
| 🌡️ Temperature | `temperature` | Hardware overheating |
| 🌐 Network | `network-error` | Security threat detected |
| ⚠️ System | `dialog-error` | Critical system failure |
| 📁 Data | `data-warning` | Potential data loss |

## Behavior

Critical alerts:

1. **Always show** - Bypass DND and Focus modes
2. **Stay visible** - Don't auto-dismiss
3. **Wake screen** - Turn on display
4. **Play sound** - Even when muted
5. **Require action** - Must be acknowledged

## Configuration

### Basic Settings
```ini
# ~/.config/sanchala/critical-alerts.conf
[General]
Enabled=true
BypassAllFilters=true
BypassDND=true
RequireAcknowledgment=true
```

### Display Options
```ini
[Display]
AlwaysOnTop=true
PersistUntilDismissed=true
WakeScreen=true
ScreenBrightness=100
```

### Sound Settings
```ini
[Sound]
Enabled=true
BypassMute=true
Volume=100
RepeatEnabled=false
RepeatCount=3
```

## Custom Critical Categories

```ini
[Category][custom-category]
Enabled=true
DisplayName=Custom Alert
Icon=custom-icon-symbolic
Description=My custom critical alert
Sources=my-app,my-service
```

## Acknowledgment

Critical alerts require user acknowledgment:

- **Dismiss** - Remove the alert
- **Snooze** - Remind later (5/15/30/60 min)
- **Action** - Take specific action (e.g., "Plug in charger")

```ini
[Acknowledgment]
RequireAction=true
SnoozeOptions=5,15,30,60
MaxSnoozeCount=3
```

## Integration with Sanchala Guardian

Sanchala Guardian (security daemon) sends critical alerts for:

- Firewall breach attempts
- Malware detection
- Unauthorized access attempts
- Permission escalation
- Suspicious network activity

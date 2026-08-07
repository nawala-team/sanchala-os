# Sanchala OS Notification System

> iOS/macOS-quality notification management for Linux

## Overview

Sanchala OS features a comprehensive notification system designed to match and exceed Apple's notification experience. Key features include:

- **Smart Notification Center** - Grouped, organized, actionable notifications
- **Focus Modes** - macOS Monterey-style focus profiles
- **Do Not Disturb** - Intelligent interruption management
- **Critical Alerts** - Emergency notifications that always get through
- **Privacy Controls** - Hide sensitive content on lock screen
- **Rule-Based Filtering** - Automatic prioritization and filtering

## Quick Start

### Enable Do Not Disturb
```
# Click the notification icon in system tray
# Or use keyboard shortcut: Meta+N → Toggle DND
```

### Activate Focus Mode
```
# System Tray → Focus Mode icon
# Or: Meta+Shift+F (toggle menu)
# Or: Meta+F (quick toggle last used)
```

## Configuration Files

| File | Purpose |
|------|---------|  
| `~/.config/plasmanotifyrc` | Main Plasma notification settings |
| `~/.config/sanchala/focus-modes.conf` | Focus mode definitions |
| `~/.config/sanchala/notification-rules.conf` | Filtering rules |
| `~/.config/sanchala/notification-history.conf` | History settings |
| `~/.config/sanchala/critical-alerts.conf` | Critical alert handling |

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Notification Center                       │
├─────────────────────────────────────────────────────────────┤
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │ Focus Mode  │  │     DND     │  │   Critical Alerts   │  │
│  │   Engine    │  │   Manager   │  │      Handler        │  │
│  └──────┬──────┘  └──────┬──────┘  └──────────┬──────────┘  │
│         │                │                     │             │
│         └────────────────┼─────────────────────┘             │
│                          │                                   │
│                  ┌───────▼────────┐                          │
│                  │  Rule Engine   │                          │
│                  │  (Filtering)   │                          │
│                  └───────┬────────┘                          │
│                          │                                   │
│         ┌────────────────┼────────────────┐                  │
│         │                │                │                  │
│  ┌──────▼──────┐  ┌──────▼──────┐  ┌──────▼──────┐          │
│  │   Popup     │  │   History   │  │   Sounds    │          │
│  │  Display    │  │   Storage   │  │   Engine    │          │
│  └─────────────┘  └─────────────┘  └─────────────┘          │
└─────────────────────────────────────────────────────────────┘
```

## Documentation

- [Focus Modes Guide](FOCUS-MODES.md) - Detailed focus mode configuration
- [Notification Rules](NOTIFICATION-RULES.md) - Rule syntax and examples  
- [Critical Alerts](CRITICAL-ALERTS.md) - Emergency notification handling
- [Privacy Settings](PRIVACY.md) - Protecting sensitive notifications
- [Troubleshooting](TROUBLESHOOTING.md) - Common issues and solutions

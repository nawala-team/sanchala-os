# Sanchala OS - Device Sync Documentation

## Overview

Sanchala OS provides Apple Continuity-level device synchronization using open-source technologies. The system combines KDE Connect for phone integration and Syncthing for file synchronization.

## Features

### 1. Universal Clipboard
- Seamless clipboard sync between desktop and phone
- Text, images, and URLs supported
- Encrypted transit
- Sensitive content filtering (passwords, tokens)
- Configurable sync direction

### 2. Notification Mirroring
- Phone notifications appear on desktop
- Reply to messages directly from desktop
- Dismiss notifications across devices
- Per-app filtering and priority
- Privacy controls for lock screen

### 3. SMS & Calls
- Send/receive SMS from desktop
- Incoming call notifications with caller ID
- Answer/reject calls from desktop
- Pause media on incoming calls
- Quick reply with preset messages

### 4. File Sharing (Sanchala Drop)
- AirDrop-like instant file sharing
- Drag-and-drop to nearby devices
- Context menu integration
- Automatic device discovery

### 5. File Synchronization
- iCloud-like folder sync via Syncthing
- Documents, Pictures, Music folders
- Versioning and conflict resolution
- End-to-end encryption
- Bandwidth controls

### 6. Handoff
- Continue browsing on another device
- Document editing continuity
- Activity timeout and proximity detection

### 7. Phone Integration
- Remote touchpad/keyboard
- Media player control
- Find my phone
- Battery status in system tray
- Use phone camera as webcam

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                    SANCHALA DEVICE SYNC                         │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌─────────────────┐        ┌─────────────────┐                │
│  │   KDE Connect   │        │    Syncthing    │                │
│  │                 │        │                 │                │
│  │ • Clipboard     │        │ • File Sync     │                │
│  │ • Notifications │        │ • Versioning    │                │
│  │ • SMS/Calls     │        │ • P2P Encrypted │                │
│  │ • Media Control │        │ • Conflict Res  │                │
│  │ • File Share    │        │                 │                │
│  └────────┬────────┘        └────────┬────────┘                │
│           │                          │                          │
│           └──────────┬───────────────┘                          │
│                      │                                          │
│           ┌──────────▼──────────┐                               │
│           │  Sanchala Sync Hub  │                               │
│           │                     │                               │
│           │ • Unified Config    │                               │
│           │ • Status Monitoring │                               │
│           │ • Service Mgmt      │                               │
│           └─────────────────────┘                               │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

## Configuration Files

| File | Purpose |
|------|---------|
| `~/.config/kdeconnect/config` | KDE Connect main settings |
| `~/.config/kdeconnect/plugins.conf` | Plugin configuration |
| `~/.config/syncthing/config.conf` | Syncthing settings |
| `~/.config/sanchala/sync/device-sync.conf` | Master sync config |
| `~/.config/sanchala/sync/notification-mirror.conf` | Notification settings |
| `~/.config/sanchala/sync/file-sync.conf` | File sync settings |
| `~/.config/sanchala/sync/sms-calls.conf` | Telephony settings |

## Quick Start

### 1. Connect Your Phone

```bash
# Install KDE Connect on your Android phone from Play Store/F-Droid

# On desktop, check for available devices
sanchala-sync kdc status

# Pair with your phone
sanchala-sync kdc pair
```

### 2. Enable File Sync

```bash
# Start Syncthing service
sanchala-sync st start

# Open Syncthing GUI to add devices
sanchala-sync st gui
```

### 3. Share Files

```bash
# Quick share a file (AirDrop-like)
sanchala-drop ~/Documents/file.pdf

# Or use context menu in Dolphin
```

### 4. Send SMS

```bash
# Send SMS from command line
sanchala-sync kdc sms <device_id> "+1234567890" "Hello!"

# Or use the SMS app from application menu
```

## Services

### Systemd User Services

```bash
# Enable KDE Connect on login
systemctl --user enable sanchala-kdeconnect.service

# Enable Syncthing on login
systemctl --user enable sanchala-syncthing.service

# Check status
systemctl --user status sanchala-kdeconnect sanchala-syncthing
```

## Security

- All connections use TLS encryption
- Device pairing requires manual approval
- Clipboard sync excludes sensitive patterns
- File sync uses end-to-end encryption
- Notification content hidden on lock screen
- Trusted devices only for auto-connect

## Troubleshooting

### KDE Connect not finding devices

1. Ensure both devices are on the same network
2. Check firewall allows ports 1714-1764 (TCP/UDP)
3. Restart KDE Connect daemon

```bash
killall kdeconnectd
/usr/lib/kdeconnect/kdeconnectd &
```

### Syncthing not syncing

1. Check service status
2. Verify both devices have the folder shared
3. Check for conflicts in Syncthing GUI

```bash
sanchala-sync st status
sanchala-sync st gui
```

### Notifications not appearing

1. Check notification permissions in KDE Connect app on phone
2. Verify plugin is enabled in config
3. Check notification filtering settings

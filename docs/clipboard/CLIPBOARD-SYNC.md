# 🔄 SANCHALA OS - Clipboard Cross-Device Sync

## Overview

Universal Clipboard sync enables seamless clipboard sharing between all your devices - desktop, laptop, phone, and tablet. Copy anywhere, paste everywhere.

## Requirements

- **KDE Connect** installed on all devices
- **Devices paired** and trusted
- **Same network** or KDE Connect remote access configured

## Quick Setup

### Desktop (Sanchala OS)

```bash
# Install KDE Connect (included by default)
sudo pacman -S kdeconnect

# Start KDE Connect daemon
systemctl --user enable --now kdeconnect

# Verify clipboard plugin is enabled
kdeconnect-cli --list-devices
```

### Android Phone/Tablet

1. Install **KDE Connect** from [F-Droid](https://f-droid.org/packages/org.kde.kdeconnect_tp/) or Play Store
2. Open KDE Connect → Find your desktop
3. Tap to pair → Accept on desktop
4. Enable **Clipboard Sync** plugin

### iOS (Limited Support)

KDE Connect is not available on iOS. Alternatives:
- Use **Clipt** browser extension
- Use **Pushbullet** with browser
- Manual sync via messaging apps

## Sync Modes

### Automatic (Default)
```ini
[Sync]
SyncMode=auto
```
Clipboard syncs immediately on copy.

### Manual
```ini
[Sync]
SyncMode=manual
```
Use `Meta+Ctrl+S` to sync on demand.

### Ask
```ini
[Sync]
SyncMode=ask
```
Prompts before syncing (useful for privacy).

## Content Types

| Type | Synced | Max Size | Notes |
|------|--------|----------|-------|
| Text | ✅ | 64 KB | Plain and rich text |
| Images | ✅ | 5 MB | Compressed to 80% quality |
| URLs | ✅ | 64 KB | With metadata preview |
| Files | ❌ | - | Use file transfer instead |
| Passwords | ❌ | - | Security: never synced |

## Security

### Encryption
All clipboard data is encrypted in transit using the KDE Connect TLS connection.

### Trusted Devices Only
```ini
[Sync]
TrustedDevicesOnly=true
```
Only paired and trusted devices receive clipboard data.

### Sensitive Data Protection
```ini
[Sync]
SyncSensitiveData=false
```
Passwords, API keys, and credit cards are **never synced**.

## Handoff Feature

Continue your work on another device:

1. **Copy a URL** on your phone
2. **Desktop shows Handoff indicator** in dock
3. **Click to open** the URL in your desktop browser

### Supported Apps
- Web browsers (Brave, Firefox, Chromium)
- Text editors (Kate, KWrite)
- Office apps (LibreOffice)
- File manager (Dolphin)

### Enable Handoff
```ini
[KDEConnect]
HandoffEnabled=true
HandoffApps=brave-browser,firefox,org.kde.kate,libreoffice
```

## Troubleshooting

### Clipboard not syncing

```bash
# Check KDE Connect status
kdeconnect-cli --list-devices

# Check if clipboard plugin is enabled
kdeconnect-cli -d <device-id> --list-available

# Restart KDE Connect
systemctl --user restart kdeconnect
```

### Devices not discovering each other

```bash
# Ensure same network
ip addr show

# Check firewall ports (1714-1764 UDP/TCP)
sudo firewall-cmd --list-ports

# Open KDE Connect ports
sudo firewall-cmd --permanent --add-port=1714-1764/tcp
sudo firewall-cmd --permanent --add-port=1714-1764/udp
sudo firewall-cmd --reload
```

### Large images not syncing

Images over 5MB are not synced. Options:
1. Enable compression: `CompressImagesForSync=true`
2. Use KDE Connect file transfer instead
3. Reduce image size before copying

## CLI Commands

```bash
# Send clipboard to device
kdeconnect-cli -d <device-id> --share-clipboard

# Get device clipboard
kdeconnect-cli -d <device-id> --get-clipboard

# List all devices
kdeconnect-cli --list-devices

# Refresh device discovery
kdeconnect-cli --refresh
```

## Configuration Reference

| Setting | Default | Description |
|---------|---------|-------------|
| `Sync/Enabled` | true | Enable clipboard sync |
| `Sync/SyncMode` | auto | auto, manual, ask |
| `Sync/SyncDirection` | both | both, send, receive |
| `Sync/MaxTextSyncSize` | 65536 | Max text size (bytes) |
| `Sync/MaxImageSyncSize` | 5242880 | Max image size (bytes) |
| `Sync/SyncSensitiveData` | false | Sync passwords etc |
| `Sync/EncryptSync` | true | Encrypt in transit |
| `Sync/SyncDebounce` | 500 | Delay before sync (ms) |

---

**Document Version:** 1.0  
**Part of SANCHALA OS** - Universal Clipboard

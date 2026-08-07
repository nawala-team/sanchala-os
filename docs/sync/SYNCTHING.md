# Syncthing File Sync Guide

## Overview

Syncthing provides secure, decentralized file synchronization - like iCloud Drive but without the cloud. Files sync directly between your devices over encrypted connections.

## Key Features

- **No Cloud Required**: Direct device-to-device sync
- **End-to-End Encryption**: TLS 1.3 for all transfers
- **Open Source**: Fully auditable, no vendor lock-in
- **Cross-Platform**: Linux, Windows, macOS, Android
- **Versioning**: Recover previous file versions
- **Selective Sync**: Choose which folders to sync

## Architecture

```
┌──────────────┐         ┌──────────────┐
│   Desktop    │◄───────►│    Laptop    │
│  Syncthing   │  P2P    │  Syncthing   │
└──────┬───────┘ Encrypted└──────────────┘
       │
       │ P2P Encrypted
       ▼
┌──────────────┐
│    Phone     │
│  Syncthing   │
└──────────────┘
```

## Default Synced Folders

| Folder | Path | Description |
|--------|------|-------------|
| Documents | ~/Documents | Office files, PDFs |
| Pictures | ~/Pictures | Photos and images |
| Music | ~/Music | Audio files |
| Desktop Config | ~/.config/sanchala | App settings sync |

## Quick Setup

### Start Syncthing

```bash
# Start service
sanchala-sync st start

# Enable auto-start
systemctl --user enable sanchala-syncthing.service

# Open web GUI
sanchala-sync st gui
```

### Add a Device

1. Open Syncthing GUI: http://127.0.0.1:8384
2. Click "Add Remote Device"
3. Enter the Device ID from your other device
4. Confirm on both devices

### Share a Folder

1. Click "Add Folder" in GUI
2. Set folder path and label
3. Select devices to share with
4. Configure versioning (optional)

## Configuration

### Main Config: `~/.config/syncthing/config.conf`

```ini
[General]
GUIEnabled=true
GUIAddress=127.0.0.1:8384

[Network]
GlobalDiscovery=true
LocalDiscovery=true
RelaysEnabled=true
```

### Sanchala Config: `~/.config/sanchala/sync/file-sync.conf`

```ini
[DefaultFolders][Documents]
Enabled=true
LocalPath=~/Documents
Versioning=staggered

[Bandwidth]
LimitOnBattery=true
BatteryUploadLimit=500
```

## Versioning Options

### Simple Versioning
Keeps the last N versions of each file.

```ini
[Versioning][simple]
Type=simple
Params=keep=5
```

### Staggered Versioning
Keeps versions at increasing intervals (hourly → daily → weekly).

```ini
[Versioning][staggered]
Type=staggered
Params=cleanInterval=3600,maxAge=31536000
```

### Trashcan Versioning
Moves deleted/modified files to `.stversions` folder.

```ini
[Versioning][trashcan]
Type=trashcan
Params=cleanoutDays=30
```

## Ignore Patterns

Create `.stignore` in any synced folder:

```
# Ignore temporary files
*.tmp
*.temp
~*

# Ignore system files
.DS_Store
Thumbs.db
desktop.ini

# Ignore development folders
node_modules
.git
__pycache__
*.pyc

# Ignore large files
*.iso
*.dmg
```

## Conflict Resolution

When the same file is modified on multiple devices:

1. **Newer Wins**: Most recent modification kept
2. **Keep Both**: Creates conflict copy with timestamp
3. **Manual**: Notification to resolve manually

Conflict copies are named: `filename.sync-conflict-YYYYMMDD-HHMMSS.ext`

## Security

### Encryption
- All traffic encrypted with TLS 1.3
- Perfect Forward Secrecy (PFS)
- Device identity via Ed25519 keys

### Device Verification
- Devices identified by unique ID (56-char hash)
- Must manually approve new devices
- Can require introducer for new devices

### Network Security
- Local discovery uses broadcasts
- Global discovery via relay servers
- Can disable global/relay for LAN-only

## Bandwidth Management

```ini
[Bandwidth]
# Unlimited when on power
LimitEnabled=false

# Limit on battery
LimitOnBattery=true
BatteryUploadLimit=500    # KiB/s
BatteryDownloadLimit=1000

# Limit on metered connections
LimitOnMetered=true
MeteredUploadLimit=100
MeteredDownloadLimit=500
```

## Mobile Sync (Android)

1. Install Syncthing from F-Droid or Play Store
2. Note the Device ID in Settings
3. Add device in desktop Syncthing
4. Share desired folders
5. Configure "Run on WiFi only" to save data

## Troubleshooting

### Sync Not Starting

```bash
# Check service status
systemctl --user status sanchala-syncthing

# View logs
journalctl --user -u sanchala-syncthing -f

# Restart service
sanchala-sync st restart
```

### Connection Issues

1. Check both devices online in GUI
2. Verify Device IDs match
3. Check firewall allows Syncthing (port 22000)
4. Try enabling relays if direct connection fails

### Conflicts Piling Up

1. Check `.stversions` folder size
2. Review versioning settings
3. Consider switching to "newer wins" resolution
4. Clean old versions: Actions → Clean Versions

# ☁️ Sanchala Cloud - Documentation

## Overview

Sanchala Cloud provides native, iCloud-like cloud storage integration for Sanchala OS. Access Google Drive, Dropbox, OneDrive, and 40+ providers directly from Dolphin with real-time sync and status indicators.

---

## 🎯 Features

| Feature | Description |
|---------|-------------|
| Native Integration | Cloud folders appear in Dolphin sidebar |
| Real-time Sync | Bidirectional sync with conflict resolution |
| Status Overlays | Visual indicators (✓ synced, ↻ syncing, ⚠ error) |
| Offline Access | Pin files for offline availability |
| Client-side Encryption | Optional zero-knowledge encryption |
| System Tray | Quick access and notifications |

---

## 🚀 Quick Start

### 1. Add Cloud Account

```bash
# Google Drive
sanchala-cloud add gdrive

# Dropbox
sanchala-cloud add dropbox

# OneDrive
sanchala-cloud add onedrive

# Nextcloud (requires URL)
sanchala-cloud add nextcloud
```

### 2. Enable Sync Daemon

```bash
systemctl --user enable --now sanchala-cloudd
```

### 3. Access Files

Files appear in `~/Cloud/<provider>/` and Dolphin sidebar.

---

## 📁 File Structure

```
~/Cloud/
├── Google_Drive/
│   ├── Documents/
│   ├── Photos/
│   └── Shared/
├── Dropbox/
└── OneDrive/
```

---

## 🔄 Sync Status Icons

| Icon | Status | Meaning |
|------|--------|---------|
| ✓ Green | Synced | File is up to date |
| ↻ Blue | Syncing | Transfer in progress |
| ⏱ Gray | Pending | Waiting to sync |
| 📌 Pin | Offline | Available offline |
| ⚠ Red | Error | Sync failed |

---

## 🔐 Security

- **OAuth2** - Secure token-based authentication
- **KWallet** - Credentials stored encrypted
- **Client-side encryption** - Optional rclone crypt layer
- **No plaintext** - Tokens never stored in plain files

### Enable Encryption

```bash
sanchala-cloud encrypt Google_Drive
```

---

## ⚙️ Configuration

Config file: `~/.config/sanchala-cloud/config.conf`

```ini
[General]
sync_interval = 300
auto_sync = true

[Cache]
cache_mode = full
cache_max_size = 10G
```

---

## 🛠️ CLI Reference

```bash
sanchala-cloud add <provider>    # Add account
sanchala-cloud list              # List accounts
sanchala-cloud sync [name]       # Force sync
sanchala-cloud status            # Show status
sanchala-cloud pin <path>        # Pin for offline
sanchala-cloud mount <name>      # FUSE mount
sanchala-cloud remove <name>     # Remove account
```

---

## 🔧 Troubleshooting

### Sync not working

```bash
# Check daemon status
systemctl --user status sanchala-cloudd

# View logs
journalctl --user -u sanchala-cloudd -f

# Force resync
sanchala-cloud sync --force
```

### Authentication expired

```bash
# Re-authenticate
sanchala-cloud add gdrive --reauth
```

---

**Version:** 1.0 | **See also:** [Cloud Integration Spec](CLOUD-INTEGRATION-SPEC.md)

# ☁️ Sanchala Cloud - Native Cloud Storage Integration

## Overview

Sanchala Cloud provides seamless, macOS iCloud-like cloud storage integration for Sanchala OS. It enables native file manager access to Google Drive, Dropbox, OneDrive, and other cloud providers with real-time sync, status indicators, and transparent encryption.

---

## 🎯 Design Goals

1. **Native Experience** - Cloud files appear as local folders in Dolphin
2. **Real-time Sync** - Automatic bidirectional synchronization
3. **Visual Feedback** - Sync status overlays on files and folders
4. **Privacy First** - Optional client-side encryption before upload
5. **Offline Support** - Pinned files available without internet
6. **Low Resource** - Efficient background syncing

---

## 🏗️ Architecture

```
┌───────────────────────────────────────────────────────────────┐
│                   SANCHALA CLOUD STACK                        │
├───────────────────────────────────────────────────────────────┤
│  UI LAYER: Dolphin + KIO | System Tray | Settings Panel       │
├───────────────────────────────────────────────────────────────┤
│  INTEGRATION: KIO Workers | Status Overlays | D-Bus Service   │
├───────────────────────────────────────────────────────────────┤
│  SYNC ENGINE: Rclone (40+ providers) | Client-side Encryption │
├───────────────────────────────────────────────────────────────┤
│  STORAGE: Local Cache ~/Cloud | Metadata DB | KWallet Creds   │
└───────────────────────────────────────────────────────────────┘
```

---

## 🚀 Supported Providers

| Provider | Status | Features |
|----------|--------|----------|
| Google Drive | ✅ Full | Sync, Stream, Share |
| Dropbox | ✅ Full | Sync, Stream, Share |
| OneDrive | ✅ Full | Sync, Stream, Share |
| Nextcloud | ✅ Full | Sync, WebDAV |
| MEGA | ✅ Full | Sync, E2E encryption |
| Amazon S3 | ✅ Full | Sync, Versioning |
| WebDAV/SFTP | ✅ Full | Generic support |

---

## 📋 Quick Start

```bash
sudo pacman -S sanchala-cloud
systemctl --user enable --now sanchala-cloudd
sanchala-cloud add gdrive
```

**Version:** 1.0 | **License:** GPL-3.0

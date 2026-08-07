# ☁️ Cloud Storage Integration Specification

## 1. Overview

This document specifies the cloud storage integration architecture for Sanchala OS, providing a native experience comparable to macOS iCloud Drive.

---

## 2. Architecture Components

### 2.1 Core Stack

```
┌─────────────────────────────────────────────────────────┐
│                    USER INTERFACE                        │
│  Dolphin │ System Tray │ Settings │ Plasma Widget       │
├─────────────────────────────────────────────────────────┤
│                    INTEGRATION                           │
│  KIO Workers │ D-Bus API │ Status Overlays              │
├─────────────────────────────────────────────────────────┤
│                    SYNC ENGINE                           │
│  Rclone │ bisync │ VFS mount │ Client Encryption        │
├─────────────────────────────────────────────────────────┤
│                    STORAGE                               │
│  ~/Cloud/ │ SQLite Metadata │ KWallet Credentials       │
└─────────────────────────────────────────────────────────┘
```

### 2.2 Component Responsibilities

| Component | Purpose |
|-----------|---------|
| sanchala-cloudd | Background daemon, sync coordination |
| KIO workers | Dolphin protocol handlers |
| Rclone | Provider communication, encryption |
| Status monitor | File state tracking, overlays |
| Plasma widget | System tray UI |

---

## 3. Supported Providers

| Provider | Type | Auth | Features |
|----------|------|------|----------|
| Google Drive | drive | OAuth2 | Sync, stream, share |
| Dropbox | dropbox | OAuth2 | Sync, stream, share |
| OneDrive | onedrive | OAuth2 | Sync, SharePoint |
| Nextcloud | webdav | Basic | Sync, share |
| MEGA | mega | Password | Sync, E2E |
| Amazon S3 | s3 | Keys | Sync, versioning |
| WebDAV | webdav | Basic | Sync |
| SFTP | sftp | Key/Pass | Sync |

---

## 4. Sync Behavior

### 4.1 Sync Modes

- **bisync**: Two-way sync (default)
- **sync**: One-way cloud→local
- **copy**: One-way local→cloud

### 4.2 Conflict Resolution

1. Newer file wins (by mtime)
2. Create .conflict copy for older
3. Notify user of conflicts

### 4.3 Sync Triggers

- Timer (5 min default)
- inotify file changes
- Manual request
- Network reconnect

---

## 5. File Status States

```
SYNCED → File matches remote
SYNCING → Transfer in progress  
PENDING → Queued for sync
OFFLINE → Pinned, available offline
ERROR → Sync failed
IGNORED → Excluded from sync
```

---

## 6. Security Model

### 6.1 Credential Storage

- OAuth tokens → KWallet (encrypted)
- API keys → KWallet
- Never plaintext on disk

### 6.2 Client-Side Encryption

Optional rclone crypt layer:
- AES-256 file encryption
- Encrypted filenames
- Zero-knowledge to provider

### 6.3 Permissions

- Polkit for mount operations
- User-space FUSE mounts
- No root required for normal use

---

## 7. Performance

### 7.1 Caching

- VFS cache mode: full
- Cache size: 10GB default
- Read-ahead: 128MB

### 7.2 Limits

- Max transfers: 4 concurrent
- Bandwidth: configurable
- Retry: 3 attempts

---

## 8. Integration Points

### 8.1 Dolphin

- Places panel entry
- Context menu actions
- Status overlay emblems

### 8.2 D-Bus Interface

```
org.sanchala.cloud
├── GetStatus() → dict
├── Sync(account) → bool
├── GetFileStatus(path) → string
└── Signals: SyncStarted, SyncComplete, Error
```

---

**Version:** 1.0 | **Status:** Approved

# 🖥️ Sanchala Backup GUI - Specification

## Overview

Qt6/QML-based graphical interface for sanchala-backup with Time Machine-inspired UX.

---

## 🏗️ Architecture

```
┌──────────────────────────────────────────────────────────┐
│                 SANCHALA BACKUP GUI                       │
├──────────────────────────────────────────────────────────┤
│  ┌─────────────────────────────────────────────────────┐ │
│  │                  QML Frontend                        │ │
│  │  [Timeline] [Restore] [Cloud] [Settings]            │ │
│  └─────────────────────────────────────────────────────┘ │
│                          │                               │
│  ┌─────────────────────────────────────────────────────┐ │
│  │    C++ Backend (SnapshotModel, D-Bus Client)        │ │
│  └─────────────────────────────────────────────────────┘ │
│                          │                               │
│  ┌─────────────────────────────────────────────────────┐ │
│  │           sanchala-backupd (D-Bus)                  │ │
│  └─────────────────────────────────────────────────────┘ │
└──────────────────────────────────────────────────────────┘
```

---

## 📱 Views

### 1. Timeline View
- Visual calendar with snapshot markers
- Date/time axis navigation
- Snapshot details on selection
- Quick actions: Browse, Restore, Delete

### 2. Restore View  
- Split view: snapshot vs current files
- Diff highlighting for changes
- Search and filter
- Drag-and-drop restore

### 3. Cloud View
- Provider setup wizard
- Sync status and progress
- Storage quota display

### 4. Settings View
- Retention configuration
- Schedule settings
- Exclusion patterns

---

## 🔌 D-Bus Interface

**Service:** `id.sanchala.Backup`

**Methods:**
- `ListSnapshots() → json`
- `CreateSnapshot(description) → id`
- `DeleteSnapshot(id) → success`
- `RestoreFile(snapshot_id, path) → success`
- `ScheduleRollback(snapshot_id) → success`

**Signals:**
- `SnapshotCreated(id, type)`
- `BackupProgress(percent, status)`

---

## 📁 Files

```
/usr/share/sanchala/backup/qml/
├── main.qml
├── TimelineView.qml
├── RestoreView.qml
└── components/
/usr/bin/sanchala-backup-gui
/usr/share/applications/sanchala-backup.desktop
```

---

## ⌨️ Shortcuts

| Key | Action |
|-----|--------|
| `Ctrl+N` | New snapshot |
| `Ctrl+R` | Restore |
| `Ctrl+B` | Browse |
| `Del` | Delete |
| `Ctrl+,` | Settings |

# Sanchala Backup - Snapshot Manager

## Overview

**sanchala-backup** provides automated system snapshots and backup management for Sanchala OS, leveraging Btrfs snapshots with a Time Machine-inspired user experience.

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                     SANCHALA BACKUP                              │
├─────────────────────────────────────────────────────────────────┤
│  ┌─────────────────────────────────────────────────────────┐    │
│  │                  Qt/QML Frontend                         │    │
│  │  ┌────────┐ ┌────────┐ ┌────────┐ ┌────────┐           │    │
│  │  │Timeline│ │Restore │ │Settings│ │ Browse │           │    │
│  │  └────────┘ └────────┘ └────────┘ └────────┘           │    │
│  └─────────────────────────────────────────────────────────┘    │
│                              │                                   │
│                    ┌─────────┴─────────┐                        │
│                    │   Rust Backend    │                        │
│                    │(sanchala-backupd) │                        │
│                    └─────────┬─────────┘                        │
│                              │                                   │
│         ┌────────────────────┼────────────────────┐             │
│         ▼                    ▼                    ▼             │
│  ┌────────────┐      ┌────────────┐      ┌────────────┐        │
│  │   Btrfs    │      │  Snapper   │      │   Restic   │        │
│  │ Snapshots  │      │ Integration│      │  (Remote)  │        │
│  └────────────┘      └────────────┘      └────────────┘        │
└─────────────────────────────────────────────────────────────────┘
```

## Features

### Local Snapshots (Btrfs)
- Automatic pre/post package operation snapshots
- Scheduled hourly/daily/weekly snapshots
- Boot snapshot integration (GRUB)
- Instant rollback capability

### Timeline Browser
- Visual timeline of all snapshots
- Preview files at any point in time
- Side-by-side comparison
- Selective file restore

### Remote Backup
- Encrypted backup to external drives
- Cloud backup (optional): S3, B2, etc.
- Incremental and deduplicated
- Scheduled automatic backup

### Recovery Options
- Boot into previous snapshot (GRUB)
- Restore individual files
- Full system rollback
- Emergency recovery mode

## Snapshot Types

| Type | Trigger | Retention |
|------|---------|-----------|
| `pre` | Before pacman operation | 10 |
| `post` | After pacman operation | 10 |
| `hourly` | Scheduled | 24 |
| `daily` | Scheduled | 7 |
| `weekly` | Scheduled | 4 |
| `monthly` | Scheduled | 12 |
| `manual` | User-created | unlimited |

## CLI Interface

```bash
# List snapshots
sanchala-backup list

# Create manual snapshot
sanchala-backup snapshot --description "Before experiment"

# Restore file from snapshot
sanchala-backup restore --snapshot 42 --path /etc/fstab

# Full system rollback (requires reboot)
sanchala-backup rollback --snapshot 42

# Browse snapshot contents
sanchala-backup browse --snapshot 42

# Configure remote backup
sanchala-backup remote add --type=restic --target=/mnt/backup

# Run remote backup now
sanchala-backup remote run
```

## D-Bus Interface

**Bus Name:** `id.sanchala.Backup`

### Methods
- `ListSnapshots() -> (s)` - List all snapshots as JSON
- `CreateSnapshot(description: s) -> (i)` - Create snapshot, return ID
- `DeleteSnapshot(id: i) -> (b)` - Delete snapshot
- `RestoreFile(snapshot_id: i, path: s) -> (b)` - Restore single file
- `ScheduleRollback(snapshot_id: i) -> (b)` - Schedule rollback on reboot
- `GetBackupStatus() -> (s)` - Remote backup status

### Signals
- `SnapshotCreated(id: i, type: s)`
- `BackupProgress(percent: i, status: s)`
- `BackupComplete(success: b)`


## Configuration

```toml
# /etc/sanchala/backup.toml

[snapshots]
enabled = true
timeline = true
cleanup_algorithm = "timeline"

[snapshots.retention]
hourly = 24
daily = 7
weekly = 4
monthly = 12

[pacman]
pre_snapshot = true
post_snapshot = true

[remote]
enabled = false
schedule = "daily"
time = "02:00"

[remote.target]
type = "restic"  # or "borg", "rclone"
repository = ""
password_file = "/etc/sanchala/backup-password"

[exclude]
paths = [
    "/var/cache",
    "/var/tmp",
    "/home/*/.cache",
]
```

## File Locations

| File | Purpose |
|------|---------|
| `/etc/sanchala/backup.toml` | Configuration |
| `/.snapshots/` | Btrfs snapshot storage |
| `/var/lib/sanchala/backup/` | Backup metadata |
| `/usr/share/sanchala/backup/` | QML/assets |

## Integration Points

- **Snapper**: Backend for Btrfs snapshots
- **GRUB**: Boot menu snapshot integration
- **Pacman hooks**: Pre/post transaction snapshots
- **systemd timers**: Scheduled operations
- **KDE Plasma**: System tray status

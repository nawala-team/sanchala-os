# 📦 SANCHALA OS - Backup & Recovery Documentation

## Overview

Sanchala OS provides enterprise-grade backup and disaster recovery through Btrfs snapshots, automatic system protection, and flexible cloud backup options.

---

## 📚 Documents

| Document | Description |
|----------|-------------|
| [BACKUP-GUIDE.md](BACKUP-GUIDE.md) | User guide for sanchala-backup |
| [RECOVERY-MODE.md](RECOVERY-MODE.md) | System recovery procedures |
| [CLOUD-BACKUP.md](CLOUD-BACKUP.md) | Cloud backup with rclone |
| [GRUB-SNAPSHOTS.md](GRUB-SNAPSHOTS.md) | Boot from snapshots |

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                  SANCHALA BACKUP SYSTEM                         │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │                    sanchala-backup CLI                    │   │
│  │   list │ create │ restore │ rollback │ cloud │ remote    │   │
│  └────────────────────────┬─────────────────────────────────┘   │
│                           │                                      │
│         ┌─────────────────┼─────────────────┐                   │
│         ▼                 ▼                 ▼                   │
│  ┌────────────┐   ┌────────────┐   ┌────────────┐              │
│  │  Snapper   │   │   Restic   │   │   Rclone   │              │
│  │ (Btrfs)    │   │  (Remote)  │   │  (Cloud)   │              │
│  └─────┬──────┘   └─────┬──────┘   └─────┬──────┘              │
│        │                │                │                      │
│        ▼                ▼                ▼                      │
│  ┌──────────┐    ┌──────────┐    ┌──────────┐                  │
│  │/.snapshots│    │ External │    │  Cloud   │                  │
│  │ (Local)  │    │  Drive   │    │ Storage  │                  │
│  └──────────┘    └──────────┘    └──────────┘                  │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🎯 Key Features

- **Automatic Snapshots** - Pre/post package operations
- **Timeline Snapshots** - Hourly, daily, weekly, monthly
- **GRUB Integration** - Boot from any snapshot
- **File Recovery** - Restore individual files
- **System Rollback** - Full system restore
- **Cloud Backup** - Google Drive, Dropbox, S3, etc.
- **Incremental Backup** - Space-efficient with restic

---

## 📁 Related Files

```
/tools/sanchala-backup/           # CLI tool
/settings/etc/sanchala/backup.toml    # Configuration
/settings/etc/snapper/            # Snapper configs
/settings/etc/pacman.d/hooks/     # Auto-snapshot hooks
/settings/etc/default/grub-btrfs/ # GRUB snapshot config
```

---

**Part of SANCHALA OS Documentation**

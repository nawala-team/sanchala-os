# 📖 Sanchala Backup - User Guide

## Overview

`sanchala-backup` is a Time Machine-like backup tool that provides seamless snapshot management, file recovery, and cloud backup for Sanchala OS.

---

## 🚀 Quick Start

### View Snapshots
```bash
# List all root snapshots
sanchala-backup list

# List home snapshots
sanchala-backup list -c home

# JSON output (for scripts)
sanchala-backup list --json
```

### Create Snapshot
```bash
# Create with description
sanchala-backup create "Before config change"

# Create home snapshot
sanchala-backup create -c home "Pre-cleanup"
```

### Restore Files
```bash
# Restore single file from snapshot #42
sudo sanchala-backup restore 42 /etc/fstab

# Restore entire directory
sudo sanchala-backup restore 42 /etc/nginx/
```

### System Rollback
```bash
# Rollback to snapshot #35 (requires reboot)
sudo sanchala-backup rollback 35
```

---

## 📸 Automatic Snapshots

Sanchala OS creates snapshots automatically:

| Trigger | Description | Retention |
|---------|-------------|-----------|
| Package install/upgrade | Before and after pacman operations | 10 pairs |
| Hourly timer | Timeline snapshots | 5 |
| Daily timer | Timeline snapshots | 7 |
| Weekly timer | Timeline snapshots | 4 |
| Monthly timer | Timeline snapshots | 6 |

### Enable/Disable
```bash
# Enable automatic snapshots
sanchala-backup schedule enable

# Disable
sanchala-backup schedule disable

# Check status
sanchala-backup schedule
```

---

## 🔍 Browse & Compare

### Browse Snapshot Contents
```bash
# Browse snapshot #42
sanchala-backup browse 42

# Browse specific path
sanchala-backup browse 42 /etc/
```

### Compare Snapshots
```bash
# See what changed between snapshot 40 and 42
sanchala-backup compare 40 42
```

---

## 🔄 Recovery Options

### 1. File Restore (Running System)
Restore individual files without rebooting:
```bash
sudo sanchala-backup restore 42 /path/to/file
```

### 2. GRUB Boot Menu
Boot directly into a snapshot from GRUB:
1. Reboot system
2. Select "Sanchala OS Snapshots" submenu
3. Choose snapshot to boot

### 3. Full Rollback
Complete system restore:
```bash
sudo sanchala-backup rollback 42
sudo reboot
```

### 4. Recovery Mode
Boot from USB and restore. See [RECOVERY-MODE.md](RECOVERY-MODE.md)

---

## 🧹 Maintenance

### Cleanup Old Snapshots
```bash
# Automatic cleanup (respects retention policy)
sudo sanchala-backup cleanup

# Dry run first
sudo sanchala-backup cleanup --dry-run

# Manual delete
sudo sanchala-backup delete 42
```

### Verify Integrity
```bash
sanchala-backup verify
```

### Check Status
```bash
sanchala-backup status
```

---

## ⚙️ Configuration

Edit `/etc/sanchala/backup.toml`:

```toml
[snapshots.retention]
hourly = 5
daily = 7
weekly = 4
monthly = 6

[pacman]
pre_snapshot = true
post_snapshot = true
```

---

## 📋 Command Reference

| Command | Description |
|---------|-------------|
| `list` | List snapshots |
| `create [desc]` | Create snapshot |
| `delete <id>` | Delete snapshot |
| `info <id>` | Show details |
| `compare <a> <b>` | Diff two snapshots |
| `browse <id>` | Browse contents |
| `restore <id> <path>` | Restore file/dir |
| `rollback <id>` | Full system rollback |
| `status` | System status |
| `cleanup` | Remove old snapshots |
| `verify` | Check integrity |

---

**See Also:**
- [CLOUD-BACKUP.md](CLOUD-BACKUP.md) - Cloud backup setup
- [RECOVERY-MODE.md](RECOVERY-MODE.md) - Disaster recovery

# 📸 SANCHALA OS - Snapper Snapshot Management

## Overview

Sanchala OS uses Snapper for automated Btrfs snapshot management, enabling easy system recovery and rollback capabilities.

---

## 🎯 Snapshot Strategy

| Config | Subvolume | Purpose | Retention |
|--------|-----------|---------|-----------|
| `root` | `@` | System recovery | 5 hourly, 7 daily, 4 weekly, 6 monthly |
| `home` | `@home` | User data protection | 7 daily, 4 weekly, 12 monthly, 5 yearly |

---

## 🔧 Configuration Files

```
/etc/snapper/
├── snapper.conf           # Global configuration
├── configs/
│   ├── root               # Root subvolume config
│   └── home               # Home subvolume config
└── templates/
    └── default            # Template for new configs
```

---

## 📋 Automatic Snapshots

### Timeline Snapshots
Created automatically by `snapper-timeline.timer`:
- **Hourly** - Every hour (root only)
- **Daily** - Once per day
- **Weekly** - Once per week
- **Monthly** - Once per month
- **Yearly** - Once per year (home only)

### Package Manager Snapshots
Pre/post snapshots created during system updates:
```bash
# Automatic with pacman hook
sudo pacman -Syu
# Creates: pre-update snapshot → updates → post-update snapshot
```

### Boot Snapshots
Created at each boot by `snapper-boot.timer`.

---

## 🛠️ Common Commands

```bash
# List all snapshots
sudo snapper -c root list
sudo snapper -c home list

# Create manual snapshot
sudo snapper -c root create --description "Before config change"

# Create pre/post pair
sudo snapper -c root create --type pre --description "Manual change"
# Make changes...
sudo snapper -c root create --type post --pre-number <N>

# Compare snapshots
sudo snapper -c root diff 1..2

# Restore single file from snapshot
sudo snapper -c root undochange 1..0 /etc/fstab

# Rollback entire system
sudo snapper -c root rollback <snapshot_number>
sudo reboot

# Delete snapshot
sudo snapper -c root delete <number>

# Cleanup old snapshots manually
sudo snapper -c root cleanup timeline
```

---

## 🔄 GRUB Integration

Sanchala OS includes `grub-btrfs` for boot menu integration:

```
Sanchala OS
Sanchala OS (Snapshot 42 - 2026-08-06)
Sanchala OS (Snapshot 41 - 2026-08-05)
...
```

### Enable GRUB snapshots
```bash
sudo systemctl enable --now grub-btrfsd
```

---

## 📊 Storage Management

```bash
# Check snapshot space usage
sudo btrfs filesystem usage /

# Show snapshot sizes (approximate)
sudo snapper -c root list --columns number,date,used-space,description

# Set space limits (in config)
SPACE_LIMIT="0.5"   # Max 50% of filesystem for snapshots
FREE_LIMIT="0.2"    # Keep 20% filesystem free
```

---

## ⚠️ Important Notes

1. **Snapshots ≠ Backups** - Store on same disk, not disaster recovery
2. **Monitor space** - Snapshots can fill disk if unchecked
3. **Exclude from snapshots**: @log, @cache, @flatpak, @swap
4. **Test rollback** - Practice before emergency

---

**Document Version:** 1.0  
**Last Updated:** August 2026  
**Author:** Storage Systems Engineering Team

# 🔄 SANCHALA OS - Rollback Guide

## Overview

Sanchala OS uses Btrfs snapshots for instant system rollback. Every update creates a snapshot, allowing you to restore the system to any previous state.

---

## 🚨 Emergency Rollback (System Won't Boot)

### From GRUB Menu

1. **Reboot** and hold **Shift** or press **Esc** to access GRUB
2. Select **"Sanchala OS Snapshots"** submenu
3. Choose a working snapshot (e.g., before the problematic update)
4. System boots into that snapshot (read-only)
5. Once booted, make it permanent:
   ```bash
   sudo snapper -c root rollback
   sudo reboot
   ```

---

## 🛠️ Standard Rollback

### Step 1: List Available Snapshots

```bash
sudo sanchala-updater rollback

# Or use snapper directly:
sudo snapper -c root list
```

Example output:
```
 # │ Type   │ Pre # │ Date                │ Description
───┼────────┼───────┼─────────────────────┼─────────────────────────
 1 │ single │       │ 2026-08-01 10:00:00 │ Initial install
42 │ pre    │       │ 2026-08-06 14:29:00 │ System update
43 │ post   │    42 │ 2026-08-06 14:35:00 │ System update completed
44 │ pre    │       │ 2026-08-06 16:00:00 │ Installed new package
45 │ post   │    44 │ 2026-08-06 16:02:00 │ Package installation done
```

### Step 2: Choose Rollback Target

- **Pre-update snapshots** (type: `pre`) - State before changes
- **Post-update snapshots** (type: `post`) - State after changes
- Generally, rollback to the **pre** snapshot before the problematic change

### Step 3: Perform Rollback

```bash
# Rollback to snapshot 42 (before problematic update)
sudo sanchala-updater rollback 42

# Or with snapper:
sudo snapper -c root rollback 42
```

### Step 4: Reboot

```bash
sudo systemctl reboot
```

---

## 🔍 Compare Snapshots

Before rolling back, see what changed:

```bash
# Compare snapshot 42 to current state
sudo snapper -c root diff 42..0

# Compare two snapshots
sudo snapper -c root diff 42..43

# Show only changed files
sudo snapper -c root status 42..43
```

---

## 📄 Restore Single Files

Don't need full rollback? Restore specific files:

```bash
# Restore /etc/fstab from snapshot 42
sudo snapper -c root undochange 42..0 /etc/fstab

# Restore multiple files
sudo snapper -c root undochange 42..0 /etc/pacman.conf /etc/mkinitcpio.conf
```

---

## 💾 What Gets Rolled Back

### Included in Rollback (@ subvolume)
- `/usr` - System binaries and libraries
- `/etc` - System configuration
- `/opt` - Third-party applications  
- `/root` - Root user home
- `/var` (except excluded below)

### Preserved During Rollback
- `/home` - User data (@home subvolume)
- `/var/log` - System logs (@log)
- `/var/cache` - Cache files (@cache)
- `/var/lib/flatpak` - Flatpak apps (@flatpak)

---

## ⚠️ Important Considerations

### Before Rollback
1. **Backup important data** in `/home` if unsure
2. **Note current running services** that may need restart
3. **Check if databases** need special handling

### After Rollback
1. **Reboot is required** to complete rollback
2. **Re-apply any needed config changes** made after snapshot
3. **Check service status** after reboot

### Database Considerations
If you have running databases (PostgreSQL, MariaDB):
```bash
# Before rollback, dump database
sudo -u postgres pg_dumpall > /home/user/db_backup.sql

# After rollback, restore if needed
sudo -u postgres psql < /home/user/db_backup.sql
```

---

## 🔧 Advanced: Manual Btrfs Rollback

If snapper isn't working:

```bash
# Mount the Btrfs root
sudo mount /dev/mapper/root /mnt -o subvolid=5

# List subvolumes
sudo btrfs subvolume list /mnt

# Rename current root
sudo mv /mnt/@ /mnt/@.broken

# Create snapshot of working state as new root
sudo btrfs subvolume snapshot /mnt/@snapshots/42/snapshot /mnt/@

# Reboot
sudo reboot
```

---

## 📊 Snapshot Retention

Default retention policy:
- **5 hourly** snapshots
- **7 daily** snapshots
- **4 weekly** snapshots
- **6 monthly** snapshots

Older snapshots are automatically cleaned by snapper.

---

**Document Version:** 1.0  
**Last Updated:** August 2026

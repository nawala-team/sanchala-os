# 🔄 Sanchala OS - GRUB Snapshot Boot

## Overview

Sanchala OS integrates grub-btrfs to provide bootable snapshots directly from the GRUB menu, enabling instant system recovery without a live USB.

---

## 🎯 How It Works

```
┌─────────────────────────────────────────────────────────────┐
│                      GRUB BOOT MENU                          │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│   Sanchala OS                              ◄── Default       │
│   Sanchala OS (fallback initramfs)                          │
│   Sanchala OS Snapshots                    ◄── Submenu       │
│      ├── 2026-08-06 14:00 | Snapshot 42                     │
│      ├── 2026-08-06 12:00 | Snapshot 41 (pacman post)       │
│      ├── 2026-08-06 11:55 | Snapshot 40 (pacman pre)        │
│      └── 2026-08-05 18:00 | Snapshot 38                     │
│   UEFI Firmware Settings                                     │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

When you boot a snapshot:
1. System mounts the snapshot subvolume as read-only root
2. You can inspect the system state at that point
3. Make the rollback permanent with `snapper rollback`

---

## ⚙️ Configuration

### Config File: `/etc/default/grub-btrfs/config`

```bash
# Snapshot directory
GRUB_BTRFS_SNAPSHOT_DIR="/.snapshots"

# Max snapshots in GRUB menu
GRUB_BTRFS_LIMIT="10"

# Submenu name
GRUB_BTRFS_SUBMENU_NAME="Sanchala OS Snapshots"

# Title format
GRUB_BTRFS_TITLE_FORMAT="%Y-%m-%d %H:%M | Snapshot %1"

# Include snapshot types
GRUB_BTRFS_SNAPSHOT_TYPES="pre post single"
```

---

## 🛠️ Setup & Management

### Enable GRUB Snapshots
```bash
# Install grub-btrfs (pre-installed on Sanchala)
sudo pacman -S grub-btrfs

# Enable daemon (auto-updates GRUB on new snapshots)
sudo systemctl enable --now grub-btrfsd
```

### Manual GRUB Update
```bash
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

### Check Service Status
```bash
systemctl status grub-btrfsd
```

---

## 🔄 Boot & Rollback Workflow

### 1. Boot into Snapshot
- Reboot system
- Select "Sanchala OS Snapshots" in GRUB
- Choose desired snapshot
- System boots read-only

### 2. Verify System State
```bash
# Check current snapshot
cat /etc/os-release
pacman -Q | head

# Compare with current
snapper -c root diff 42..0
```

### 3. Make Rollback Permanent
```bash
# If this snapshot is good, make it the new default
sudo snapper -c root rollback

# Reboot to complete
sudo reboot
```

### 4. Or Just Reboot
If you just wanted to check something, simply reboot and the system returns to normal.

---

## 🔧 Troubleshooting

### Snapshots Not Appearing in GRUB

```bash
# Check if snapshots exist
ls -la /.snapshots/

# Check grub-btrfsd status
systemctl status grub-btrfsd
journalctl -u grub-btrfsd

# Manually regenerate
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

### Snapshot Won't Boot

Common causes:
- Kernel/initramfs in snapshot incompatible with current hardware
- Missing boot files

Solution:
```bash
# Boot live USB
# Mount and regenerate initramfs
arch-chroot /mnt
mkinitcpio -P
```

### Too Many Snapshots in Menu

Edit `/etc/default/grub-btrfs/config`:
```bash
GRUB_BTRFS_LIMIT="5"
```

Then regenerate GRUB.

---

## 📋 Related Files

| File | Purpose |
|------|---------|
| `/etc/default/grub-btrfs/config` | grub-btrfs configuration |
| `/boot/grub/grub.cfg` | Generated GRUB config |
| `/.snapshots/` | Snapshot storage |
| `/etc/snapper/configs/root` | Snapper root config |

---

**See Also:**
- [BACKUP-GUIDE.md](BACKUP-GUIDE.md) - General backup guide
- [RECOVERY-MODE.md](RECOVERY-MODE.md) - Disaster recovery

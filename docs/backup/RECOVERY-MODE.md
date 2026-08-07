# 🚨 Sanchala OS - Recovery Mode Guide

## Overview

This guide covers disaster recovery procedures when the system won't boot or is severely compromised.

---

## 🔧 Recovery Options

### Option 1: GRUB Snapshot Boot (Easiest)

If GRUB is working:

1. Reboot and hold **Shift** or press **Esc** at boot
2. Select **"Sanchala OS Snapshots"**
3. Choose a working snapshot
4. Boot and make the rollback permanent:
   ```bash
   sudo snapper -c root rollback
   sudo reboot
   ```

---

### Option 2: Recovery from Live USB

1. Boot Sanchala OS installation USB
2. Select "Recovery Mode" from boot menu

#### Mount the System
```bash
# Decrypt if using LUKS
cryptsetup open /dev/nvme0n1p2 cryptroot

# Mount btrfs root
mount -o subvol=@ /dev/mapper/cryptroot /mnt
mount -o subvol=@home /dev/mapper/cryptroot /mnt/home
mount /dev/nvme0n1p1 /mnt/boot/efi

# Chroot into system
arch-chroot /mnt
```

#### Restore from Snapshot
```bash
# List available snapshots
snapper -c root list

# Rollback to snapshot
snapper -c root rollback 42

# Regenerate initramfs if needed
mkinitcpio -P

# Update GRUB
grub-mkconfig -o /boot/grub/grub.cfg

# Exit and reboot
exit
reboot
```

---

### Option 3: Manual Btrfs Restore

For manual subvolume manipulation:

```bash
# Mount top-level btrfs
mount /dev/mapper/cryptroot /mnt

# List subvolumes
btrfs subvolume list /mnt

# Current root is @, rename it
mv /mnt/@ /mnt/@.broken

# Copy snapshot to new root
btrfs subvolume snapshot /mnt/@.snapshots/42/snapshot /mnt/@

# Reboot
reboot
```

---

### Option 4: Restore from Remote Backup

If local snapshots are unavailable:

```bash
# Mount target
mount /dev/mapper/cryptroot /mnt

# Restore with restic
restic -r /path/to/backup restore latest --target /mnt

# Or specific snapshot
restic -r /path/to/backup snapshots
restic -r /path/to/backup restore abc123 --target /mnt
```

---

## 🔐 LUKS Recovery

### Forgot Password?
If you have recovery key:
```bash
cryptsetup open --key-file /path/to/recovery.key /dev/nvme0n1p2 cryptroot
```

### Add New Key Slot
```bash
cryptsetup luksAddKey /dev/nvme0n1p2
```

---

## 🛠️ Common Issues

### GRUB Not Showing Snapshots
```bash
# Regenerate GRUB config
grub-mkconfig -o /boot/grub/grub.cfg

# Ensure grub-btrfs is installed
pacman -S grub-btrfs
systemctl enable grub-btrfsd
```

### Boot Stuck at initramfs
```bash
# From live USB, chroot and rebuild
arch-chroot /mnt
mkinitcpio -P
```

### Snapshot Directory Missing
```bash
# Recreate snapshots subvolume
btrfs subvolume create /mnt/@snapshots
mkdir /mnt/@/.snapshots
```

---

## 📞 Emergency Contacts

- **Sanchala Support**: support@sanchala.id
- **Community Forum**: forum.sanchala.id
- **IRC**: #sanchala on Libera.Chat

---

## ✅ Prevention Checklist

- [ ] Regular cloud backups enabled
- [ ] External drive backup monthly
- [ ] Recovery USB created and tested
- [ ] LUKS recovery key stored safely
- [ ] Snapshot retention adequate

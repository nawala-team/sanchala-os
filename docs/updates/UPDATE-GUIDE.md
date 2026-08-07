# 📖 SANCHALA OS - Update Guide

## Quick Start

```bash
# Check for updates
sanchala-updater check

# Apply updates (creates snapshot automatically)
sudo sanchala-updater update

# If something breaks, rollback
sudo sanchala-updater rollback
```

---

## 🔍 Checking for Updates

```bash
# Check system packages
sanchala-updater check

# Example output:
# System updates available:
# linux 6.9.1-1 -> 6.9.2-1
# mesa 24.1.0-1 -> 24.1.1-1
# firefox 126.0-1 -> 127.0-1
```

---

## ⬆️ Applying Updates

### Standard Update (Recommended)

```bash
sudo sanchala-updater update
```

This will:
1. Create a pre-update Btrfs snapshot
2. Download packages (with delta support)
3. Apply updates
4. Create a post-update snapshot
5. Run post-update hooks
6. Notify if reboot is required

### Update Options

```bash
# Download only, don't install
sudo sanchala-updater update --download-only

# Skip snapshot creation (not recommended)
sudo sanchala-updater update --no-snapshot

# Force update without prompts
sudo sanchala-updater update --force
```

---

## 🔄 Rollback

### View Available Snapshots

```bash
sudo sanchala-updater rollback

# Output:
# Available snapshots for rollback:
#  # | Date                | Description
# ---+---------------------+-------------------------
# 42 | 2026-08-06 14:30:00 | System update completed
# 41 | 2026-08-06 14:29:00 | System update
# 40 | 2026-08-05 10:00:00 | Before config change
```

### Perform Rollback

```bash
# Rollback to specific snapshot
sudo sanchala-updater rollback 41

# Confirm and reboot
sudo systemctl reboot
```

### Emergency Rollback (GRUB)

If system won't boot:
1. Reboot and hold Shift to access GRUB
2. Select "Sanchala OS (Snapshot XX)"
3. Boot into working snapshot
4. Run `sudo sanchala-updater rollback XX --yes` to make permanent

---

## 📊 Status & History

```bash
# Check update system status
sanchala-updater status

# View update history
sanchala-updater history

# View last 20 updates
sanchala-updater history 20
```

---

## 🧹 Maintenance

```bash
# Clean old cached packages and deltas
sudo sanchala-updater clean
```

---

## ⚠️ Important Notes

1. **Always have a snapshot** - Don't use `--no-snapshot` unless testing
2. **Reboot when required** - Kernel updates need a reboot
3. **Monitor disk space** - Snapshots use space; clean regularly
4. **Test rollback** - Practice before you need it

---

**Document Version:** 1.0  
**Last Updated:** August 2026

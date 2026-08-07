# 🗂️ SANCHALA OS - Btrfs Subvolume Layout Specification

## Overview

Sanchala OS uses Btrfs as the default filesystem, leveraging its advanced features for snapshots, compression, and data integrity. This document specifies the official subvolume layout designed for reliability, recoverability, and optimal performance.

---

## 🎯 Design Goals

1. **Atomic Rollbacks** - System can be restored to any previous state
2. **Data Preservation** - User data survives system rollbacks
3. **Snapshot Efficiency** - Only changed data consumes space
4. **Compression** - Transparent zstd compression saves 30-50% disk space
5. **SSD Optimization** - Async discard and optimized mount options

---

## 📊 Subvolume Layout

```
Btrfs Filesystem (LUKS2 encrypted)
│
├── @ ──────────────────► /                    [ROOT - snapshotted]
├── @home ──────────────► /home                [USER DATA - separate snapshots]
├── @log ───────────────► /var/log             [LOGS - excluded from rollback]
├── @cache ─────────────► /var/cache           [CACHE - excluded from rollback]
├── @snapshots ─────────► /.snapshots          [SNAPSHOT STORAGE]
├── @swap ──────────────► /swap                [SWAP FILE - CoW disabled]
├── @flatpak ───────────► /var/lib/flatpak     [FLATPAK - separate management]
├── @containers ────────► /var/lib/containers  [CONTAINERS - optional]
└── @tmp ───────────────► /var/tmp             [PERSISTENT TMP]
```

---

## 📋 Subvolume Specifications

| Subvolume | Mount Point | Snapshot | CoW | Compression | Purpose |
|-----------|-------------|----------|-----|-------------|---------|
| `@` | `/` | ✅ Yes | ✅ Yes | zstd:3 | Root filesystem |
| `@home` | `/home` | ✅ Yes | ✅ Yes | zstd:3 | User data |
| `@log` | `/var/log` | ❌ No | ✅ Yes | zstd:3 | System logs |
| `@cache` | `/var/cache` | ❌ No | ✅ Yes | zstd:1 | Cache files |
| `@snapshots` | `/.snapshots` | ❌ No | ✅ Yes | zstd:3 | Snapshot storage |
| `@swap` | `/swap` | ❌ No | ❌ No | None | Swap file |
| `@flatpak` | `/var/lib/flatpak` | ❌ No | ✅ Yes | zstd:3 | Flatpak apps |
| `@containers` | `/var/lib/containers` | ❌ No | ✅ Yes | zstd:3 | Container images |
| `@tmp` | `/var/tmp` | ❌ No | ✅ Yes | zstd:1 | Persistent temp |

---

## 🔧 Mount Options

### Standard Mount Options
```bash
# Root (@)
subvol=/@,compress=zstd:3,noatime,space_cache=v2,discard=async,ssd

# Home (@home)
subvol=/@home,compress=zstd:3,noatime,space_cache=v2,discard=async,ssd

# Swap (@swap) - CoW disabled
subvol=/@swap,nodatacow,noatime,discard=async,ssd
```

### Mount Options Explained

| Option | Purpose | Impact |
|--------|---------|--------|
| `compress=zstd:3` | Transparent compression | 30-50% space savings |
| `noatime` | Don't update access times | Reduces SSD writes |
| `space_cache=v2` | Free space cache | Faster allocations |
| `discard=async` | Async TRIM for SSDs | Non-blocking performance |
| `ssd` | SSD optimizations | Better allocation patterns |
| `nodatacow` | Disable CoW (swap only) | Required for swap files |

---

## 🔄 Rollback Architecture

### What Gets Rolled Back (@ subvolume)
- `/usr` - System binaries and libraries
- `/etc` - System configuration
- `/opt` - Third-party applications
- `/root` - Root user data

### What Survives Rollback
- `/home` - All user data (@home)
- `/var/log` - System logs (@log)
- `/var/cache` - Cached data (@cache)
- `/var/lib/flatpak` - Installed Flatpak apps (@flatpak)

### Rollback Commands
```bash
# From GRUB: Select "Sanchala OS (Snapshot XX)"
# Or manually:
sudo snapper rollback <snapshot_number>
sudo reboot
```

---

## 📊 Disk Space Guidelines

| System Type | Root (@) | Home (@home) | Swap | Recommended Total |
|-------------|----------|--------------|------|-------------------|
| Minimal | 20 GB | 30 GB | RAM size | 64 GB |
| Standard | 40 GB | 100 GB | RAM size | 150 GB |
| Developer | 60 GB | 200 GB | RAM × 1.5 | 300 GB |
| Workstation | 80 GB | 500 GB+ | RAM × 2 | 500 GB+ |

---

## 🔍 Verification Commands

```bash
# List all subvolumes
sudo btrfs subvolume list /

# Check filesystem usage
sudo btrfs filesystem usage /

# Show compression ratio
sudo compsize /

# Verify mount options
mount | grep btrfs
```

---

## ⚠️ Important Notes

1. **Never use `autodefrag`** - Causes excessive writes on SSDs
2. **Keep 20% free space** - Btrfs needs room for metadata and CoW
3. **Regular scrubs** - Run `btrfs scrub` monthly for data integrity
4. **Monitor space** - Snapshots can consume space quickly
5. **Backup separately** - Snapshots are NOT backups (same disk)

---

**Document Version:** 1.0  
**Last Updated:** August 2026  
**Author:** Storage Systems Engineering Team

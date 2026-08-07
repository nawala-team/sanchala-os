# Sanchala Cleaner

Intelligent system maintenance tool providing macOS Optimize Storage-level cleanup for Sanchala OS.

## Overview

Sanchala Cleaner automates system maintenance tasks to keep your system running smoothly and efficiently. It provides both automatic scheduled cleanup and manual control over what gets cleaned.

## Key Features

| Feature | Description |
|---------|-------------|
| Smart Cleanup | Intelligent cleanup respecting configured rules |
| Package Cache | Automatic paccache integration (keeps last 2 versions) |
| Log Management | Journal vacuum and logrotate integration |
| User Caches | Browser, thumbnails, and application caches |
| Scheduled | Weekly automatic maintenance via systemd timer |
| Safe Defaults | Won't delete user data without explicit configuration |

## Quick Reference

```bash
# Check status
sanchala-cleaner status

# Analyze disk usage
sanchala-cleaner analyze

# Smart cleanup
sudo sanchala-cleaner clean

# Preview mode
sudo sanchala-cleaner clean --dry-run

# Deep cleanup
sudo sanchala-cleaner clean --all

# Enable automatic weekly cleanup
sudo sanchala-cleaner schedule enable
```

## What Gets Cleaned

### Automatic (Safe)
- Package cache (keeps 2 versions)
- Systemd journal (keeps 500MB)
- Thumbnail cache (>30 days old)
- Browser caches (>7 days old)
- Temporary files (>7 days old)

### With Confirmation
- Trash (>30 days old)
- Orphan packages

### Manual Only
- Downloads folder
- User data

## Configuration

Main config: `/etc/sanchala-cleaner/cleaner.conf`

| Setting | Default | Description |
|---------|---------|-------------|
| `PACKAGE_CACHE_KEEP` | 2 | Package versions to keep |
| `JOURNAL_MAX_SIZE` | 500M | Maximum journal size |
| `THUMBNAIL_MAX_AGE` | 30 | Days before thumbnail cleanup |
| `TRASH_MAX_AGE` | 30 | Days before trash cleanup |
| `BROWSER_CACHE_MAX_AGE` | 7 | Days before browser cache cleanup |

## Automatic Cleanup

Weekly cleanup runs Sunday at 3:00 AM via systemd timer:

```bash
# Enable
sudo sanchala-cleaner schedule enable

# Check status
systemctl status sanchala-cleaner.timer

# View logs
journalctl -u sanchala-cleaner.service
```

## Comparison with macOS Optimize Storage

| Feature | macOS | Sanchala Cleaner |
|---------|-------|------------------|
| Empty Trash | ✓ | ✓ |
| Remove Downloads | ✓ | ✓ (opt-in) |
| Clear Caches | ✓ | ✓ |
| Optimize Photos | ✓ | - |
| Offload Apps | ✓ | Orphan package removal |
| Storage Recommendations | ✓ | ✓ |

## Files

| Path | Purpose |
|------|---------|
| `/usr/bin/sanchala-cleaner` | Main executable |
| `/etc/sanchala-cleaner/cleaner.conf` | Configuration |
| `/etc/sanchala-cleaner/rules.d/` | Custom cleanup rules |
| `/var/log/sanchala/cleaner.log` | Log file |

## See Also

- [Maintenance Guide](../maintenance/README.md)
- [Log Rotation](../maintenance/log-rotation.md)
- [Storage Optimization](../maintenance/storage-optimization.md)
- [Source Code](../../tools/sanchala-cleaner/)

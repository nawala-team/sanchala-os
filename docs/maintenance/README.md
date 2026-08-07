# System Maintenance Guide

Comprehensive guide to maintaining Sanchala OS for optimal performance and storage efficiency.

## Overview

Sanchala OS includes automated maintenance tools inspired by macOS Optimize Storage, providing:

- Intelligent disk cleanup
- Automatic cache management
- Log rotation
- Package cache optimization
- Scheduled maintenance tasks

## Quick Maintenance

```bash
# Check system status
sanchala-cleaner status

# Run recommended cleanup
sudo sanchala-cleaner clean

# Analyze what's using disk space
sanchala-cleaner analyze
```

## Maintenance Components

### 1. Sanchala Cleaner

The primary maintenance tool for disk cleanup and optimization.

```bash
# Smart cleanup (recommended)
sudo sanchala-cleaner clean

# Deep cleanup with all options
sudo sanchala-cleaner clean --all

# Preview without deleting
sudo sanchala-cleaner clean --dry-run
```

[Full Documentation →](sanchala-cleaner.md)

### 2. Package Cache Management

Sanchala OS automatically manages package cache using `paccache`:

- **Automatic**: Hook runs after every pacman transaction
- **Retention**: Keeps last 2 versions of each package
- **Manual**: `sudo paccache -rk2`

Configuration in `/etc/pacman.d/hooks/paccache.hook`

### 3. Journal Log Management

Systemd journal is configured with sensible limits:

| Setting | Value |
|---------|-------|
| Maximum Size | 500 MB |
| Maximum Age | 30 days |
| Compression | Enabled |

Configuration: `/etc/systemd/journald.conf.d/sanchala.conf`

Manual cleanup:
```bash
# Reduce to 500MB
sudo journalctl --vacuum-size=500M

# Remove entries older than 30 days
sudo journalctl --vacuum-time=30d
```

### 4. Log Rotation

Application logs are rotated automatically via logrotate:

| Log Type | Rotation | Retention |
|----------|----------|-----------|
| Cleaner | Weekly | 4 weeks |
| Updater | Weekly | 4 weeks |
| Backup | Weekly | 8 weeks |
| Guardian | Daily | 14 days |

Configuration: `/etc/logrotate.d/sanchala`

### 5. Scheduled Maintenance

Weekly automatic maintenance via systemd timer:

```bash
# Enable automatic maintenance
sudo sanchala-cleaner schedule enable

# Check timer status
systemctl list-timers sanchala-cleaner.timer

# Run maintenance now
sudo systemctl start sanchala-cleaner.service
```

## Storage Analysis

### Check Disk Usage

```bash
# Overall filesystem usage
df -h

# Detailed analysis
sanchala-cleaner analyze

# Find large files
find / -type f -size +100M -exec ls -lh {} \; 2>/dev/null | sort -k5 -rh | head -20

# Find duplicate files
sanchala-cleaner duplicates /home
```

### Common Space Consumers

| Location | Description | Cleanup |
|----------|-------------|---------|
| `/var/cache/pacman/pkg` | Package cache | `paccache -rk2` |
| `/var/log/journal` | System logs | `journalctl --vacuum-size=500M` |
| `~/.cache` | User cache | `sanchala-cleaner browser` |
| `~/.local/share/Trash` | Trash | `sanchala-cleaner trash` |
| `/tmp`, `/var/tmp` | Temp files | `sanchala-cleaner temp` |

## Maintenance Schedule

### Automatic (Weekly)
- Package cache cleanup
- Journal vacuum
- Temporary file cleanup
- Log rotation

### Recommended Monthly
- Remove orphan packages: `sudo sanchala-cleaner orphans`
- Check for large files: `sanchala-cleaner analyze`
- Review storage usage

### As Needed
- Empty trash: `sanchala-cleaner trash`
- Clear browser cache: `sanchala-cleaner browser`
- Find duplicates: `sanchala-cleaner duplicates`

## Best Practices

1. **Enable automatic cleanup**: `sudo sanchala-cleaner schedule enable`
2. **Review before deep cleanup**: Use `--dry-run` first
3. **Keep backups**: Run `sanchala-backup create` before major cleanups
4. **Monitor disk usage**: Check `df -h` periodically
5. **Don't disable package cache completely**: Keep at least 1-2 versions for rollback

## Troubleshooting

### Disk Full

```bash
# Emergency cleanup
sudo journalctl --vacuum-size=100M
sudo paccache -rk1
sudo rm -rf /tmp/*
```

### Slow System After Cleanup

Some caches improve performance. If system feels slow after cleanup:
- Thumbnails will regenerate automatically
- Browser cache rebuilds on use
- Font cache: `fc-cache -fv`

### Package Cache Issues

If you need to reinstall a package and cache was cleaned:
```bash
# Redownload specific package
sudo pacman -Sw package-name
```

## See Also

- [Sanchala Cleaner](sanchala-cleaner.md) - Detailed cleaner documentation
- [Log Rotation](log-rotation.md) - Log management details
- [Storage Optimization](storage-optimization.md) - Advanced storage tips

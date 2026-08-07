# Sanchala Cleaner

Intelligent system maintenance tool providing macOS Optimize Storage-level cleanup for Sanchala OS.

## Features

- **Smart Cleanup**: Automatically cleans package cache, logs, thumbnails, and trash
- **Storage Optimization**: macOS-style storage management
- **Duplicate Detection**: Find and remove duplicate files
- **Scheduled Cleanup**: Automatic weekly maintenance via systemd timer
- **Safe Defaults**: Conservative settings that won't delete important data

## Quick Start

```bash
# View current status
sanchala-cleaner status

# Analyze disk usage
sanchala-cleaner analyze

# Run smart cleanup (recommended)
sudo sanchala-cleaner clean

# Preview cleanup without deleting
sudo sanchala-cleaner clean --dry-run

# Deep cleanup (includes orphan packages)
sudo sanchala-cleaner clean --all
```

## Commands

### Cleanup Commands

| Command | Description |
|---------|-------------|
| `clean` | Smart cleanup using configured rules |
| `clean --all` | Deep clean everything including orphans |
| `clean --quick` | Quick cleanup (caches only) |
| `packages` | Clean package cache (paccache) |
| `orphans` | Remove orphan packages |
| `journal` | Clean systemd journal logs |
| `thumbnails` | Clean thumbnail cache |
| `trash` | Empty user trash |
| `browser` | Clean browser caches |
| `temp` | Clean temporary files |

### Analysis Commands

| Command | Description |
|---------|-------------|
| `analyze` | Analyze disk usage |
| `duplicates [PATH]` | Find duplicate files |
| `status` | Show cleanup status |

### Schedule Commands

| Command | Description |
|---------|-------------|
| `schedule` | Show cleanup schedule |
| `schedule enable` | Enable weekly auto-cleanup |
| `schedule disable` | Disable auto-cleanup |

## Configuration

Edit `/etc/sanchala-cleaner/cleaner.conf`:

```bash
# Package cache - keep last 2 versions
CLEAN_PACKAGE_CACHE=true
PACKAGE_CACHE_KEEP=2

# Journal logs - max 500MB
CLEAN_JOURNAL=true
JOURNAL_MAX_SIZE="500M"

# Thumbnails older than 30 days
CLEAN_THUMBNAILS=true
THUMBNAIL_MAX_AGE=30

# Trash older than 30 days
CLEAN_TRASH=true
TRASH_MAX_AGE=30

# Browser cache older than 7 days
CLEAN_BROWSER_CACHE=true
BROWSER_CACHE_MAX_AGE=7

# Downloads cleanup (disabled by default)
CLEAN_DOWNLOADS=false
DOWNLOADS_MAX_AGE=90
```

## Automatic Cleanup

Sanchala OS includes automatic weekly cleanup via systemd timer:

```bash
# Enable automatic cleanup
sudo sanchala-cleaner schedule enable

# Check status
systemctl status sanchala-cleaner.timer

# View logs
journalctl -u sanchala-cleaner.service
```

## What Gets Cleaned

### Safe (always cleaned)
- Old package cache versions (keeps 2)
- Systemd journal (keeps 500MB)
- Thumbnail cache (>30 days)
- Browser caches (>7 days)
- Temporary files (>7 days)

### With Confirmation
- Trash (>30 days)
- Orphan packages

### Manual Only
- Downloads folder
- User data
- Application settings

## Comparison with macOS Optimize Storage

| Feature | macOS | Sanchala Cleaner |
|---------|-------|------------------|
| Empty Trash | ✓ | ✓ |
| Remove Downloads | ✓ | ✓ (opt-in) |
| Clear Caches | ✓ | ✓ |
| Optimize Photos | ✓ | - |
| Offload Apps | ✓ | Package orphan removal |
| iCloud Storage | ✓ | - |
| Storage Recommendations | ✓ | ✓ |

## Files

- `/usr/bin/sanchala-cleaner` - Main executable
- `/etc/sanchala-cleaner/cleaner.conf` - Configuration
- `/etc/sanchala-cleaner/rules.d/` - Custom cleanup rules
- `/var/lib/sanchala/cleaner/` - State data
- `/var/log/sanchala/cleaner.log` - Log file

## See Also

- `paccache(8)` - Pacman cache cleanup utility
- `journalctl(1)` - Systemd journal management
- `logrotate(8)` - Log rotation utility

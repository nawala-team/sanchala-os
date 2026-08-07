# Sanchala Cleaner

Intelligent system maintenance tool providing macOS Optimize Storage-level cleanup for Sanchala OS.

## Overview

Sanchala Cleaner provides automated and manual system maintenance with smart defaults that won't delete important data. Inspired by macOS Optimize Storage functionality.

## Features

- **Smart Cleanup**: Automatically cleans package cache, logs, thumbnails, and trash
- **Storage Optimization**: macOS-style storage management
- **Duplicate Detection**: Find and remove duplicate files
- **Scheduled Cleanup**: Automatic weekly maintenance via systemd timer
- **Safe Defaults**: Conservative settings that protect user data
- **Extensible Rules**: Custom cleanup rules in `rules.d/`

## Directory Structure

```
sanchala-cleaner/
├── sanchala-cleaner          # Main executable script
├── lib/
│   ├── cache.sh              # Cache management functions
│   ├── packages.sh           # Package management functions
│   ├── logs.sh               # Log management functions
│   └── system.sh             # System utility functions
├── rules.d/
│   ├── 10-package-cache.rules    # Package cache paths
│   ├── 20-user-cache.rules       # User cache paths
│   └── 30-temp-files.rules       # Temporary file paths
└── README.md                 # This file
```

## Installation

Files are installed to:

| Source | Destination |
|--------|-------------|
| `sanchala-cleaner` | `/usr/bin/sanchala-cleaner` |
| `lib/*` | `/usr/lib/sanchala-cleaner/` |
| `rules.d/*` | `/etc/sanchala-cleaner/rules.d/` |

Configuration: `/etc/sanchala-cleaner/cleaner.conf`

## Quick Start

```bash
# View system status
sanchala-cleaner status

# Analyze disk usage
sanchala-cleaner analyze

# Run smart cleanup
sudo sanchala-cleaner clean

# Preview without deleting
sudo sanchala-cleaner clean --dry-run

# Deep cleanup (includes orphans)
sudo sanchala-cleaner clean --all

# Enable weekly automatic cleanup
sudo sanchala-cleaner schedule enable
```

## Commands

### Cleanup
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

### Analysis
| Command | Description |
|---------|-------------|
| `analyze` | Analyze disk usage |
| `duplicates [PATH]` | Find duplicate files |
| `status` | Show cleanup status |

### Schedule
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

# Downloads cleanup (disabled for safety)
CLEAN_DOWNLOADS=false
DOWNLOADS_MAX_AGE=90
```

## Custom Rules

Add custom cleanup paths in `/etc/sanchala-cleaner/rules.d/`:

```bash
# Example: 50-custom.rules
# My custom cache directories
.cache/my-app
/var/cache/custom-service
```

## Systemd Integration

```bash
# Enable automatic weekly cleanup
sudo systemctl enable --now sanchala-cleaner.timer

# Check timer status
systemctl status sanchala-cleaner.timer

# View last cleanup log
journalctl -u sanchala-cleaner.service

# Run cleanup manually
sudo systemctl start sanchala-cleaner.service
```

## Related Files

- `/etc/pacman.d/hooks/paccache.hook` - Auto-cleanup after pacman transactions
- `/etc/logrotate.d/sanchala` - Log rotation configuration
- `/etc/systemd/journald.conf.d/sanchala.conf` - Journal size limits
- `/var/log/sanchala/cleaner.log` - Cleanup log file

## Dependencies

- `pacman-contrib` (provides paccache)
- `fdupes` (optional, for duplicate detection)

## Documentation

- [User Guide](../../docs/maintenance/sanchala-cleaner.md)
- [Maintenance Overview](../../docs/maintenance/README.md)
- [Log Rotation](../../docs/maintenance/log-rotation.md)
- [Storage Optimization](../../docs/maintenance/storage-optimization.md)

## License

GPL-3.0 - See [LICENSE](../../LICENSE)

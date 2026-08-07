# Storage Optimization Guide

Advanced techniques for optimizing storage on Sanchala OS, inspired by macOS Optimize Storage.

## Storage Analysis

### Quick Overview
```bash
# Filesystem usage
df -h /

# Detailed breakdown
sanchala-cleaner analyze

# Interactive disk usage (ncdu)
sudo pacman -S ncdu
ncdu /
```

### Find Large Files
```bash
# Files over 100MB
find / -type f -size +100M 2>/dev/null | head -20

# Largest directories
du -sh /* 2>/dev/null | sort -rh | head -15

# User home analysis
du -sh /home/*/* 2>/dev/null | sort -rh | head -20
```

## Optimization Strategies

### 1. Package Management

```bash
# Remove orphan packages
sudo pacman -Rns $(pacman -Qtdq)

# List packages by size
expac -H M '%m\t%n' | sort -rh | head -20

# Remove package completely (with config)
sudo pacman -Rns package-name
```

### 2. Cache Cleanup

| Cache | Location | Safe to Delete |
|-------|----------|----------------|
| Package cache | `/var/cache/pacman/pkg` | Keep 2 versions |
| User cache | `~/.cache` | Generally safe |
| Thumbnails | `~/.cache/thumbnails` | Safe |
| Font cache | `~/.cache/fontconfig` | Regenerates |

```bash
# Clean all caches at once
sudo sanchala-cleaner clean --all
```

### 3. Duplicate Files

```bash
# Install fdupes
sudo pacman -S fdupes

# Find duplicates
fdupes -r /home/user

# Find and prompt for deletion
fdupes -rd /home/user

# Using sanchala-cleaner
sanchala-cleaner duplicates /home
```

### 4. Old/Unused Files

```bash
# Files not accessed in 1 year
find /home -type f -atime +365 -size +10M 2>/dev/null

# Large files in Downloads
find ~/Downloads -type f -size +50M -mtime +30
```

### 5. Application Data

Common space consumers in home directory:

| Directory | Description | Action |
|-----------|-------------|--------|
| `~/.local/share/Trash` | Trash | Empty periodically |
| `~/.cache` | App caches | Safe to clean |
| `~/.local/share/baloo` | File indexer | Can rebuild |
| `~/snap` | Snap packages | Remove unused |
| `~/.wine` | Wine prefix | Remove if unused |
| `~/.steam` | Steam games | Manage in Steam |

## Automated Optimization

### Enable Weekly Cleanup
```bash
sudo sanchala-cleaner schedule enable
```

### Custom Cleanup Script
```bash
#!/bin/bash
# /usr/local/bin/weekly-cleanup.sh

# Package cache
paccache -rk2

# Journal
journalctl --vacuum-size=500M

# Old temp files
find /tmp -type f -atime +7 -delete 2>/dev/null

# User caches (thumbnails)
find /home/*/.cache/thumbnails -type f -atime +30 -delete 2>/dev/null
```

## Space-Saving Tips

### 1. Use Compression
```bash
# Compress old files
gzip large-file.log

# Transparent filesystem compression (btrfs)
# Already enabled on Sanchala OS
```

### 2. Symbolic Links for Large Directories
```bash
# Move large directory to bigger drive
mv ~/Videos /data/Videos
ln -s /data/Videos ~/Videos
```

### 3. Flatpak Cleanup
```bash
# Remove unused runtimes
flatpak uninstall --unused

# List installed size
flatpak list --columns=name,size
```

### 4. Docker Cleanup
```bash
# Remove unused containers, images, volumes
docker system prune -a

# Check Docker disk usage  
docker system df
```

## Monitoring

### Disk Usage Alerts
Sanchala Cleaner warns when disk usage exceeds 90%:

```bash
# Check threshold
grep STORAGE_THRESHOLD /etc/sanchala-cleaner/cleaner.conf

# Adjust threshold
sudo nano /etc/sanchala-cleaner/cleaner.conf
```

### Regular Checks
```bash
# Add to crontab for weekly report
0 9 * * 1 df -h / | mail -s "Disk Report" user@localhost
```

## Recovery Space Quickly

Emergency cleanup when disk is nearly full:

```bash
# 1. Clear package cache aggressively
sudo paccache -rk0  # Remove ALL cached packages

# 2. Minimize journal
sudo journalctl --vacuum-size=50M

# 3. Clear temp
sudo rm -rf /tmp/* /var/tmp/*

# 4. Empty all trash
rm -rf ~/.local/share/Trash/*

# 5. Clear user cache
rm -rf ~/.cache/*
```

⚠️ **Warning**: These are aggressive steps. Normal cleanup is preferred.

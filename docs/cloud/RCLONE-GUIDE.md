# 🔧 Rclone Configuration Guide

## Overview

Sanchala Cloud uses rclone as its sync backend. This guide covers advanced configuration for power users.

---

## Provider Setup

### Google Drive

```bash
sanchala-cloud add gdrive
```

For Team Drives:
```bash
rclone config
# Select 'drive', enable Team Drive option
# Enter Team Drive ID when prompted
```

### Dropbox

```bash
sanchala-cloud add dropbox
```

### OneDrive

```bash
sanchala-cloud add onedrive
```

For SharePoint:
```ini
[sharepoint]
type = onedrive
drive_type = documentLibrary
site_url = https://company.sharepoint.com/sites/MySite
```

### Nextcloud

```bash
sanchala-cloud add nextcloud
# Enter: https://your-server.com/remote.php/dav/files/USERNAME/
```

### Amazon S3

```bash
sanchala-cloud add s3
# Enter: access_key_id, secret_access_key, region
```

---

## Performance Tuning

### Large Files

```ini
chunk_size = 128M
upload_cutoff = 128M
```

### Slow Connections

```ini
transfers = 2
checkers = 4
low_level_retries = 10
```

### Fast Networks

```ini
transfers = 16
checkers = 32
buffer_size = 128M
```

---

## Encryption Setup

### Enable encryption for existing account

```bash
# Create encrypted overlay
rclone config create mycloud_crypt crypt \
  remote=mycloud:encrypted \
  filename_encryption=standard \
  directory_name_encryption=true

# Use encrypted remote
sanchala-cloud sync mycloud_crypt
```

---

## Filters

### Exclude patterns

Create `~/.config/sanchala-cloud/filters.txt`:

```
- .DS_Store
- Thumbs.db
- *.tmp
- ~*
- .git/**
- node_modules/**
```

---

## Troubleshooting

### Check connectivity

```bash
rclone lsd remote:
```

### Debug sync

```bash
rclone bisync remote: ~/Cloud/remote -v --dry-run
```

### Clear cache

```bash
rm -rf ~/.cache/rclone/
```

---

**See also:** [rclone.org/docs](https://rclone.org/docs/)

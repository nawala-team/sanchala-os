# macOS Migration Guide

Complete guide for migrating from macOS to Sanchala OS.

## Overview

Switching from macOS to Sanchala OS is straightforward. This guide covers migrating your documents, browser data, and settings. KDE Plasma offers a familiar desktop experience.

## Prerequisites

- macOS partition accessible (internal drive, Time Machine backup, or external disk)
- Sanchala OS installed and running
- Basic terminal knowledge

## Step 1: Access Your macOS Data

### Option A: Dual Boot (macOS on same computer)

```bash
# List available partitions
lsblk

# Find your macOS partition (APFS or HFS+)
sudo mkdir -p /mnt/macos

# For HFS+ (older macOS)
sudo mount -t hfsplus -o ro /dev/sdXY /mnt/macos

# For APFS (macOS 10.13+) - requires apfs-fuse
sudo apfs-fuse -o allow_other /dev/sdXY /mnt/macos
```

### Option B: Time Machine Backup

```bash
# Mount Time Machine drive
sudo mount /dev/sdXY /mnt/timemachine

# Navigate to latest backup
ls /mnt/timemachine/Backups.backupdb/YourMac/Latest/
```

### Option C: External Drive

```bash
# Usually auto-mounts to:
ls /media/$USER/

# Or mount manually
sudo mount /dev/sdXY /mnt/macos
```

### Installing APFS Support

```bash
# Install apfs-fuse from AUR
yay -S apfs-fuse

# Mount APFS partition
sudo apfs-fuse -o allow_other /dev/sdXY /mnt/macos
```

## Step 2: Detect and Analyze

```bash
# Detect macOS installation
sanchala-migrate detect

# Analyze what can be migrated
sanchala-migrate --source /mnt/macos analyze
```

Example output:
```
=== macOS Migration Analysis ===

OS: macOS 14.2
Source: /mnt/macos

User Profiles:
  • alex
    Documents: 3.2G
    Downloads: 1.4G
    Pictures: 8.7G

Browsers:
  • Safari (alex)
  • Chrome (alex)

Ready to migrate!
```

## Step 3: Run Migration

### Full Migration (Recommended)

```bash
sanchala-migrate --source /mnt/macos migrate
```

### Preview First (Dry Run)

```bash
sanchala-migrate --source /mnt/macos --dry-run migrate
```

### Selective Migration

```bash
# Documents only
sanchala-migrate --source /mnt/macos --include documents migrate

# Browser data only
sanchala-migrate --source /mnt/macos --include browser migrate
```

## Folder Mapping

| macOS Location | Sanchala OS Location |
|----------------|---------------------|
| `~/Documents` | `~/Documents` |
| `~/Downloads` | `~/Downloads` |
| `~/Pictures` | `~/Pictures` |
| `~/Music` | `~/Music` |
| `~/Movies` | `~/Videos` |
| `~/Desktop` | `~/Desktop` |
| `~/Library/Fonts` | `~/.local/share/fonts` |

## Browser Data

### Safari

Export from macOS before migration:

**Bookmarks:**
1. On macOS: Safari → File → Export Bookmarks
2. Save as HTML file
3. Import in Firefox: Bookmarks → Manage → Import from HTML

**Passwords:**
1. On macOS: System Settings → Passwords
2. Select all → Export (macOS 12+)
3. Import to KeePassXC or Firefox

### Chrome

```bash
# Automatic bookmark export
sanchala-migrate browser --chrome
# Bookmarks exported to ~/chrome-bookmarks.html
```

Or sign into Chrome with your Google account to sync.

### Firefox

```bash
# Automatic migration
sanchala-migrate browser --firefox

# Or copy profile manually
cp -r /mnt/macos/Users/YOU/Library/Application\ Support/Firefox/Profiles/*.default* \
    ~/.mozilla/firefox/
```

## Keyboard Remapping

| macOS | Sanchala OS | Action |
|-------|-------------|--------|
| ⌘+C | Ctrl+C | Copy |
| ⌘+V | Ctrl+V | Paste |
| ⌘+S | Ctrl+S | Save |
| ⌘+Q | Ctrl+Q / Alt+F4 | Quit |
| ⌘+Space | Meta | App launcher |
| ⌘+Tab | Alt+Tab | Switch apps |

**Tip:** Swap Ctrl and Alt for macOS-like feel in System Settings → Input Devices → Keyboard.

## Application Alternatives

| macOS App | Sanchala OS Alternative |
|-----------|------------------------|
| Finder | Dolphin |
| Preview | Okular, Gwenview |
| TextEdit | Kate |
| Pages/Numbers/Keynote | LibreOffice |
| Photos | digiKam, Shotwell |
| Music (iTunes) | Elisa, Strawberry |
| iMovie | Kdenlive |
| Terminal | Konsole |
| Safari | Firefox, Brave |
| Mail | Thunderbird |

See [App Mapping Guide](APP-MAPPING.md) for complete list.

## iCloud Data

Download iCloud data before migrating:

1. **iCloud Drive**: Download from iCloud.com
2. **Photos**: Export from Photos app
3. **Contacts/Calendar**: Export as vCard/ICS
4. **Notes**: Export as PDF or copy text

**Alternative:** Nextcloud (self-hosted iCloud replacement)

## Troubleshooting

### "APFS partition won't mount"

```bash
yay -S apfs-fuse
sudo apfs-fuse -o allow_other -v 1 /dev/sdXY /mnt/macos
```

### "HFS+ partition is journaled"

```bash
sudo mount -t hfsplus -o ro,force /dev/sdXY /mnt/macos
```

### "FileVault encrypted partition"

Decrypt on macOS first, or use recovery key with libfvde.

## Post-Migration Checklist

- [ ] Verify documents transferred
- [ ] Import browser bookmarks
- [ ] Install alternative applications
- [ ] Configure keyboard shortcuts
- [ ] Set up cloud sync
- [ ] Transfer email to Thunderbird

---

**Welcome to Sanchala OS!** Need help? Visit [forum.sanchala.id](https://forum.sanchala.id)

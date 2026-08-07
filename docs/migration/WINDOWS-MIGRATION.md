# Windows Migration Guide

Complete guide for migrating from Windows 10/11 to Sanchala OS.

## Overview

This guide covers migrating your documents, browser data, and settings from Windows to Sanchala OS. The process is straightforward and most data transfers automatically.

## Prerequisites

- Windows partition accessible (internal drive or external backup)
- Sanchala OS installed and running
- Basic terminal knowledge (copy-paste commands)

## Step 1: Access Your Windows Partition

### Option A: Dual Boot (Windows on same computer)

```bash
# List available partitions
lsblk

# Find your Windows partition (usually NTFS, largest partition)
# Mount it (replace sdXY with your partition, e.g., sda2)
sudo mkdir -p /mnt/windows
sudo mount -t ntfs3 /dev/sdXY /mnt/windows
```

### Option B: External Drive

```bash
# Plug in your external drive
# It should auto-mount, check:
ls /media/$USER/

# Or mount manually:
sudo mount /dev/sdXY /mnt/windows
```

## Step 2: Detect and Analyze

```bash
# Detect Windows installation
sanchala-migrate detect

# Analyze what can be migrated
sanchala-migrate --source /mnt/windows analyze
```

Example output:
```
=== Windows Migration Analysis ===

OS: Windows 11
Source: /mnt/windows

User Profiles:
  • John
    Documents: 2.4G
    Downloads: 856M
    Pictures: 4.2G
    Music: 1.1G
    Videos: 8.3G

Browsers:
  • Chrome (John)
  • Firefox (John)
  • Edge (John)

WiFi Networks: 5 saved networks

Ready to migrate!
```

## Step 3: Run Migration

### Full Migration (Recommended)

```bash
sanchala-migrate --source /mnt/windows migrate
```

### Preview First (Dry Run)

```bash
sanchala-migrate --source /mnt/windows --dry-run migrate
```

### Selective Migration

```bash
# Documents only
sanchala-migrate --source /mnt/windows --include documents migrate

# Browser data only
sanchala-migrate --source /mnt/windows --include browser migrate
```

## Folder Mapping

| Windows Location | Sanchala OS Location |
|-----------------|---------------------|
| `C:\Users\You\Documents` | `~/Documents` |
| `C:\Users\You\Downloads` | `~/Downloads` |
| `C:\Users\You\Pictures` | `~/Pictures` |
| `C:\Users\You\Music` | `~/Music` |
| `C:\Users\You\Videos` | `~/Videos` |
| `C:\Users\You\Desktop` | `~/Desktop` |

## Browser Data

### Chrome

Bookmarks are automatically exported. To import:

1. Open Chrome/Brave on Sanchala OS
2. Go to `chrome://bookmarks`
3. Click ⋮ → Import bookmarks
4. Select `~/chrome-bookmarks.html`

For passwords, export from Windows Chrome first:
1. On Windows: `chrome://settings/passwords`
2. Click ⋮ → Export passwords
3. Save CSV file
4. Import to Firefox/KeePassXC on Sanchala OS

### Firefox

Firefox profiles can be copied directly:

```bash
# Automatic bookmark export
sanchala-migrate browser --firefox

# Or copy entire profile
cp -r /mnt/windows/Users/YOU/AppData/Roaming/Mozilla/Firefox/Profiles/*.default* \
    ~/.mozilla/firefox/
```

### Microsoft Edge

Edge uses Chromium format. Export bookmarks from Edge:
1. Edge → Settings → Import browser data → Export to file
2. Import HTML file to your browser on Sanchala OS

## WiFi Networks

Windows WiFi passwords are encrypted. Sanchala Migrate shows saved networks, but you'll need to reconnect manually.

**Before leaving Windows**, note your WiFi passwords:
1. Settings → Network → WiFi → Manage known networks
2. Click network → View password (requires admin)

Or use Command Prompt (Admin):
```cmd
netsh wlan show profile name="YourNetwork" key=clear
```

## Keyboard Shortcuts

| Windows | Sanchala OS (KDE) | Action |
|---------|-------------------|--------|
| Win | Meta | Open launcher |
| Win+E | Meta+E | File manager |
| Win+D | Meta+D | Show desktop |
| Alt+Tab | Alt+Tab | Switch windows |
| Ctrl+C/V/X | Ctrl+C/V/X | Copy/Paste/Cut |
| Print Screen | Print Screen | Screenshot |
| Win+L | Meta+L | Lock screen |

## Application Alternatives

| Windows App | Sanchala OS Alternative |
|-------------|------------------------|
| Microsoft Office | LibreOffice |
| Notepad | Kate |
| Paint | Kolourpaint, GIMP |
| Windows Media Player | Elisa, VLC |
| File Explorer | Dolphin |
| Microsoft Edge | Firefox, Brave |

See [App Mapping Guide](APP-MAPPING.md) for complete list.

## Troubleshooting

### "NTFS partition not mounting"

```bash
# Install NTFS support
sudo pacman -S ntfs-3g

# Try ntfs-3g driver
sudo mount -t ntfs-3g /dev/sdXY /mnt/windows
```

### "Permission denied on Windows files"

```bash
# Mount with user permissions
sudo mount -t ntfs3 -o uid=$(id -u),gid=$(id -g) /dev/sdXY /mnt/windows
```

### "Windows is hibernated"

Windows Fast Startup locks the partition. On Windows:
1. Control Panel → Power Options → Choose what power buttons do
2. Disable "Turn on fast startup"
3. Shut down (not restart)

Or force mount read-only:
```bash
sudo mount -t ntfs3 -o ro /dev/sdXY /mnt/windows
```

## Post-Migration Checklist

- [ ] Verify documents transferred correctly
- [ ] Import browser bookmarks
- [ ] Reconnect WiFi networks
- [ ] Install alternative applications
- [ ] Set up email accounts
- [ ] Configure printers

## Next Steps

- [Browser Import Guide](BROWSER-IMPORT.md) — Detailed browser migration
- [App Mapping Guide](APP-MAPPING.md) — Find Linux alternatives
- [Getting Started with Sanchala OS](../user-guide/README.md)

---

**Need help?** Visit [forum.sanchala.id](https://forum.sanchala.id)

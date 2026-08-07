# Document Migration Guide

Complete guide for migrating documents, files, and folders from Windows or macOS to Sanchala OS.

## Overview

Sanchala Migrate automatically transfers your personal folders while preserving structure and handling platform-specific differences.

## Automatic Folder Mapping

### From Windows

| Windows Folder | Sanchala OS Folder |
|----------------|-------------------|
| `C:\Users\You\Documents` | `~/Documents` |
| `C:\Users\You\Downloads` | `~/Downloads` |
| `C:\Users\You\Pictures` | `~/Pictures` |
| `C:\Users\You\Music` | `~/Music` |
| `C:\Users\You\Videos` | `~/Videos` |
| `C:\Users\You\Desktop` | `~/Desktop` |

### From macOS

| macOS Folder | Sanchala OS Folder |
|--------------|-------------------|
| `~/Documents` | `~/Documents` |
| `~/Downloads` | `~/Downloads` |
| `~/Pictures` | `~/Pictures` |
| `~/Music` | `~/Music` |
| `~/Movies` | `~/Videos` |
| `~/Desktop` | `~/Desktop` |

## Quick Migration

```bash
# Migrate all documents
sanchala-migrate --source /mnt/old-os documents

# Preview first (dry run)
sanchala-migrate --source /mnt/old-os --dry-run documents

# Specific folders only
sanchala-migrate --source /mnt/old-os --folders "Documents,Pictures" documents
```

## File Format Compatibility

### Office Documents

| Format | Opens With | Notes |
|--------|-----------|-------|
| .docx | LibreOffice Writer | Full support |
| .xlsx | LibreOffice Calc | Full support |
| .pptx | LibreOffice Impress | Full support |
| .doc/.xls/.ppt | LibreOffice | Legacy formats |
| .odt/.ods/.odp | LibreOffice | Native format |
| .pdf | Okular | View and annotate |

### Images

| Format | Opens With | Notes |
|--------|-----------|-------|
| .jpg/.png/.gif | Gwenview | Native support |
| .psd | GIMP, Krita | Layer support |
| .heic | Gwenview | Install heif-pixbuf-loader |
| .raw | digiKam, darktable | Camera RAW |

### Media

| Format | Opens With | Notes |
|--------|-----------|-------|
| .mp3/.flac/.wav | Elisa, VLC | Full support |
| .mp4/.mkv/.avi | VLC, mpv | Full support |
| .m4a (iTunes) | VLC | AAC audio |

## Excluded Files

These files are automatically skipped:

### Windows
- `Thumbs.db` — Thumbnail cache
- `desktop.ini` — Folder settings
- `*.lnk` — Shortcuts (not portable)
- `*.tmp` — Temporary files

### macOS
- `.DS_Store` — Folder metadata
- `._*` — Resource forks
- `.Spotlight-*` — Search index
- `.Trashes` — Trash folder

## Custom Folder Migration

### Manual Copy

```bash
# Copy specific folder
rsync -av --progress /mnt/old-os/Users/You/Projects/ ~/Projects/

# Copy with exclusions
rsync -av --progress \
    --exclude='*.tmp' \
    --exclude='.DS_Store' \
    /mnt/old-os/path/ ~/destination/
```

### Large File Handling

For large media libraries:

```bash
# Resume interrupted transfers
rsync -av --progress --partial /source/ /dest/

# Bandwidth limit (10 MB/s)
rsync -av --progress --bwlimit=10000 /source/ /dest/
```

## Font Migration

### Automatic

```bash
sanchala-migrate --source /mnt/old-os fonts
# Installs to ~/.local/share/fonts/migrated/
```

### Manual

```bash
# Copy fonts
mkdir -p ~/.local/share/fonts/custom
cp /mnt/old-os/path/to/fonts/*.ttf ~/.local/share/fonts/custom/
cp /mnt/old-os/path/to/fonts/*.otf ~/.local/share/fonts/custom/

# Refresh font cache
fc-cache -fv
```

### Font Locations

| OS | System Fonts | User Fonts |
|----|--------------|------------|
| Windows | `C:\Windows\Fonts` | — |
| macOS | `/Library/Fonts` | `~/Library/Fonts` |
| Sanchala | `/usr/share/fonts` | `~/.local/share/fonts` |

## SSH Keys (Manual)

SSH keys require careful handling:

```bash
# Review keys on source
ls -la /mnt/old-os/Users/You/.ssh/

# Copy manually (after review)
cp /mnt/old-os/Users/You/.ssh/id_* ~/.ssh/
cp /mnt/old-os/Users/You/.ssh/config ~/.ssh/

# Fix permissions
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_*
chmod 644 ~/.ssh/*.pub
```

**Security note:** Consider generating new keys instead of migrating.

## Verify Migration

```bash
# Check transferred files
ls -la ~/Documents/

# Compare sizes
du -sh /mnt/old-os/Users/You/Documents/
du -sh ~/Documents/

# Verify integrity (if manifest created)
sanchala-migrate verify
```

## Troubleshooting

### "Permission denied"

```bash
# Mount with user permissions
sudo mount -o uid=$(id -u),gid=$(id -g) /dev/sdXY /mnt/old-os
```

### "File name too long"

Linux has 255-character filename limit. Rename long files:
```bash
# Find long filenames
find /mnt/old-os -name '*' | awk 'length($0) > 255'
```

### "Invalid characters in filename"

Windows allows characters Linux doesn't. Rename problematic files:
```bash
# Find files with problematic characters
find /mnt/old-os -name '*[:<>|?*]*'
```

### "Not enough space"

```bash
# Check available space
df -h ~

# Check source size
du -sh /mnt/old-os/Users/You/Documents/
```

## Post-Migration

1. **Verify files** — Spot-check important documents
2. **Update paths** — Recent files lists will need rebuilding
3. **Set default apps** — Right-click → Open With → Set as default
4. **Organize** — Use Dolphin tags and folders

---

**Next:** [Browser Import](BROWSER-IMPORT.md) | [App Mapping](APP-MAPPING.md)

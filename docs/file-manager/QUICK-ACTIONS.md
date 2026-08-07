# Quick Actions Reference

Complete list of right-click context menu actions available in Sanchala OS.

## Archive Operations

### Extract (extract.desktop)
- **Extract Here** - Extract archive contents to current folder
- **Extract To...** - Choose extraction destination

### Compress (compress.desktop)
- **Create ZIP Archive** - Standard ZIP format
- **Create TAR.GZ Archive** - Linux standard compressed
- **Create TAR.XZ Archive** - Best compression ratio
- **Create 7Z Archive** - 7-Zip format

## Image Operations (image-actions.desktop)

- **Rotate Left 90°** - Counter-clockwise rotation
- **Rotate Right 90°** - Clockwise rotation
- **Resize Image...** - Interactive resize dialog
- **Convert to PNG** - Lossless conversion
- **Convert to JPEG** - Web-optimized (90% quality)
- **Convert to WebP** - Modern format (85% quality)
- **Optimize for Web** - Resize max 1920px, strip metadata

## Video Operations (video-actions.desktop)

- **Convert to MP4 (H.264)** - Universal compatibility
- **Convert to WebM (VP9)** - Web optimized
- **Extract Audio (MP3)** - Audio track extraction
- **Trim Video...** - Cut video with start/end times
- **Create GIF** - 10-second animated GIF

## PDF Operations (pdf-actions.desktop)

- **Compress PDF** - Reduce file size
- **Merge with Another PDF...** - Combine documents
- **Split Pages...** - Extract page range
- **Convert to Images (PNG)** - Page-by-page export
- **Extract Text** - OCR-free text extraction

## Developer Tools

### Terminal (open-terminal.desktop)
- **Open Terminal Here** - Konsole in current directory
- **Open Terminal Here as Root** - Elevated terminal

### Git (git-actions.desktop)
- **Initialize Repository** - `git init`
- **Show Status** - `git status`
- **Pull Changes** - `git pull`
- **Commit Changes...** - Interactive commit
- **View Log** - Visual commit history

### Checksum (checksum.desktop)
- **Calculate MD5** - MD5 hash display
- **Calculate SHA-256** - SHA-256 hash
- **Calculate SHA-512** - SHA-512 hash
- **Verify Checksum...** - Compare against known hash

## File Organization

### Copy Info (copy-path.desktop)
- **Copy Full Path** - Absolute path to clipboard
- **Copy File Name** - Filename only
- **Copy Contents** - File contents (text files)

### Tags (file-tags.desktop)
- **⭐ Important** - Priority tag
- **💼 Work** - Work-related files
- **🏠 Personal** - Personal files
- **📦 Archive** - Archived items
- **Remove All Tags** - Clear file tags

### Permissions (permissions.desktop)
- **Take Ownership** - chown to current user
- **Set Standard File Permissions (644)** - rw-r--r--
- **Set Directory Permissions (755)** - rwxr-xr-x
- **Make Executable** - Add execute bit

### Share (share.desktop)
- **Send via Email** - Attach to email
- **Send to Phone (KDE Connect)** - Mobile transfer
- **Create QR Code** - Generate QR code

## Dependencies

These actions require certain tools to be installed:

| Action | Required Package |
|--------|-----------------|
| Image operations | imagemagick |
| Video operations | ffmpeg |
| PDF operations | ghostscript, poppler-utils |
| Git actions | git |
| Checksum | coreutils (built-in) |
| QR codes | qrencode |
| Archive | ark, p7zip |

## Creating Custom Actions

See `/usr/share/kio/servicemenus/` for examples.

Basic template:
```ini
[Desktop Entry]
Type=Service
ServiceTypes=KonqPopupMenu/Plugin
MimeType=<mime-types>
Actions=<action-name>

[Desktop Action <action-name>]
Name=Action Label
Icon=icon-name
Exec=command %F
```

### Variables
- `%f` - Single file path
- `%F` - Multiple file paths
- `%u` - Single URL
- `%U` - Multiple URLs
- `%d` - Directory path

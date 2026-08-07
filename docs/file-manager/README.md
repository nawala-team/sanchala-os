# Sanchala OS File Manager

> Finder-quality file management with Dolphin

## Overview

Sanchala OS provides a polished, macOS Finder-like file management experience built on KDE's Dolphin. The configuration includes smart folders, quick actions, rich previews, and intuitive keyboard shortcuts.

## Features

### Clean Interface
- Hidden menu bar (press F10 to show)
- Icon-only toolbar for minimal distraction
- Sidebar with favorites and smart folders
- Information panel for file details (F12)

### Smart Folders (Saved Searches)
Pre-configured smart folders in the sidebar:

| Smart Folder | Description |
|--------------|-------------|
| Today | Files modified today |
| Yesterday | Files from yesterday |
| This Month | Files from current month |
| All Images | Search all image files |
| All Videos | Search all video files |
| All Audio | Search all audio files |
| All Documents | Search all documents |
| Tagged: Important | Files tagged Important |
| Tagged: Work | Files tagged Work |
| Tagged: Personal | Files tagged Personal |

### Quick Actions (Right-Click Menu)

#### Archive Actions
- Extract Here
- Extract To...
- Create ZIP/TAR.GZ/TAR.XZ/7Z Archive

#### Image Actions
- Rotate Left/Right 90°
- Resize Image
- Convert to PNG/JPEG/WebP
- Optimize for Web

#### Video Actions
- Convert to MP4/WebM
- Extract Audio (MP3)
- Trim Video
- Create GIF

#### PDF Actions
- Compress PDF
- Merge PDFs
- Split Pages
- Convert to Images
- Extract Text

#### Developer Actions
- Open Terminal Here
- Git: Init/Status/Pull/Commit/Log
- Copy Full Path
- Copy File Name
- Calculate Checksums (MD5/SHA-256/SHA-512)

#### Organization
- Tags: Important/Work/Personal/Archive
- Share via Email/KDE Connect/QR Code

## Keyboard Shortcuts

### Navigation
| Shortcut | Action |
|----------|--------|
| `Alt+Left` | Go Back |
| `Alt+Right` | Go Forward |
| `Alt+Up` | Go Up |
| `Alt+Home` | Go Home |
| `Ctrl+L` | Edit Location |

### Views
| Shortcut | Action |
|----------|--------|
| `Ctrl+1` | Icons View |
| `Ctrl+2` | Compact View |
| `Ctrl+3` | Details View |
| `Ctrl+H` | Show/Hide Hidden Files |
| `F3` | Toggle Split View |
| `F4` | Toggle Terminal Panel |
| `F11` | Toggle Preview Panel |
| `F12` | Toggle Information Panel |

### File Operations
| Shortcut | Action |
|----------|--------|
| `Ctrl+Shift+N` | New Folder |
| `F2` | Rename |
| `Ctrl+Del` | Move to Trash |
| `Ctrl+C/X/V` | Copy/Cut/Paste |
| `Alt+Return` | Properties |

### Tabs
| Shortcut | Action |
|----------|--------|
| `Ctrl+T` | New Tab |
| `Ctrl+W` | Close Tab |
| `Ctrl+D` | Duplicate Tab |

## File Indexing (Baloo)

Privacy-conscious file indexing enables smart folders and fast search:

### Indexed Locations
- Home directory (excluding caches)
- External drives (when mounted)

### Excluded by Default
- `~/.cache`
- `~/.local/share/Trash`
- Browser profiles
- Package manager caches
- `/tmp`, `/var/cache`

### Search Syntax
```
filename:report          # Search by name
type:document           # Search by type
modified>=2024-01-01    # By date
tag:Important           # By tag
rating>=4               # By rating
```

## File Previews

Rich thumbnails for:
- Images (JPEG, PNG, GIF, WebP, SVG, RAW, HEIC)
- Videos (MP4, MKV, WebM, AVI)
- Documents (PDF, EPUB, Office formats)
- Audio (album art)
- Fonts
- Archives (contents preview)
- Markdown files
- Code with syntax highlighting

## Configuration Files

| File | Purpose |
|------|---------|
| `~/.config/dolphinrc` | Main Dolphin settings |
| `~/.config/dolphinstaterc` | Window state |
| `~/.config/baloofilerc` | File indexing |
| `~/.local/share/user-places.xbel` | Sidebar places |
| `/usr/share/kio/servicemenus/` | Quick actions |

## Customization

### Add Custom Quick Action
Create a `.desktop` file in `~/.local/share/kio/servicemenus/`:

```ini
[Desktop Entry]
Type=Service
ServiceTypes=KonqPopupMenu/Plugin
MimeType=all/allfiles;
Actions=myAction

[Desktop Action myAction]
Name=My Custom Action
Icon=utilities-terminal
Exec=my-command %F
```

### Add Smart Folder
Edit `~/.local/share/user-places.xbel` and add:

```xml
<bookmark href="baloosearch://?type=Document&amp;modified>=today">
  <title>Today's Documents</title>
  <info>
    <metadata owner="http://freedesktop.org">
      <bookmark:icon name="folder-documents"/>
    </metadata>
  </info>
</bookmark>
```

## Troubleshooting

### Smart folders not working
```bash
# Check Baloo status
balooctl status

# Rebuild index if needed
balooctl disable
rm -rf ~/.local/share/baloo
balooctl enable
```

### Thumbnails not generating
```bash
# Clear thumbnail cache
rm -rf ~/.cache/thumbnails/*

# Check thumbnailer
kde5-config --path services | xargs ls
```

### Service menus not appearing
```bash
# Verify file location
ls ~/.local/share/kio/servicemenus/
ls /usr/share/kio/servicemenus/

# Update KDE cache
kbuildsycoca5 --noincremental
```

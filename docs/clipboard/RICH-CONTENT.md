# 🖼️ SANCHALA OS - Rich Content Clipboard

## Overview

Sanchala OS clipboard supports rich content including images, files, formatted text, and special data types like colors and code snippets.

## Supported Content Types

| Type | Support | Max Size | Notes |
|------|---------|----------|-------|
| Plain Text | ✅ | 10 MB | Full Unicode support |
| Rich Text (HTML) | ✅ | 10 MB | Formatting preserved |
| Images | ✅ | 10 MB | PNG, JPEG, WebP, SVG |
| Files | ✅ | Reference | Path references, not content |
| Colors | ✅ | - | HEX, RGB, HSL formats |
| Code | ✅ | 10 MB | Syntax highlighting preserved |

## Images

### Copying Images

Images can be copied from:
- Screenshots (`Meta+Shift+S`)
- Image viewers
- Web browsers
- Graphics applications

### Image Storage

```ini
[RichContent]
ImagesEnabled=true
MaxImageWidth=4096
MaxImageHeight=4096
ImageQuality=90
ImageFormat=PNG
GenerateThumbnails=true
ThumbnailSize=64
```

### Image in History

Images show as thumbnails in clipboard history:

```
┌────────────────────────────────────┐
│ 📋 Clipboard History         Meta+V │
├────────────────────────────────────┤
│ 🖼️ [thumb] Screenshot - 2 min ago  │
│ 📝 "Hello world" - 5 min ago       │
│ 🖼️ [thumb] Photo.jpg - 10 min ago  │
│ 📄 document.pdf - 15 min ago       │
└────────────────────────────────────┘
```

### Cross-Device Image Sync

Images are compressed before sync to save bandwidth:

```ini
[Sync]
SyncImages=true
MaxImageSyncSize=5242880
CompressImagesForSync=true
SyncImageQuality=80
```

## Files

### Copying Files

Copy files from Dolphin or other file managers. Sanchala clipboard stores **references**, not file contents.

```ini
[Files]
Enabled=true
ShowPreviews=true
MaxPreviewSize=52428800
TrackFilePaths=true
DefaultMode=reference
```

### File Operations

When pasting files:
- **In file manager**: Copies/moves files
- **In text editor**: Inserts file path
- **In application**: Depends on app support

### Drag and Drop

Files in clipboard support drag-and-drop:

```ini
[Files]
DragDropEnabled=true
```

## Formatted Text

### HTML/Rich Text

Formatting is preserved when copying from:
- Word processors (LibreOffice Writer)
- Web browsers
- Email clients
- Rich text editors

```ini
[RichContent]
HTMLEnabled=true
PreserveFormatting=true
```

### Paste Options

| Shortcut | Action |
|----------|--------|
| `Ctrl+V` | Paste with formatting |
| `Meta+Shift+Ctrl+V` | Paste as plain text |

## Colors

### Color Detection

Clipboard detects color values:
- HEX: `#FF5733`
- RGB: `rgb(255, 87, 51)`
- HSL: `hsl(11, 100%, 60%)`

### Color Actions

When a color is copied, actions are available:

```
┌─────────────────────────────┐
│ 🎨 #FF5733                  │
├─────────────────────────────┤
│ 👁️ Preview Color            │
│ 🔄 Convert to RGB           │
│ 🔄 Convert to HSL           │
│ 📋 Copy as CSS variable     │
└─────────────────────────────┘
```

### Configuration

```ini
[RichContent]
ColorValuesEnabled=true
ColorFormat=hex

[Actions][Color]
Enabled=true
Pattern=#[0-9A-Fa-f]{6}|rgb\([^)]+\)|hsl\([^)]+\)
Actions=preview,convert
```

## Code Snippets

### Syntax Preservation

When copying code from:
- IDEs (VS Code, Kate, KDevelop)
- Syntax-highlighted terminals
- Code-sharing websites

Syntax highlighting metadata is preserved where possible.

### Code Actions

```
┌─────────────────────────────┐
│ 💻 function hello() {...}   │
├─────────────────────────────┤
│ 📋 Paste as code block      │
│ 📝 Paste plain              │
│ 🔗 Create Gist              │
│ 📤 Share snippet            │
└─────────────────────────────┘
```

## Smart Actions

### URL Actions

```ini
[Actions][URL]
Enabled=true
Pattern=https?://[^\s]+
Actions=open,copy-clean,qr-code,archive
```

Available actions:
- **Open in Browser**: Launch URL
- **Copy Clean**: Remove tracking parameters
- **QR Code**: Generate QR for mobile
- **Archive**: Save to Archive.org

### Email Actions

```ini
[Actions][Email]
Enabled=true
Pattern=[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}
Actions=compose,copy,contact
```

### Phone Number Actions

```ini
[Actions][Phone]
Enabled=true
Actions=call,sms,contact
```

Integrates with KDE Connect for calling/SMS.

## History Search

Search through rich content history:

```bash
# Keyboard shortcut
Meta+Ctrl+F

# Search supports:
# - Text content
# - File names
# - Image OCR (if enabled)
# - Timestamps
```

```ini
[History]
SearchEnabled=true
SearchHighlight=true
FuzzySearch=true
```

## Memory Management

Rich content uses more memory. Configure limits:

```ini
[Advanced]
MemoryLimit=256

[History]
MaxItemSize=10485760
MaxItems=100

[RichContent]
MaxImageWidth=4096
MaxImageHeight=4096
```

## Troubleshooting

### Images not showing in history

```bash
# Check image support
klipper --check-images

# Verify configuration
grep -i image ~/.config/klipperrc
```

### Formatting lost on paste

Some applications don't support rich paste. Use:
- Check app's paste special option
- Try `Ctrl+Shift+V` in the target app

### Large files slow down clipboard

Reduce limits:
```ini
[History]
MaxItemSize=5242880

[RichContent]
MaxImageWidth=2048
MaxImageHeight=2048
```

---

**Document Version:** 1.0  
**Part of SANCHALA OS** - Universal Clipboard

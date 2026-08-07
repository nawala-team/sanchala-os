# SANCHALA OS - Spectacle Screenshot Guide

## Capture Modes

1. **Full Screen** - Entire desktop across all monitors
2. **Current Screen** - Active monitor only
3. **Active Window** - Currently focused window
4. **Rectangular Region** - Click and drag selection
5. **Window Under Cursor** - Window beneath mouse pointer

## Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| `Print` | Full screen capture |
| `Shift+Print` | Region selection |
| `Alt+Print` | Active window |
| `Super+Print` | Current monitor |
| `Ctrl+Print` | All screens |
| `Ctrl+Alt+Print` | Window under cursor |

## After Capture Actions

- **Save** (`Ctrl+S`) - Save to default location
- **Copy to Clipboard** (`Ctrl+C`) - Ready to paste
- **Annotate** (`Ctrl+A`) - Open annotation tools
- **Open With** (`Ctrl+O`) - Choose application

## Built-in Annotation Tools

Spectacle includes powerful annotation features:

- **Pen/Brush** - Freehand drawing
- **Arrows** - Point to elements
- **Lines** - Straight lines
- **Rectangles** - Highlight areas
- **Ellipses** - Circle elements
- **Text** - Add labels
- **Highlighter** - Semi-transparent marking
- **Blur** - Obscure sensitive info
- **Numbers** - Sequential markers

## Configuration

Key settings in `~/.config/spectaclerc`:

```ini
[General]
# Default to region capture
launchAction=3

# Show magnifier for precision
showMagnifier=true

# High quality output
compressionQuality=95

# Copy to clipboard after capture
copyImageToClipboard=true

[Save]
# Save location
defaultSaveLocation[$e]=$HOME/Pictures/Screenshots

# Filename format
saveFilenameFormat=Screenshot_%Y-%m-%d_%H-%M-%S

# PNG format (lossless)
preferredImageFormat=png

[Annotation]
# Sanchala accent blue
penColor=#1a237e
penWidth=3
blurRadius=15
```

## Tips

### Timed Screenshots
```bash
spectacle --delay 5000  # 5-second delay
```

### Include Mouse Pointer
Enable in Spectacle settings or:
```ini
[General]
includePointer=true
```

### Window Shadows
For macOS-like window captures with shadows:
```ini
[ImageGrabber]
includeWindowShadow=true
```

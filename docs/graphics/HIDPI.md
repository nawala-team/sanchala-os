# 📐 HiDPI Configuration - Sanchala OS

## Overview

HiDPI (High Dots Per Inch) displays require scaling to maintain readable UI elements. Sanchala OS handles this automatically via KDE Plasma.

## Automatic Scaling

KDE Plasma detects display DPI and applies appropriate scaling on first boot.

### Recommended Scale Factors

| Display | Resolution | Size | DPI | Scale |
|---------|-----------|------|-----|-------|
| Standard | 1920×1080 | 24" | 92 | 100% |
| QHD | 2560×1440 | 27" | 109 | 100-125% |
| 4K | 3840×2160 | 27" | 163 | 150% |
| 4K | 3840×2160 | 32" | 138 | 125-150% |
| 4K | 3840×2160 | 24" | 184 | 175-200% |
| Retina | 2880×1800 | 15" | 220 | 200% |

## Manual Configuration

### KDE System Settings

**System Settings → Display & Monitor → Display Configuration**

1. Select display
2. Adjust "Scale" slider
3. Click "Apply"

### Per-Display Scaling

Different scales for different monitors:

1. Open Display Configuration
2. Select each monitor individually
3. Set appropriate scale for each

### Global Scale Override

Edit `~/.config/kdeglobals`:
```ini
[KScreen]
ScaleFactor=1.5
```

## Application-Specific Scaling

### Qt Applications

Handled automatically. Override if needed:
```bash
QT_SCALE_FACTOR=1.5 application
```

### GTK Applications

Handled automatically. Override if needed:
```bash
GDK_SCALE=2 GDK_DPI_SCALE=0.5 application
```

### Electron Applications

```bash
# Via command line
application --force-device-scale-factor=1.5

# Or environment variable
ELECTRON_FORCE_DEVICE_SCALE_FACTOR=1.5 application
```

### XWayland (Legacy X11) Apps

Options in **System Settings → Display → Legacy Applications (X11)**:

- **Apply scaling themselves**: Apps handle their own scaling (crisp but may be wrong size)
- **Scaled by the system**: KWin scales the app (correct size but may be blurry)

## Fractional Scaling

KDE Plasma 6 supports fractional scaling (125%, 150%, 175%) natively.

### Known Issues

1. **XWayland apps**: May appear blurry at non-integer scales
2. **Some GTK apps**: May have inconsistent scaling
3. **Electron apps**: May need explicit scale factor

### Best Practices

- Use integer scales (100%, 200%) for crispest rendering
- If using fractional, 150% works better than 125% or 175%
- Enable "Apply scaling themselves" for XWayland apps when possible

## Environment Variables

Located in `/etc/environment.d/60-sanchala-hidpi.conf`:

```bash
# Qt automatic scaling
QT_AUTO_SCREEN_SCALE_FACTOR=1
QT_ENABLE_HIGHDPI_SCALING=1

# Cursor size (adjust for HiDPI)
XCURSOR_SIZE=24  # Use 32 or 48 for HiDPI
```

## Cursor Size

For HiDPI displays, increase cursor size:

**System Settings → Appearance → Cursors → Size**

| Scale | Recommended Cursor Size |
|-------|------------------------|
| 100% | 24 |
| 125% | 30 |
| 150% | 36 |
| 200% | 48 |

## Font Scaling

Fonts scale automatically with display scaling. For additional adjustment:

**System Settings → Appearance → Fonts → Force Font DPI**

Typically not needed with proper display scaling.

# High Contrast Themes

Sanchala OS includes high contrast color schemes designed for WCAG 2.1 AA compliance with minimum 4.5:1 contrast ratios.

## Available Themes

### Sanchala High Contrast Light

Optimized for users who prefer light backgrounds with maximum contrast.

- **Background:** White (#FFFFFF)
- **Text:** Black (#000000)
- **Links:** Blue (#0000EE)
- **Selection:** Black background, white text
- **Focus:** Black 4px border

### Sanchala High Contrast Dark

Optimized for users who prefer dark backgrounds with maximum contrast.

- **Background:** Black (#000000)
- **Text:** White (#FFFFFF)
- **Links:** Light Blue (#66B3FF)
- **Selection:** White background, black text
- **Focus:** White 4px border

## Enabling High Contrast

### Command Line

```bash
# Dark high contrast
sanchala-accessibility high-contrast enable dark

# Light high contrast
sanchala-accessibility high-contrast enable light

# Disable
sanchala-accessibility high-contrast disable

# Toggle
sanchala-accessibility high-contrast toggle
```

### Keyboard Shortcut

`Super+Alt+H` - Toggle high contrast mode

### System Settings

System Settings → Accessibility → Vision → High Contrast

## Additional Visual Settings

When enabling high contrast, consider also enabling:

### Reduce Transparency

Removes blur and transparency effects that can reduce readability:

```ini
[Visual]
ReduceTransparency=true
```

### Remove Background Images

Removes decorative backgrounds that may interfere with text:

```ini
[Visual]
RemoveBackgroundImages=true
```

### Large Cursor

High contrast cursor themes are automatically applied:

```bash
sanchala-accessibility large-cursor enable 48
```

## Color Scheme Files

Located in `/usr/share/color-schemes/`:

- `SanchalaHighContrastLight.colors`
- `SanchalaHighContrastDark.colors`

### Color Scheme Structure

```ini
[Colors:View]
BackgroundNormal=#000000
ForegroundNormal=#FFFFFF
ForegroundLink=#66B3FF
DecorationFocus=#FFFFFF

[Colors:Selection]
BackgroundNormal=#FFFFFF
ForegroundNormal=#000000
```

## WCAG Compliance

Both themes meet WCAG 2.1 AA requirements:

| Criterion | Requirement | Status |
|-----------|-------------|--------|
| 1.4.3 Contrast (Minimum) | 4.5:1 for text | ✅ 21:1 |
| 1.4.6 Contrast (Enhanced) | 7:1 for text | ✅ 21:1 |
| 1.4.11 Non-text Contrast | 3:1 for UI | ✅ 21:1 |

## Customization

Create custom high contrast scheme:

1. Copy existing scheme:
   ```bash
   cp /usr/share/color-schemes/SanchalaHighContrastDark.colors \
      ~/.local/share/color-schemes/MyHighContrast.colors
   ```

2. Edit colors as needed

3. Apply:
   ```bash
   plasma-apply-colorscheme MyHighContrast
   ```

## Application Support

Most KDE/Qt applications automatically use system colors. For GTK apps:

```bash
# GTK theme is set automatically, but can be forced:
gsettings set org.gnome.desktop.interface gtk-theme 'HighContrast'
```

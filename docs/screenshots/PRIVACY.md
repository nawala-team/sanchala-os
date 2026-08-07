# SANCHALA OS - Privacy & Troubleshooting

## Privacy Features

### Metadata Stripping

Screenshots automatically strip:
- EXIF data
- Location information
- Camera/device info
- Timestamps (configurable)

Configure in `spectaclerc`:
```ini
[Privacy]
stripMetadata=true
includeLocationData=false
```

### Blur Tool

Use Spectacle's blur tool to obscure:
- Personal information
- Passwords
- Email addresses
- Private data

Default blur radius: 15px (configurable)

### Local-First Sharing

Default share options keep data local:
1. **Clipboard** - No network
2. **Local file** - Your disk only
3. **Email** - Your mail client
4. **Print** - Your printer

Cloud sharing (Imgur) requires explicit action and confirmation.

### Auto-Blur Sensitive Content

Experimental feature to detect and blur:
- Credit card numbers
- Social security numbers
- Phone numbers

```ini
[Privacy]
autoBlurSensitive=false  # Enable with caution
```

## Troubleshooting

### Screenshots not working on Wayland

Ensure portal is running:
```bash
systemctl --user status xdg-desktop-portal-kde
systemctl --user restart xdg-desktop-portal-kde
```

Check PipeWire:
```bash
systemctl --user status pipewire
```

### Screen recording black screen

1. Verify PipeWire is running
2. Use PipeWire source in OBS (not X11 capture)
3. Check permissions:
```bash
# Add user to video group
sudo usermod -aG video $USER
```

### OCR not recognizing text

1. Install language data:
```bash
sudo pacman -S tesseract-data-eng tesseract-data-jpn
```

2. Check image quality - higher resolution = better OCR

3. Preprocess image:
```bash
convert input.png -resize 200% -sharpen 0x1 output.png
```

### Spectacle opens but doesn't capture

Reset configuration:
```bash
rm ~/.config/spectaclerc
```

### Recording has no audio

Check PipeWire audio:
```bash
wpctl status
```

Ensure default audio device is set:
```bash
wpctl set-default <device-id>
```

### OBS crashes on startup

Remove config and restart:
```bash
mv ~/.config/obs-studio ~/.config/obs-studio.bak
```

### wf-recorder "compositor doesn't support" error

Your compositor needs wlr-screencopy protocol. KWin supports this natively on recent versions.

Alternative: Use OBS with PipeWire source.

## Performance Tips

### Reduce CPU usage during recording

- Lower framerate: `-f 30`
- Use hardware encoding (VA-API)
- Reduce resolution
- Close unnecessary applications

### Faster screenshots

- Disable magnifier for quick captures
- Use keyboard shortcuts instead of GUI
- Disable preview before save

### Smaller file sizes

- Use WebP format for screenshots
- Lower recording quality: `-q 5`
- Use H.265/HEVC codec (better compression)

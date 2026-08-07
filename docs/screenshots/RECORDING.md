# SANCHALA OS - Screen Recording Guide

## Recording Options

### wf-recorder (Wayland Native)

Default recorder for Wayland sessions. Use via `sanchala-record` command.

Features:
- Hardware-accelerated encoding (VA-API)
- PipeWire audio capture
- Region/window selection with slurp
- Low overhead

### OBS Studio (Advanced)

Professional recording and streaming:

Features:
- Multiple scenes and sources
- Hardware encoding (VA-API/NVENC)
- Streaming to Twitch/YouTube
- Advanced audio mixing
- Filters and effects

Default profile: `SANCHALA Recording`
- 1080p60 output
- Hardware encoding
- MKV container
- High quality preset

### SimpleScreenRecorder (X11 Fallback)

For X11 sessions or when Wayland tools fail:
- Simple GTK interface
- Reliable capture
- Good performance

## Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| `Super+Shift+R` | Start/Stop recording |
| `Super+Ctrl+R` | Record window |
| `Super+Alt+R` | Record region |
| `Super+Shift+P` | Pause recording |

## Output Settings

Default location: `~/Videos/Recordings/`

Filename format: `Recording_YYYY-MM-DD_HH-MM-SS.mp4`

Recommended formats:
- **MKV** - Best for recording (recoverable if crash)
- **MP4** - Best for sharing
- **WebM** - Best for web

## Audio Recording

### System Audio
Captured automatically via PipeWire.

### Microphone
Add `-a` flag to sanchala-record or enable in OBS.

### Both
OBS can mix system + mic with separate tracks.

## Hardware Acceleration

### AMD (VA-API)
Automatic with Mesa drivers. Verify:
```bash
vainfo
```

### Intel (VA-API)
```bash
sudo pacman -S intel-media-driver
```

### NVIDIA (NVENC)
```bash
sudo pacman -S nvidia-utils
```

## Tips

### Recording GIFs
```bash
# Requires gifski
wf-recorder -g "$(slurp)" -c gif -f output.gif
```

### Lower CPU Usage
Reduce framerate:
```bash
sanchala-record -f 30
```

### Smaller Files
Lower quality setting:
```bash
sanchala-record -q 5
```

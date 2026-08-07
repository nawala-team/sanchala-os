# Hardware Video Acceleration

Guide to VA-API and VDPAU configuration in SANCHALA OS.

## Supported APIs

| GPU | VA-API | VDPAU | Vulkan Video |
|-----|--------|-------|--------------|
| AMD (RADV) | ✅ Mesa | ✅ via VA-GL | ✅ |
| Intel | ✅ iHD/i965 | ✅ via VA-GL | ✅ |
| NVIDIA | ✅ nvidia-vaapi | ✅ Native | 🔄 |

## Verify Hardware Acceleration

```bash
# Check VA-API support
vainfo

# Check VDPAU support
vdpauinfo

# Check Vulkan support
vulkaninfo --summary
```

## Environment Variables

Set in `/etc/environment.d/70-sanchala-hwaccel.conf`:

```bash
# Auto-detect VA-API driver
LIBVA_DRIVER_NAME=auto

# Use VA-API bridge for VDPAU
VDPAU_DRIVER=va_gl

# Enable for GStreamer
GST_VAAPI_ALL_DRIVERS=1
```

## Application Configuration

### MPV

```bash
# ~/.config/mpv/mpv.conf
hwdec=auto-safe
vo=gpu-next
gpu-api=vulkan
```

### Firefox

1. Open `about:config`
2. Set `media.ffmpeg.vaapi.enabled` = `true`
3. Set `gfx.webrender.all` = `true`

### VLC

Tools → Preferences → Input/Codecs:
- Hardware acceleration: VA-API

### Chromium/Chrome

Launch with flags:
```bash
chromium --enable-features=VaapiVideoDecoder
```

## Troubleshooting

### Check Driver Loading

```bash
# AMD
LIBVA_DRIVER_NAME=radeonsi vainfo

# Intel (modern)
LIBVA_DRIVER_NAME=iHD vainfo

# Intel (legacy)
LIBVA_DRIVER_NAME=i965 vainfo
```

### Permissions

Ensure access to DRI devices:
```bash
ls -la /dev/dri/
# User should be in 'video' group
sudo usermod -aG video $USER
```

# SANCHALA OS Media Applications

Complete guide to media playback, photo management, and library organization.

## Overview

SANCHALA OS provides a polished media experience comparable to macOS, with:
- **Elisa** - Elegant music player with library management
- **Haruna** - Modern video player powered by mpv
- **Gwenview** - Fast image viewer with basic editing
- **digiKam** - Professional photo management (optional)
- **Unified media library** - Cross-app indexed database

## Default Applications

| Media Type | Primary App | Fallback |
|------------|-------------|----------|
| Music | Elisa | VLC |
| Video | Haruna | VLC |
| Images | Gwenview | digiKam |
| Playlists | Elisa | VLC |

## Music Player (Elisa)

Elisa provides an Apple Music-like experience with focus on your local library.

### Features
- Automatic library scanning from ~/Music
- Album art display with blur backgrounds
- Smart playlists and play history
- Media key support (play/pause/next/prev)
- ReplayGain for consistent volume
- Lyrics display (when available)

### Configuration
Location: `~/.config/elisa/elisa.conf`

Key settings:
```ini
[Library]
rootPath=$HOME/Music
scanAtStartup=true
watchForFileChanges=true

[NowPlaying]
showLyrics=true
blurBackground=true
```

### Keyboard Shortcuts
| Action | Shortcut |
|--------|----------|
| Play/Pause | Space |
| Next Track | Media Next |
| Previous | Media Previous |
| Volume Up | + |
| Volume Down | - |

## Video Player (Haruna)

Haruna is a modern Qt/QML video player built on the mpv engine.

### Features
- Hardware-accelerated decoding (VA-API, VDPAU)
- Vulkan rendering for best quality
- YouTube playback via yt-dlp
- Resume playback from last position
- Chapter navigation
- Subtitle auto-loading

### Configuration
Location: `~/.config/haruna/haruna.conf`

MPV backend: `~/.config/mpv/mpv.conf`

### Keyboard Shortcuts
| Action | Shortcut |
|--------|----------|
| Play/Pause | Space |
| Fullscreen | F |
| Seek ±5s | Left/Right |
| Seek ±30s | Up/Down |
| Volume | 9/0 |
| Mute | M |
| Screenshot | Ctrl+S |
| Subtitles | V |
| Audio Track | Ctrl+A |

### MPV Profiles

Switch profiles for different content:

```bash
# In mpv, press ` to open console, then:
apply-profile high-quality    # Maximum quality
apply-profile low-power       # Battery saving
apply-profile anime           # Optimized for anime
apply-profile streaming       # Online content
```

## Image Viewer (Gwenview)

Fast, lightweight image viewer with basic editing.

### Features
- Instant image loading with thumbnails
- EXIF metadata display
- Basic editing (crop, rotate, resize)
- Red-eye reduction
- Slideshow mode
- RAW file support

### Configuration
Location: `~/.config/gwenviewrc`

### Keyboard Shortcuts
| Action | Shortcut |
|--------|----------|
| Next Image | Right |
| Previous | Left |
| Zoom In | Ctrl++ |
| Zoom Out | Ctrl+- |
| Fit to Window | F |
| Actual Size | Ctrl+0 |
| Fullscreen | F11 |
| Rotate Right | Ctrl+R |
| Delete | Del |

## Media Library Indexer

SANCHALA includes a unified media indexer for fast searching.

### Usage

```bash
# Full library scan
sanchala-media-indexer scan

# Scan specific type
sanchala-media-indexer scan-audio
sanchala-media-indexer scan-video
sanchala-media-indexer scan-images

# Show statistics
sanchala-media-indexer stats

# Initialize fresh database
sanchala-media-indexer init
```

### Automatic Indexing

The indexer runs automatically via systemd timer:
- First scan: 5 minutes after login
- Recurring: Every hour

Enable/disable:
```bash
systemctl --user enable sanchala-media-indexer.timer
systemctl --user disable sanchala-media-indexer.timer
```

### Database Location
- Database: `~/.local/share/sanchala/media/library.db`
- Thumbnails: `~/.cache/sanchala/media/thumbnails/`
- Logs: `~/.local/state/sanchala/media-indexer.log`

## Hardware Acceleration

Video playback uses hardware decoding when available:

### Check Status
```bash
# VA-API (Intel/AMD)
vainfo

# VDPAU (NVIDIA)
vdpauinfo
```

### Force Software Decoding
If hardware decoding causes issues:

```ini
# In ~/.config/mpv/mpv.conf
hwdec=no
```

## Codec Support

All major formats are supported out of the box:

### Audio
MP3, FLAC, OGG, Opus, AAC, M4A, WAV, ALAC, APE, WavPack

### Video
MP4, MKV, WebM, AVI, MOV, WMV, FLV, MPEG, TS

### Images
JPEG, PNG, GIF, WebP, HEIC, AVIF, TIFF, BMP, RAW (CR2, NEF, ARW, DNG)

## Troubleshooting

### No Sound in Video Player
```bash
# Check PipeWire status
systemctl --user status pipewire

# Restart audio
systemctl --user restart pipewire pipewire-pulse wireplumber
```

### Video Playback Stuttering
1. Check hardware acceleration: `vainfo`
2. Try different GPU API in Haruna settings
3. Reduce quality settings for 4K content

### Music Library Not Updating
```bash
# Force rescan
sanchala-media-indexer scan-audio

# Check Elisa settings
# Settings > Configure Elisa > Music paths
```

### Thumbnails Not Generating
```bash
# Clear thumbnail cache
rm -rf ~/.cache/sanchala/media/thumbnails/*

# Regenerate
sanchala-media-indexer scan
```

## Related Documentation

- [PipeWire Configuration](../multimedia/PIPEWIRE.md)
- [Hardware Acceleration](../multimedia/HWACCEL.md)
- [File Associations](../file-associations/README.md)

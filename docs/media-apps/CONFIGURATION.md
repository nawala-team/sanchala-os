# Media Applications Configuration Reference

Detailed configuration options for SANCHALA OS media applications.

## Elisa Configuration

File: `~/.config/elisa/elisa.conf`

### [General]
| Key | Default | Description |
|-----|---------|-------------|
| showProgressOnTaskBar | true | Show playback progress in taskbar |
| showSystemTrayIcon | true | Enable system tray icon |
| startInTray | false | Start minimized to tray |

### [Library]
| Key | Default | Description |
|-----|---------|-------------|
| rootPath | $HOME/Music | Music folders to scan |
| scanAtStartup | true | Scan library on launch |
| watchForFileChanges | true | Auto-detect new files |

### [NowPlaying]
| Key | Default | Description |
|-----|---------|-------------|
| showLyrics | true | Display lyrics if available |
| blurBackground | true | Blur album art as background |
| blurRadius | 40 | Background blur intensity |

### [ReplayGain]
| Key | Default | Description |
|-----|---------|-------------|
| enabled | true | Normalize volume levels |
| mode | album | album or track normalization |
| preamp | 0 | Pre-amplification in dB |

## Haruna Configuration

File: `~/.config/haruna/haruna.conf`

### [Playback]
| Key | Default | Description |
|-----|---------|-------------|
| hwDecoding | auto-safe | Hardware decoding mode |
| resumePlayback | true | Remember playback position |
| seekToLastPosition | true | Resume from last position |

### [Subtitles]
| Key | Default | Description |
|-----|---------|-------------|
| preferredLanguage | eng | Preferred subtitle language |
| subtitleAutoLoad | fuzzy | Auto-load subtitle files |
| subtitleFont | Noto Sans | Subtitle font |
| subtitleFontSize | 42 | Subtitle size |

### [Performance]
| Key | Default | Description |
|-----|---------|-------------|
| gpuApi | vulkan | GPU rendering API |
| cacheSize | 150000 | Cache size in KB |

## MPV Configuration

File: `~/.config/mpv/mpv.conf`

### Video Output
```ini
hwdec=auto-safe          # Hardware decoding
vo=gpu-next              # Video output driver
gpu-api=vulkan           # GPU API
```

### Quality
```ini
scale=ewa_lanczossharp   # Upscaling algorithm
cscale=ewa_lanczossharp  # Chroma scaling
dscale=mitchell          # Downscaling
```

### Audio
```ini
audio-channels=stereo    # Output channels
audio-normalize-downmix=yes  # Normalize multichannel
```

## Gwenview Configuration

File: `~/.config/gwenviewrc`

### [ImageView]
| Key | Default | Description |
|-----|---------|-------------|
| ZoomMode | 1 | 0=Actual, 1=Fit, 2=Fill |
| EnlargeSmallerImages | false | Scale up small images |

### [ThumbnailView]
| Key | Default | Description |
|-----|---------|-------------|
| ThumbnailSize | 160 | Thumbnail pixel size |
| Spacing | 8 | Grid spacing |

### [FullScreen]
| Key | Default | Description |
|-----|---------|-------------|
| SlideShowInterval | 5 | Seconds between slides |
| SlideShowLoop | true | Loop slideshow |

## Media Indexer Configuration

The indexer uses built-in defaults but respects these paths:

| Purpose | Location |
|---------|----------|
| Music | ~/Music |
| Videos | ~/Videos |
| Photos | ~/Pictures |
| Database | ~/.local/share/sanchala/media/library.db |
| Thumbnails | ~/.cache/sanchala/media/thumbnails/ |
| Logs | ~/.local/state/sanchala/media-indexer.log |

## Systemd Services

### Timer
File: `~/.config/systemd/user/sanchala-media-indexer.timer`

```ini
[Timer]
OnBootSec=5min      # First run after boot
OnUnitActiveSec=1h  # Repeat interval
```

### Service
File: `~/.config/systemd/user/sanchala-media-indexer.service`

The service runs with security hardening:
- Read-only home directory access
- Write access only to sanchala data dirs
- No privilege escalation

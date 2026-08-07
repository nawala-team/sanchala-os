# 🌐 Browser Download Integration

## Overview

Sanchala OS intercepts downloads from web browsers and routes them to the appropriate download manager (aria2 for HTTP/FTP, qBittorrent for torrents) for accelerated, resumable downloads.

---

## Supported Browsers

| Browser | Integration Method | Status |
|---------|-------------------|--------|
| Firefox | Native Messaging API | ✅ Full |
| Chromium | Native Messaging API | ✅ Full |
| Brave | Native Messaging API | ✅ Full |
| Vivaldi | Native Messaging API | ✅ Full |

---

## Capture Rules

### File Size Threshold
Downloads larger than **10 MB** are automatically captured.

### File Extensions (Always Captured)
```
.exe, .msi, .deb, .rpm, .AppImage    # Executables
.tar.gz, .tar.xz, .zip, .rar, .7z    # Archives
.iso, .torrent                        # Images/Torrents
```

### Special URLs
| Pattern | Handler |
|---------|---------|
| `magnet:?xt=...` | qBittorrent |
| `*.torrent` | qBittorrent |
| All other captured | aria2 |

---

## Native Messaging Setup

### Firefox Manifest
**Location:** `/usr/lib/mozilla/native-messaging-hosts/sanchala_download_manager.json`

### Chromium Manifest
**Location:** `/etc/chromium/native-messaging-hosts/sanchala_download_manager.json`

---

## Manual Download Commands

```bash
# Add URL to aria2
sanchala-download-manager add "https://example.com/file.zip"

# Add magnet link
sanchala-browser-download magnet "magnet:?xt=urn:btih:..."

# Add torrent file
sanchala-browser-download torrent "/path/to/file.torrent"
```

---

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Downloads not captured | Check `sanchala-download-manager status` |
| Extension not connecting | Verify native host is executable |
| No notifications | Test with `notify-send "Test" "Message"` |

---

**Document Version:** 1.0

# 🖥️ uGet Download Manager GUI

## Overview

uGet is a lightweight GTK-based download manager that integrates with aria2 as its backend, providing a user-friendly graphical interface for managing downloads in Sanchala OS.

---

## Features

| Feature | Description |
|---------|-------------|
| aria2 Backend | Uses aria2 for high-speed, multi-connection downloads |
| Browser Integration | Captures downloads from Firefox/Chrome |
| Clipboard Monitor | Auto-detects URLs from clipboard |
| Queue Management | Organize downloads into categories |
| Scheduler | Time-based download scheduling |
| Bandwidth Control | Per-download and global speed limits |

---

## Configuration

### aria2 Plugin Setup

1. Open uGet → Edit → Settings → Plug-in
2. Select "aria2" as the plug-in
3. Configure connection:
   - Host: `localhost`
   - Port: `6800`
   - Token: `sanchala_aria2_secret`

### Recommended Settings

**Edit → Settings → General:**
```
☑ Start in system tray
☑ Close to system tray
☑ Enable clipboard monitor
☑ Skip existing URLs
```

**Edit → Settings → Bandwidth:**
```
Max connections per download: 16
Default download limit: 0 (unlimited)
```

---

## Browser Integration

### Firefox Integration

Install the uGet Integration extension:
1. Firefox → Add-ons → Search "uGet Integration"
2. Install and enable
3. Configure to send downloads to uGet

### Chrome/Chromium Integration

1. Install "uGet Integration" from Chrome Web Store
2. Enable in extensions settings

---

## Categories

uGet organizes downloads into categories:

| Category | Default Path | File Types |
|----------|--------------|------------|
| Home | ~/Downloads | General |
| Documents | ~/Documents | PDF, DOC, TXT |
| Music | ~/Music | MP3, FLAC, OGG |
| Videos | ~/Videos | MP4, MKV, AVI |
| Software | ~/Downloads/Software | EXE, DEB, AppImage |

### Create Custom Category

1. Edit → New Category
2. Set name, default folder, and file patterns
3. Assign file extensions to auto-sort

---

## Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| Ctrl+N | New download |
| Ctrl+V | Add URL from clipboard |
| Ctrl+D | Delete selected |
| Ctrl+P | Pause selected |
| Ctrl+R | Resume selected |
| Delete | Move to trash |

---

## Command Line

```bash
# Add download via CLI
uget-gtk --quiet "https://example.com/file.zip"

# Add with specific folder
uget-gtk --folder=/home/user/Downloads "https://example.com/file.zip"

# Add from clipboard
uget-gtk --clipboard
```

---

## Integration with aria2 Daemon

uGet can use the Sanchala aria2 daemon:

```bash
# Ensure aria2 is running
sanchala-download-manager start

# Configure uGet to use existing aria2
# Settings → Plug-in → aria2
# ☑ Launch aria2 on startup: DISABLED
# ☑ Shutdown aria2 on exit: DISABLED
```

This allows both uGet GUI and command-line tools to share the same aria2 session.

---

## Troubleshooting

| Issue | Solution |
|-------|----------|
| aria2 not connecting | Check if daemon is running: `pgrep aria2c` |
| Downloads not captured | Verify browser extension is enabled |
| Slow speeds | Increase max connections in aria2 settings |
| Categories not working | Check folder permissions |

---

## vs. Other Options

| Feature | uGet | aria2 CLI | qBittorrent |
|---------|------|-----------|-------------|
| GUI | ✅ GTK | ❌ CLI | ✅ Qt |
| HTTP/FTP | ✅ | ✅ | ❌ |
| BitTorrent | ✅ (via aria2) | ✅ | ✅ |
| Browser Integration | ✅ | Manual | ❌ |
| Lightweight | ✅ | ✅✅ | ❌ |

**Recommendation:** Use uGet for HTTP/FTP downloads, qBittorrent for torrents.

---

**Document Version:** 1.0 | **Author:** Download Manager Engineer

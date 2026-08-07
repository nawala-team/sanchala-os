# 🌊 qBittorrent Configuration Guide

## Overview

qBittorrent is the primary BitTorrent client in Sanchala OS, configured with privacy-focused defaults and integrated with the system-wide bandwidth scheduler.

---

## Configuration Files

| File | Purpose |
|------|--------|
| `/etc/qbittorrent/qBittorrent.conf` | System defaults |
| `~/.config/qBittorrent/qBittorrent.conf` | User settings |
| `~/.config/qBittorrent/ipfilter.dat` | IP block list |

---

## Privacy-First Defaults

### Anonymous Mode
```ini
Session\AnonymousModeEnabled=true
```
- Hides client fingerprint
- Disables Local Peer Discovery advertising
- Does not share metadata

### Forced Encryption
```ini
Session\Encryption=1
```
Encryption modes: `0` = Prefer, `1` = **Require** (default), `2` = Disable

### IP Filtering
```ini
Session\IPFilter\Enabled=true
Session\IPFilter\File=/home/@USER@/.config/qBittorrent/ipfilter.dat
```

Update blocklists:
```bash
curl -L "https://list.iblocklist.com/?list=level1" | gunzip > ~/.config/qBittorrent/ipfilter.dat
```

---

## Bandwidth Management

### Speed Limits
```ini
# Normal limits (0 = unlimited)
Session\GlobalDLSpeedLimit=0
Session\GlobalUPSpeedLimit=0

# Alternative limits (scheduled throttling)
Session\AlternativeGlobalDLSpeedLimit=1024
Session\AlternativeGlobalUPSpeedLimit=512
```

### Scheduler Integration
```bash
# Apply scheduled limits
sanchala-bandwidth-scheduler apply

# Manual limit (KiB/s)
sanchala-bandwidth-scheduler limit 2048

# Remove limits
sanchala-bandwidth-scheduler unlimit
```

---

## Queue Management

```ini
Session\MaxActiveDownloads=5
Session\MaxActiveTorrents=10
Session\MaxActiveUploads=5
Session\IgnoreSlowTorrentsForQueueing=true
```

---

## Seeding Rules

```ini
Session\GlobalMaxRatio=2
Session\GlobalMaxSeedingMinutes=1440
Session\MaxRatioAction=0
```
Actions: `0` = Pause, `1` = Remove, `2` = Remove with files

---

## Directory Structure

```
~/Downloads/Torrents/
├── Incomplete/          # Active downloads
│   └── file.ext.!qB     # Incomplete files
└── [completed files]    # Finished downloads
```

---

## Search Engine

Enable built-in torrent search:
1. View → Search Engine
2. Click "Search plugins..."
3. Install plugins (1337x, TPB, YTS)

---

## CLI Usage

```bash
# Open magnet link
qbittorrent "magnet:?xt=urn:btih:..."

# Open torrent file
qbittorrent ~/Downloads/file.torrent

# Start minimized
qbittorrent --no-splash
```

---

## Troubleshooting

| Issue | Solution |
|-------|----------|
| No incoming connections | Enable UPnP or forward port 6881 |
| Slow speeds | Add more trackers, enable DHT/PeX |
| Blocked by ISP | Enable encryption, use VPN |

---

**Document Version:** 1.0 | **Author:** Download Manager Engineer

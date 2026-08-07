# 🔒 Download Privacy Guide

## Overview

Sanchala OS configures download tools with privacy-first defaults, protecting your download activity from ISPs, trackers, and malicious peers.

---

## Privacy Features

### aria2 Privacy Settings

```ini
# /etc/aria2/aria2.conf

# Require encryption for BitTorrent
bt-require-crypto=true

# No referrer header
referer=

# Generic user agent
user-agent=Mozilla/5.0 (X11; Linux x86_64; rv:120.0) Gecko/20100101 Firefox/120.0

# RPC localhost only
rpc-listen-all=false
```

### qBittorrent Privacy Settings

```ini
# Anonymous mode - hides client fingerprint
Session\AnonymousModeEnabled=true

# Force encryption on all connections
Session\Encryption=1

# IP filtering enabled
Session\IPFilter\Enabled=true
```

---

## Encryption Levels

| Level | aria2 | qBittorrent | Description |
|-------|-------|-------------|-------------|
| Prefer | `bt-require-crypto=false` | `Encryption=0` | Use if available |
| **Require** | `bt-require-crypto=true` | `Encryption=1` | **Default** |
| Disable | - | `Encryption=2` | Not recommended |

---

## IP Filtering

### Block Malicious Peers
```bash
# Download blocklist
curl -L "https://list.iblocklist.com/?list=level1" | gunzip > ~/.config/qBittorrent/ipfilter.dat

# Auto-update script
#!/bin/bash
curl -sL "https://list.iblocklist.com/?list=level1" | gunzip > ~/.config/qBittorrent/ipfilter.dat
echo "Blocklist updated: $(wc -l < ~/.config/qBittorrent/ipfilter.dat) entries"
```

---

## History Management

```ini
# /etc/sanchala/downloads/downloads.conf
[Privacy]
# Clear history on exit
clear_history_on_exit=false

# History retention (days, 0 = forever)
history_retention=30

# Secure delete incomplete files
secure_delete=false
```

### Manual History Cleanup
```bash
# Clear aria2 session
rm ~/.config/aria2/session.txt
touch ~/.config/aria2/session.txt

# Clear qBittorrent history
rm -rf ~/.local/share/qBittorrent/BT_backup/*
```

---

## VPN Integration

### Kill Switch for Downloads
Prevent downloads when VPN disconnects:

```bash
# /etc/NetworkManager/dispatcher.d/99-vpn-killswitch
#!/bin/bash
if [[ "$2" == "vpn-down" ]]; then
    systemctl --user stop sanchala-aria2@$USER.service
    pkill qbittorrent
    notify-send "VPN Disconnected" "Downloads paused for privacy"
fi
```

### Bind to VPN Interface
```ini
# qBittorrent: Settings > Advanced > Network Interface
# Set to: tun0 (or your VPN interface)
```

---

## Proxy Support

```ini
# aria2 proxy settings
# /etc/aria2/aria2.conf
all-proxy=http://127.0.0.1:8080
all-proxy-user=username
all-proxy-passwd=password

# qBittorrent proxy
# Settings > Connection > Proxy Server
```

---

## DHT Privacy Considerations

| Setting | Privacy | Speed |
|---------|---------|-------|
| DHT Enabled | Lower | Faster |
| DHT Disabled | Higher | Slower |
| PeX Enabled | Lower | Faster |
| Anonymous Mode | Higher | Normal |

**Recommendation:** Keep DHT/PeX enabled with Anonymous Mode for balance.

---

## Secure Defaults Summary

| Feature | Default | Notes |
|---------|---------|-------|
| Encryption | Required | All P2P connections |
| Anonymous Mode | Enabled | qBittorrent |
| IP Filtering | Enabled | Block known bad actors |
| RPC Access | Localhost | No remote access |
| History | 30 days | Auto-cleanup |
| Referrer | Disabled | No tracking headers |

---

**Document Version:** 1.0 | **Author:** Download Manager Engineer

# 🚀 aria2 Configuration Guide

## Overview

aria2 is the high-performance download backend for Sanchala OS, providing multi-protocol support with advanced features like segmented downloading and resume capability.

---

## Configuration Location

**System config:** `/etc/aria2/aria2.conf`
**User session:** `~/.config/aria2/session.txt`
**Logs:** `~/.config/aria2/aria2.log`

---

## Key Settings Explained

### Connection Optimization

```ini
# Maximum concurrent downloads
max-concurrent-downloads=5

# Connections per server (aggressive but polite)
max-connection-per-server=16

# Split file into segments
split=16

# Minimum segment size
min-split-size=10M
```

### Speed Limits

```ini
# Global download limit (0 = unlimited)
max-overall-download-limit=0

# Per-file limit
max-download-limit=0

# Upload limit (for seeding)
max-overall-upload-limit=100K
```

### BitTorrent Settings

```ini
# Enable DHT for better peer discovery
enable-dht=true
enable-dht6=true

# Peer Exchange
enable-peer-exchange=true

# Require encryption (privacy)
bt-require-crypto=true

# Seed ratio before stopping
seed-ratio=1.0
```

### RPC Interface

```ini
# Enable JSON-RPC for GUI integration
enable-rpc=true
rpc-listen-port=6800
rpc-listen-all=false

# Security token (change in production!)
rpc-secret=sanchala_aria2_secret
```

---

## Command Line Usage

### Start Daemon
```bash
sanchala-download-manager start
```

### Add Download
```bash
# Via command line tool
sanchala-download-manager add "https://example.com/file.zip"

# Via aria2c directly
aria2c --conf-path=/etc/aria2/aria2.conf "https://example.com/file.zip"
```

### Check Status
```bash
sanchala-download-manager status
```

---

## RPC API Examples

### Add URI
```bash
curl http://localhost:6800/jsonrpc -d '{
  "jsonrpc": "2.0",
  "method": "aria2.addUri",
  "id": "1",
  "params": ["token:sanchala_aria2_secret", ["https://example.com/file.zip"]]
}'
```

### Get Active Downloads
```bash
curl http://localhost:6800/jsonrpc -d '{
  "jsonrpc": "2.0",
  "method": "aria2.tellActive",
  "id": "2", 
  "params": ["token:sanchala_aria2_secret"]
}'
```

### Pause All
```bash
curl http://localhost:6800/jsonrpc -d '{
  "jsonrpc": "2.0",
  "method": "aria2.pauseAll",
  "id": "3",
  "params": ["token:sanchala_aria2_secret"]
}'
```

---

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Connection refused | Check if daemon is running: `pgrep aria2c` |
| Slow downloads | Increase `max-connection-per-server` |
| Resume not working | Enable `always-resume=true` |
| SSL errors | Update CA certificates: `pacman -S ca-certificates` |

---

**Document Version:** 1.0

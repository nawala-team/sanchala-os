# Sanchala OS Distribution Mirrors

> Mirror infrastructure and CDN specification

## Overview

Sanchala OS uses a tiered mirror system for global distribution with geographic redundancy and load balancing.

---

## Mirror Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                     DISTRIBUTION ARCHITECTURE                    │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│                    ┌──────────────┐                             │
│                    │   PRIMARY    │                             │
│                    │    ORIGIN    │                             │
│                    └──────┬───────┘                             │
│                           │                                     │
│              ┌────────────┼────────────┐                        │
│              ▼            ▼            ▼                        │
│       ┌──────────┐ ┌──────────┐ ┌──────────┐                   │
│       │   CDN    │ │   CDN    │ │   CDN    │                   │
│       │  (Edge)  │ │  (Edge)  │ │  (Edge)  │                   │
│       └────┬─────┘ └────┬─────┘ └────┬─────┘                   │
│            │            │            │                          │
│       ┌────┴────┐  ┌────┴────┐  ┌────┴────┐                    │
│       │ Region  │  │ Region  │  │ Region  │                    │
│       │ Mirrors │  │ Mirrors │  │ Mirrors │                    │
│       └─────────┘  └─────────┘  └─────────┘                    │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Mirror Tiers

### Tier 0: Primary Origin

Single authoritative source for all releases.

| Property | Value |
|----------|-------|
| Location | Primary datacenter |
| Sync | Source of truth |
| Access | CDN/Tier 1 only |
| Bandwidth | 10 Gbps |
| Storage | 2 TB |

### Tier 1: CDN Edge Nodes

Global content delivery network for fast downloads.

| Property | Value |
|----------|-------|
| Provider | Cloudflare / Fastly |
| Locations | 200+ global PoPs |
| Cache TTL | 24 hours (ISO), 1 hour (repo) |
| Failover | Automatic |

### Tier 2: Regional Mirrors

Community and institutional mirrors.

| Region | Mirror URL | Sponsor |
|--------|------------|---------|
| Asia | `mirror.asia.sanchala.id` | TBD |
| Europe | `mirror.eu.sanchala.id` | TBD |
| Americas | `mirror.us.sanchala.id` | TBD |
| Oceania | `mirror.au.sanchala.id` | TBD |

---

## Mirror Requirements

### Hardware Specifications

| Tier | Storage | Bandwidth | CPU | RAM |
|------|---------|-----------|-----|-----|
| Tier 1 | 500 GB | 1 Gbps | 4 cores | 8 GB |
| Tier 2 | 200 GB | 500 Mbps | 2 cores | 4 GB |

### Software Requirements

- Linux server (any distribution)
- rsync 3.1+
- nginx or Apache httpd
- HTTPS with valid certificate
- IPv4 and IPv6 support

### Sync Schedule

```bash
# Tier 1: Every 15 minutes
*/15 * * * * /usr/local/bin/sanchala-mirror-sync

# Tier 2: Every hour
0 * * * * /usr/local/bin/sanchala-mirror-sync
```

---

## Mirror Sync Script

```bash
#!/bin/bash
# /usr/local/bin/sanchala-mirror-sync

UPSTREAM="rsync://rsync.sanchala.id/sanchala"
LOCAL="/srv/mirror/sanchala"
LOCK="/var/lock/sanchala-sync.lock"
LOG="/var/log/sanchala-sync.log"

exec 200>"$LOCK"
flock -n 200 || { echo "Sync already running"; exit 1; }

rsync -avz --delete --delay-updates \
    --timeout=600 \
    --exclude='*.tmp' \
    "$UPSTREAM/" "$LOCAL/" >> "$LOG" 2>&1

# Update timestamp
date -Iseconds > "$LOCAL/lastsync"
```

---

## Directory Structure

```
/srv/mirror/sanchala/
├── iso/
│   ├── stable/
│   │   └── sanchala-1.0.0-gati-x86_64.iso
│   ├── beta/
│   └── nightly/
├── repo/
│   ├── stable/
│   │   └── x86_64/
│   │       ├── sanchala.db
│   │       └── *.pkg.tar.zst
│   ├── beta/
│   └── nightly/
├── signatures/
│   └── *.sig
├── lastsync
└── STATUS
```

---

## Mirror Status API

```json
GET https://mirrors.sanchala.id/status.json

{
  "mirrors": [
    {
      "url": "https://mirror.us.sanchala.id",
      "region": "us",
      "status": "online",
      "last_sync": "2024-08-15T10:30:00Z",
      "delay_seconds": 900,
      "bandwidth_mbps": 1000
    }
  ],
  "recommended": "https://cdn.sanchala.id"
}
```

---

## Mirrorlist Configuration

### /etc/pacman.d/mirrorlist-sanchala

```bash
# Sanchala OS Mirror List
# Generated: 2024-08-15

# CDN (recommended)
Server = https://cdn.sanchala.id/$channel/$arch

# Regional mirrors
Server = https://mirror.us.sanchala.id/$channel/$arch
Server = https://mirror.eu.sanchala.id/$channel/$arch
Server = https://mirror.asia.sanchala.id/$channel/$arch
```

### Mirror Selection Tool

```bash
#!/bin/bash
# sanchala-mirrors --rank

echo "Testing mirror speeds..."
for mirror in $(grep "^Server" /etc/pacman.d/mirrorlist-sanchala | cut -d= -f2); do
    url="${mirror/\$channel/stable}"
    url="${url/\$arch/x86_64}"
    time=$(curl -s -o /dev/null -w '%{time_total}' "$url/sanchala.db" 2>/dev/null)
    echo "$time $mirror"
done | sort -n | head -5
```

---

## Becoming a Mirror

1. **Apply:** Email mirrors@sanchala.id with server specs
2. **Setup:** Configure rsync sync from tier 1
3. **Verify:** Pass mirror health check
4. **Register:** Added to official mirrorlist

### Mirror Agreement

- Minimum 6-month commitment
- 99% uptime SLA
- Sync within 6 hours of upstream
- No modification of content
- HTTPS required

# 🌐 SANCHALA OS - Mirror Infrastructure

## Overview

Sanchala OS uses a distributed mirror network for ISO and package distribution to ensure fast downloads worldwide.

## Mirror Tiers

```
                           ┌─────────────────┐
                           │  Primary/Origin │
                           │   (repo.main)   │
                           └────────┬────────┘
                                    │
              ┌─────────────────────┼─────────────────────┐
              │                     │                     │
              ▼                     ▼                     ▼
       ┌─────────────┐       ┌─────────────┐       ┌─────────────┐
       │   Tier 1    │       │   Tier 1    │       │   Tier 1    │
       │   Europe    │       │   Americas  │       │ Asia-Pacific│
       └──────┬──────┘       └──────┬──────┘       └──────┬──────┘
              │                     │                     │
        ┌─────┴─────┐         ┌─────┴─────┐         ┌─────┴─────┐
        ▼           ▼         ▼           ▼         ▼           ▼
    ┌───────┐   ┌───────┐ ┌───────┐   ┌───────┐ ┌───────┐   ┌───────┐
    │Tier 2 │   │Tier 2 │ │Tier 2 │   │Tier 2 │ │Tier 2 │   │Tier 2 │
    │Mirror │   │Mirror │ │Mirror │   │Mirror │ │Mirror │   │Mirror │
    └───────┘   └───────┘ └───────┘   └───────┘ └───────┘   └───────┘
```

## Mirror Tiers

| Tier | Sync Frequency | Requirements | Purpose |
|------|----------------|--------------|---------|
| Origin | - | Primary infrastructure | Source of truth |
| Tier 1 | Every 2 hours | 500GB+, 1Gbps | Regional hubs |
| Tier 2 | Every 6 hours | 200GB+, 100Mbps | Local distribution |

## Directory Structure

```
/srv/mirror/sanchala/
├── iso/
│   ├── latest/
│   │   ├── sanchala-latest-gati-x86_64.iso
│   │   ├── sanchala-latest-gati-x86_64.iso.sha256
│   │   └── sanchala-latest-gati-x86_64.iso.sig
│   └── archive/
│       ├── 2024.01.01/
│       └── 2024.02.01/
├── packages/
│   └── x86_64/
│       ├── sanchala.db
│       ├── sanchala.db.sig
│       ├── sanchala.files
│       └── *.pkg.tar.zst
└── status.json
```

## Becoming a Mirror

### Requirements

**Hardware:**
- 200GB+ storage (500GB+ for Tier 1)
- 100Mbps+ bandwidth (1Gbps+ for Tier 1)
- 99.9% uptime target

**Software:**
- Linux server (any distribution)
- rsync 3.x
- nginx or Apache
- HTTPS certificate (Let's Encrypt OK)

### Setup Steps

1. **Request mirror access:**
   ```
   Email: mirrors@sanchala.id
   Subject: Mirror Application - [Country/Region]
   
   Include:
   - Server location
   - Bandwidth capacity
   - Storage capacity
   - Organization name
   - Admin contact
   ```

2. **Configure rsync:**
   ```bash
   # /etc/sanchala-mirror.conf
   UPSTREAM="rsync://rsync.sanchala.id/sanchala"
   LOCAL_PATH="/srv/mirror/sanchala"
   ```

3. **Setup sync script:**
   ```bash
   #!/bin/bash
   # /usr/local/bin/sanchala-mirror-sync
   
   UPSTREAM="rsync://rsync.sanchala.id/sanchala"
   LOCAL="/srv/mirror/sanchala"
   LOCK="/var/lock/sanchala-mirror.lock"
   LOG="/var/log/sanchala-mirror.log"
   
   exec 200>"$LOCK"
   flock -n 200 || exit 1
   
   rsync -avH --delete-after --delay-updates \
     --timeout=600 --contimeout=60 \
     "$UPSTREAM/" "$LOCAL/" >> "$LOG" 2>&1
   
   # Update status
   echo "{\"last_sync\": \"$(date -Iseconds)\", \"status\": \"ok\"}" \
     > "$LOCAL/status.json"
   ```

4. **Add cron job:**
   ```bash
   # Tier 1: every 2 hours
   0 */2 * * * /usr/local/bin/sanchala-mirror-sync
   
   # Tier 2: every 6 hours
   0 */6 * * * /usr/local/bin/sanchala-mirror-sync
   ```

5. **Configure web server:**
   ```nginx
   # /etc/nginx/sites-available/sanchala-mirror
   server {
       listen 443 ssl http2;
       server_name mirror.example.com;
       
       ssl_certificate /etc/letsencrypt/live/mirror.example.com/fullchain.pem;
       ssl_certificate_key /etc/letsencrypt/live/mirror.example.com/privkey.pem;
       
       root /srv/mirror/sanchala;
       autoindex on;
       
       location / {
           try_files $uri $uri/ =404;
       }
   }
   ```

## Mirror List

Official mirrors are listed at: https://sanchala.id/mirrors

### Mirrorlist Format
```
# /etc/pacman.d/sanchala-mirrorlist
# Sanchala OS Mirror List
# Generated: 2024-01-01

## Worldwide (CDN)
Server = https://cdn.sanchala.id/packages/$arch

## Europe
Server = https://eu.mirror.sanchala.id/packages/$arch

## North America  
Server = https://us.mirror.sanchala.id/packages/$arch

## Asia Pacific
Server = https://ap.mirror.sanchala.id/packages/$arch
```

## Mirror Monitoring

Mirrors are monitored for:
- Sync freshness (< 6 hours for Tier 1, < 12 hours for Tier 2)
- HTTP/HTTPS availability
- Response time
- Content integrity (random file checks)

Status dashboard: https://status.sanchala.id/mirrors

## Contact

- Mirror operations: mirrors@sanchala.id
- Status updates: https://status.sanchala.id

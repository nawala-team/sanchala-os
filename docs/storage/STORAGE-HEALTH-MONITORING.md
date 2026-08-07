# 🏥 SANCHALA OS - Storage Health Monitoring Specification

## Overview

Sanchala OS implements comprehensive storage health monitoring to ensure data integrity, predict failures, and maintain optimal performance.

---

## 🎯 Monitoring Components

```
┌─────────────────────────────────────────────────────────────────┐
│                 STORAGE HEALTH MONITORING                       │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐          │
│  │    S.M.A.R.T │  │    Btrfs     │  │    LUKS      │          │
│  │   Monitoring │  │    Scrub     │  │   Health     │          │
│  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘          │
│         │                 │                 │                   │
│         └─────────────────┼─────────────────┘                   │
│                           ▼                                     │
│              ┌─────────────────────────┐                        │
│              │   sanchala-guardian     │                        │
│              │   (unified monitoring)  │                        │
│              └────────────┬────────────┘                        │
│                           │                                     │
│         ┌─────────────────┼─────────────────┐                   │
│         ▼                 ▼                 ▼                   │
│  ┌────────────┐   ┌────────────┐   ┌────────────┐              │
│  │   Alerts   │   │   Logs     │   │  KDE Widget │              │
│  │ (Desktop)  │   │ (journald) │   │  (Status)   │              │
│  └────────────┘   └────────────┘   └────────────┘              │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## 📊 Monitored Metrics

### S.M.A.R.T (HDD/SSD Health)
| Metric | Warning | Critical | Action |
|--------|---------|----------|--------|
| Reallocated Sectors | > 0 | > 100 | Backup immediately |
| Pending Sectors | > 0 | > 10 | Schedule replacement |
| Temperature | > 50°C | > 60°C | Check cooling |
| Power-On Hours | > 30000 | > 50000 | Plan replacement |
| Wear Level (SSD) | < 20% | < 10% | Replace SSD |

### Btrfs Filesystem
| Metric | Warning | Critical | Action |
|--------|---------|----------|--------|
| Free Space | < 20% | < 10% | Cleanup/expand |
| Metadata Space | < 15% | < 5% | Balance metadata |
| Scrub Errors | > 0 | > 10 | Check drive |
| Checksum Errors | Any | Any | Immediate attention |
| Last Scrub Age | > 30 days | > 60 days | Run scrub |

### Snapshot Management
| Metric | Warning | Critical | Action |
|--------|---------|----------|--------|
| Snapshot Count | > 100 | > 200 | Cleanup old snapshots |
| Snapshot Space | > 40% | > 60% | Adjust retention |
| Failed Cleanup | Any | Repeated | Check snapper config |

---

## 🔧 Systemd Services

### btrfs-scrub Timer
```ini
# /etc/systemd/system/btrfs-scrub@.timer
[Unit]
Description=Weekly Btrfs scrub on %f

[Timer]
OnCalendar=weekly
RandomizedDelaySec=6h
Persistent=true

[Install]
WantedBy=timers.target
```

### smartd Service
```ini
# /etc/smartd.conf
# Monitor all drives, alert on issues
DEVICESCAN -a -o on -S on -n standby,q \
    -W 4,45,55 \
    -m root \
    -M exec /usr/lib/sanchala/smartd-notify
```

### Storage Monitor Service
```ini
# /etc/systemd/system/sanchala-storage-monitor.service
[Unit]
Description=Sanchala Storage Health Monitor
After=local-fs.target

[Service]
Type=simple
ExecStart=/usr/lib/sanchala/storage-monitor
Restart=always

[Install]
WantedBy=multi-user.target
```

---

## 📝 Monitoring Scripts

### Daily Health Check
```bash
#!/bin/bash
# /usr/lib/sanchala/storage-health-check

# Check Btrfs filesystem status
btrfs device stats / | grep -v ' 0 && \
    notify-send -u critical "Btrfs Errors Detected" "Check storage health"

# Check free space
FREE_PCT=$(df / --output=pcent | tail -1 | tr -d ' %')
if [ "$FREE_PCT" -gt 90 ]; then
    notify-send -u critical "Low Disk Space" "Only $((100-FREE_PCT))% free"
elif [ "$FREE_PCT" -gt 80 ]; then
    notify-send -u normal "Disk Space Warning" "$((100-FREE_PCT))% free"
fi

# Check SMART status
for disk in /dev/sd? /dev/nvme?n1; do
    [ -b "$disk" ] || continue
    smartctl -H "$disk" | grep -q "PASSED" || \
        notify-send -u critical "SMART Warning" "$disk health check failed"
done
```

---

## 🖥️ User Interface Integration

### KDE Plasma Widget
The `sanchala-guardian` widget displays:
- Storage health status (green/yellow/red)
- Free space percentage
- Last snapshot time
- Last scrub time
- SMART status summary

### CLI Tool
```bash
# Quick status
sanchala-storage status

# Detailed report
sanchala-storage report

# Run scrub now
sanchala-storage scrub

# Check SMART
sanchala-storage smart
```

---

## 🚨 Alert Levels

| Level | Color | Action |
|-------|-------|--------|
| Healthy | 🟢 Green | Normal operation |
| Warning | 🟡 Yellow | Desktop notification |
| Critical | 🔴 Red | Notification + sound + persistent |
| Emergency | ⚫ Black | Full-screen alert, prevent data loss |

---

## 📦 Required Packages

```yaml
packages:
  - smartmontools    # S.M.A.R.T monitoring
  - btrfs-progs      # Btrfs utilities
  - snapper          # Snapshot management
  - grub-btrfs       # GRUB snapshot integration
  - compsize         # Compression statistics
```

---

## 🔍 Manual Health Commands

```bash
# === Btrfs Health ===
# Check device statistics (errors)
sudo btrfs device stats /

# Filesystem usage
sudo btrfs filesystem usage /

# Start manual scrub
sudo btrfs scrub start /

# Check scrub status
sudo btrfs scrub status /

# === S.M.A.R.T Health ===
# Quick health check
sudo smartctl -H /dev/nvme0n1

# Full SMART data
sudo smartctl -a /dev/nvme0n1

# Run self-test
sudo smartctl -t short /dev/nvme0n1

# === LUKS Health ===
# Check LUKS header
sudo cryptsetup luksDump /dev/nvme0n1p2

# Verify key slots
sudo cryptsetup luksDump /dev/nvme0n1p2 | grep "Key Slot"
```

---

**Document Version:** 1.0  
**Last Updated:** August 2026  
**Author:** Storage Systems Engineering Team

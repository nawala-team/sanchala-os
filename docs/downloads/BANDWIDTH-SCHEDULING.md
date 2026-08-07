# ⏰ Bandwidth Scheduling Guide

## Overview

Sanchala OS includes intelligent bandwidth scheduling to manage download speeds based on time of day, network conditions, and power state.

---

## Schedule Configuration

### Default Schedule

| Time Period | Download Limit | Upload Limit |
|-------------|---------------|--------------|
| 09:00 - 17:00 (Work) | 2048 KiB/s | 512 KiB/s |
| 17:00 - 09:00 (Off) | Unlimited | Unlimited |
| Weekends | Unlimited | Unlimited |

### Configuration File

Edit `/etc/sanchala/downloads/downloads.conf`:

```ini
[Bandwidth]
schedule_enabled=true
schedule_start=09:00
schedule_end=17:00
schedule_download_limit=2048
schedule_upload_limit=512
```

---

## Automatic Conditions

### Battery Awareness
Downloads pause or throttle on low battery (<20%) when `pause_on_battery=true`.

### Metered Connection Detection
Limits bandwidth on metered connections when `pause_on_metered=true`.

---

## Manual Control

```bash
# Set custom limit (KiB/s)
sanchala-bandwidth-scheduler limit 1024

# Remove all limits
sanchala-bandwidth-scheduler unlimit

# Check current status
sanchala-bandwidth-scheduler status
```

---

## Systemd Service

```bash
# Enable auto-start
systemctl --user enable sanchala-bandwidth-scheduler.timer

# Start now
systemctl --user start sanchala-bandwidth-scheduler.timer
```

---

**Document Version:** 1.0

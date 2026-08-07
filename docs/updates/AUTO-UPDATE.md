# ⚙️ SANCHALA OS - Auto-Update Configuration

## Overview

Sanchala OS supports fully automatic updates with configurable policies for download, installation timing, and safety checks.

---

## 🎛️ Auto-Update Modes

| Mode | Downloads | Installs | Best For |
|------|-----------|----------|----------|
| **Notify Only** | ❌ | ❌ | Power users |
| **Download Only** | ✅ | ❌ | Default - Desktop users |
| **Full Auto** | ✅ | ✅ | Servers, kiosks |

---

## 🔧 Configuration

### Enable Auto-Updates

```bash
# Enable the timer
sudo systemctl enable --now sanchala-updater.timer

# Check timer status
systemctl status sanchala-updater.timer
```

### Configuration File

Edit `/etc/sanchala-updater/updater.conf`:

```bash
# ============================================
# MODE: Download Only (Default)
# ============================================
CHECK_INTERVAL=3600          # Check every hour
AUTO_DOWNLOAD=true           # Download updates
AUTO_INSTALL=false           # Don't auto-install

# ============================================
# MODE: Full Auto
# ============================================
CHECK_INTERVAL=3600
AUTO_DOWNLOAD=true
AUTO_INSTALL=true            # Auto-install enabled
UPDATE_WINDOW_START="02:00"  # Install between 2-6 AM
UPDATE_WINDOW_END="06:00"

# ============================================
# MODE: Notify Only
# ============================================
CHECK_INTERVAL=3600
AUTO_DOWNLOAD=false
AUTO_INSTALL=false
NOTIFY_UPDATES=true          # Just notify
```

---

## ⏰ Update Windows

Control when automatic installations occur:

```bash
# Install only during night hours
UPDATE_WINDOW_START="02:00"
UPDATE_WINDOW_END="06:00"

# Specific days only (0=Sunday, 6=Saturday)
UPDATE_DAYS="0,6"    # Weekends only
UPDATE_DAYS="1,2,3,4,5"  # Weekdays only
```

---

## 🔒 Safety Checks

Auto-updates include safety guards:

```bash
# Minimum free disk space (GB)
MIN_FREE_SPACE=2

# Minimum battery level (laptops)
MIN_BATTERY=20

# Require AC power for updates
REQUIRE_AC_POWER=false
```

If any check fails, the update is deferred.

---

## 🔔 Notifications

```bash
# Desktop notifications (notify-send)
NOTIFY_DESKTOP=true

# System log (journald)
NOTIFY_SYSTEM=true

# Notify when updates available
NOTIFY_UPDATES=true

# Notify when reboot needed
NOTIFY_REBOOT=true
```

---

## 📋 Systemd Units

### Timer Configuration

`/etc/systemd/system/sanchala-updater.timer`:
```ini
[Timer]
OnBootSec=5min           # First check 5 min after boot
OnUnitActiveSec=1h       # Then every hour
RandomizedDelaySec=10min # Randomize to reduce server load
Persistent=true          # Catch up missed checks
```

### Service Configuration

`/etc/systemd/system/sanchala-updater.service`:
```ini
[Service]
Type=simple
ExecStart=/usr/bin/sanchala-updater daemon
Nice=19                  # Low priority
IOSchedulingClass=idle   # Don't impact user I/O
```

---

## 🛠️ Management Commands

```bash
# Enable auto-updates
sudo systemctl enable --now sanchala-updater.timer

# Disable auto-updates
sudo systemctl disable --now sanchala-updater.timer

# Check next scheduled run
systemctl list-timers sanchala-updater.timer

# View auto-update logs
journalctl -u sanchala-updater -f

# Trigger immediate check
sudo systemctl start sanchala-updater.service
```

---

## 🎯 Recommended Settings

### Desktop Users
```bash
AUTO_DOWNLOAD=true
AUTO_INSTALL=false
NOTIFY_UPDATES=true
```
Updates download in background; user decides when to install.

### Servers
```bash
AUTO_DOWNLOAD=true
AUTO_INSTALL=true
UPDATE_WINDOW_START="03:00"
UPDATE_WINDOW_END="05:00"
```
Fully automatic with maintenance window.

### Laptops
```bash
AUTO_DOWNLOAD=true
AUTO_INSTALL=false
MIN_BATTERY=30
REQUIRE_AC_POWER=true
```
Download on AC power only.

---

**Document Version:** 1.0  
**Last Updated:** August 2026

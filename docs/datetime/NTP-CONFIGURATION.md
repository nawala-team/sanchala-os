# NTP Configuration Guide

## Overview

SANCHALA OS uses systemd-timesyncd for network time synchronization, configured with reliable public NTP pools and enhanced monitoring.

## Configuration Files

### Main Configuration
**Location**: `/etc/systemd/timesyncd.conf`

```ini
[Time]
NTP=0.pool.ntp.org 1.pool.ntp.org 2.pool.ntp.org 3.pool.ntp.org
FallbackNTP=time.cloudflare.com time.google.com time.facebook.com
RootDistanceMaxSec=5
PollIntervalMinSec=32
PollIntervalMaxSec=2048
```

### Regional Drop-in
**Location**: `/etc/systemd/timesyncd.conf.d/50-sanchala.conf`

Uncomment your region for better latency:
```ini
# Americas
NTP=0.north-america.pool.ntp.org 1.north-america.pool.ntp.org

# Europe
NTP=0.europe.pool.ntp.org 1.europe.pool.ntp.org

# Asia
NTP=0.asia.pool.ntp.org 1.asia.pool.ntp.org
```

## NTP Servers

### Primary (pool.ntp.org)
- Geographically distributed
- Automatic nearest-server routing
- High availability

### Fallback Servers
| Server | Provider | Features |
|--------|----------|----------|
| time.cloudflare.com | Cloudflare | NTS support |
| time.google.com | Google | Leap smear |
| time.facebook.com | Meta | High precision |
| time.apple.com | Apple | Reliable |

## Commands

### Check Status
```bash
# Overall time status
timedatectl status

# NTP sync details
timedatectl timesync-status

# Show current NTP server
timedatectl show-timesync --property=ServerName
```

### Enable/Disable NTP
```bash
# Enable network time sync
sudo timedatectl set-ntp true

# Disable (for manual time)
sudo timedatectl set-ntp false
```

### Force Sync
```bash
# Restart timesyncd to force immediate sync
sudo systemctl restart systemd-timesyncd
```

### View Logs
```bash
journalctl -u systemd-timesyncd -f
```

## Network Time Security (NTS)

NTS provides authenticated time synchronization:

```ini
[Sanchala]
EnableNTS=true
NTSServers=time.cloudflare.com
```

Benefits:
- Prevents time spoofing attacks
- Encrypted communication
- Server authentication

## Battery Optimization

On battery power, polling interval increases to conserve power:

```ini
BatterySaverMode=true
BatteryPollIntervalSec=300
```

## Troubleshooting

### Time Not Syncing
1. Check network connectivity
2. Verify firewall allows UDP port 123
3. Check service status: `systemctl status systemd-timesyncd`

### Large Time Drift
- Check hardware clock: `sudo hwclock --show`
- Sync hardware clock: `sudo hwclock --systohc`

### Corporate Networks
Add internal NTP server:
```ini
NTP=ntp.company.local 0.pool.ntp.org
```

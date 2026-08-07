# Log Rotation Configuration

Sanchala OS uses logrotate for automatic log management, keeping logs organized and preventing disk space issues.

## Overview

Log rotation automatically:
- Compresses old logs to save space
- Removes logs older than retention period
- Creates new log files with proper permissions
- Prevents runaway log growth

## Configuration Files

### Main Configuration
- `/etc/logrotate.conf` - Global settings
- `/etc/logrotate.d/` - Application-specific configs

### Sanchala Logs
- `/etc/logrotate.d/sanchala` - All Sanchala tools

## Sanchala Log Rotation

| Log | Rotation | Keep | Compress |
|-----|----------|------|----------|
| cleaner.log | Weekly | 4 copies | Yes |
| updater.log | Weekly | 4 copies | Yes |
| backup.log | Weekly | 8 copies | Yes |
| guardian.log | Daily | 14 copies | Yes |

## Configuration Example

```
/var/log/sanchala/*.log {
    weekly              # Rotate weekly
    rotate 4            # Keep 4 old versions
    compress            # Compress rotated logs
    delaycompress       # Delay compression by 1 cycle
    missingok           # Don't error if log missing
    notifempty          # Don't rotate empty logs
    create 0640 root root  # New log permissions
}
```

## Manual Operations

```bash
# Force rotation now
sudo logrotate -f /etc/logrotate.conf

# Test configuration (dry run)
sudo logrotate -d /etc/logrotate.d/sanchala

# Check logrotate status
cat /var/lib/logrotate/status
```

## Journal Configuration

Systemd journal has separate configuration:

```ini
# /etc/systemd/journald.conf.d/sanchala.conf
[Journal]
SystemMaxUse=500M
MaxRetentionSec=30day
Compress=yes
```

```bash
# Check journal size
journalctl --disk-usage

# Clean journal manually
sudo journalctl --vacuum-size=500M
sudo journalctl --vacuum-time=30d
```

## Best Practices

1. **Don't disable rotation** - Logs can fill disk quickly
2. **Keep security logs longer** - guardian.log keeps 14 days
3. **Compress old logs** - Saves significant space
4. **Monitor log growth** - Check `/var/log` periodically

## Troubleshooting

### Logs Not Rotating
```bash
# Check for errors
sudo logrotate -v /etc/logrotate.conf

# Verify cron/timer is running
systemctl status logrotate.timer
```

### Log Permissions Issues
```bash
# Fix permissions
sudo chown root:root /var/log/sanchala/*.log
sudo chmod 640 /var/log/sanchala/*.log
```

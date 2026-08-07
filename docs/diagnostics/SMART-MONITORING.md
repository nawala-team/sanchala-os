# SMART Disk Health Monitoring

Sanchala OS includes comprehensive disk health monitoring using smartmontools.

## Overview

SMART (Self-Monitoring, Analysis, and Reporting Technology) monitors hard drives and SSDs for signs of impending failure, giving you time to backup data before a drive fails.

## Quick Start

```bash
# Check all drives
sanchala-diagnostics smart

# Check specific drive
sanchala-diagnostics smart /dev/sda

# Full health check
sanchala-diagnostics health
```

## Understanding SMART Data

### Health Status

```bash
$ sudo smartctl -H /dev/sda
SMART overall-health self-assessment test result: PASSED
```

- **PASSED**: Drive is healthy
- **FAILED**: Drive failure imminent - backup immediately!

### Key Attributes

| Attribute | Description | Warning Sign |
|-----------|-------------|--------------|
| Reallocated_Sector_Ct | Bad sectors remapped | Value > 0 increasing |
| Current_Pending_Sector | Sectors waiting for remap | Value > 0 |
| Offline_Uncorrectable | Uncorrectable read errors | Value > 0 |
| UDMA_CRC_Error_Count | Cable/connection errors | Rapidly increasing |
| Temperature_Celsius | Drive temperature | > 50°C sustained |
| Power_On_Hours | Total runtime | Varies by drive |
| Wear_Leveling_Count | SSD wear (SSDs only) | < 10% remaining |

### SSD-Specific Attributes

| Attribute | Description |
|-----------|-------------|
| Wear_Leveling_Count | Remaining lifespan percentage |
| Total_LBAs_Written | Total data written |
| Media_Wearout_Indicator | Overall SSD health |

## Automated Monitoring

### Enable smartd Service

```bash
# Enable SMART daemon
sudo systemctl enable --now smartd

# Configure monitoring
sudo nano /etc/smartd.conf
```

### smartd.conf Configuration

```conf
# Monitor all drives, email on issues
DEVICESCAN -a -o on -S on -n standby,q -s (S/../.././02|L/../../6/03) -W 4,45,55 -m root

# Or monitor specific drives
/dev/sda -a -o on -S on -W 4,45,55 -m root
/dev/nvme0 -a -o on -S on -W 4,45,55 -m root
```

### Integration with Sanchala

Sanchala Diagnostics automatically:
1. Checks SMART status during health checks
2. Displays warnings in system overview
3. Can send desktop notifications on failures

## Running SMART Tests

### Short Test (2-3 minutes)
```bash
sudo smartctl -t short /dev/sda
# Wait for completion
sudo smartctl -l selftest /dev/sda
```

### Long Test (hours)
```bash
sudo smartctl -t long /dev/sda
# Check progress
sudo smartctl -c /dev/sda
```

### Conveyance Test (after transport)
```bash
sudo smartctl -t conveyance /dev/sda
```

## NVMe Drives

NVMe drives use different commands:

```bash
# NVMe health
sudo smartctl -a /dev/nvme0

# Or use nvme-cli
sudo nvme smart-log /dev/nvme0
```

### NVMe Health Indicators

| Field | Description |
|-------|-------------|
| Percentage Used | Wear level (0-100%+) |
| Available Spare | Spare blocks remaining |
| Temperature | Current temperature |
| Data Units Written | Total writes |
| Power On Hours | Runtime hours |

## Interpreting Results

### Good Drive
```
SMART overall-health: PASSED
Reallocated_Sector_Ct: 0
Current_Pending_Sector: 0
Temperature: 35°C
```

### Warning Signs
```
Reallocated_Sector_Ct: 50 (increasing)
Current_Pending_Sector: 2
```
→ Backup data, consider replacement

### Critical
```
SMART overall-health: FAILED
```
→ Immediate backup, replace drive ASAP

## Troubleshooting

### SMART not supported
```bash
# Check if drive supports SMART
sudo smartctl -i /dev/sda

# Enable SMART if disabled
sudo smartctl -s on /dev/sda
```

### Permission denied
```bash
# Requires root access
sudo sanchala-diagnostics smart /dev/sda
```

### USB drives
```bash
# May need device type specification
sudo smartctl -d sat /dev/sdb
```

## Best Practices

1. **Regular Checks**: Run health checks weekly
2. **Monitor Temperatures**: Keep drives under 50°C
3. **Watch Trends**: Increasing bad sectors = failing drive
4. **Test New Drives**: Run extended test on new drives
5. **Backup First**: Always have backups before drive shows issues

## See Also

- [Diagnostics Overview](DIAGNOSTICS.md)
- [Disk Management](../storage/DISK-MANAGEMENT.md)
- [Backup Guide](../backup/BACKUP.md)

# Sanchala Diagnostics

macOS-style Activity Monitor + System Information tool for Sanchala OS.

## Features

### Activity Monitor (Process Management)
- Real-time process monitoring with btop/htop integration
- CPU, memory, disk I/O per process
- Kill/terminate processes
- Set process priorities (nice values)
- Sort by CPU, memory, PID, or runtime

### System Information
- **CPU**: Model, cores, threads, frequencies, governor, virtualization support
- **Memory**: Total, used, available, buffers, cache, swap
- **Storage**: Disk usage, partitions, mount points, SMART health
- **Network**: Interfaces, IP addresses, routing, DNS, bandwidth
- **Hardware**: PCI devices, USB devices, sensors, battery, display, audio

### Diagnostics
- System health checks with thresholds
- SMART disk monitoring via smartctl
- Network connectivity tests (ping, traceroute, DNS)
- Quick system benchmarks
- Log analysis and error detection

## Usage

```bash
# System overview (default)
sanchala-diagnostics

# Quick health summary
sanchala-diagnostics summary

# Open system monitor (btop/htop)
sanchala-diagnostics top

# CPU information
sanchala-diagnostics cpu

# Memory details
sanchala-diagnostics memory

# Disk SMART status
sanchala-diagnostics smart /dev/sda

# Network diagnostics
sanchala-diagnostics network
sanchala-diagnostics ping google.com

# Hardware information
sanchala-diagnostics hardware
sanchala-diagnostics sensors
sanchala-diagnostics battery

# Health check
sanchala-diagnostics health

# Generate report
sanchala-diagnostics report --export ~/system-report.txt

# JSON output
sanchala-diagnostics overview --json
```

## Commands

| Command | Description |
|---------|-------------|
| `overview` | Complete system overview (default) |
| `summary` | Quick health summary |
| `top` | Launch system monitor (btop/htop/top) |
| `processes` | List processes with resource usage |
| `cpu` | CPU information and usage |
| `memory` | Memory usage details |
| `swap` | Swap configuration |
| `load` | System load averages |
| `disk` | Disk usage overview |
| `smart` | SMART health status |
| `io` | Disk I/O statistics |
| `mounts` | Mounted filesystems |
| `partitions` | Partition layout |
| `network` | Network interface status |
| `connections` | Active connections |
| `ports` | Open ports |
| `ping` | Connectivity test |
| `traceroute` | Network path trace |
| `hardware` | Hardware information |
| `pci` | PCI devices |
| `usb` | USB devices |
| `sensors` | Temperature/fan sensors |
| `battery` | Battery status |
| `health` | System health check |
| `benchmark` | Quick benchmark |
| `logs` | System logs viewer |

## Configuration

Configuration file: `/etc/sanchala/diagnostics/diagnostics.toml`

```toml
[thresholds]
cpu_warning = 80
cpu_critical = 95
memory_warning = 80
memory_critical = 95
disk_warning = 80
disk_critical = 95

[smart]
enabled = true
check_interval = 24
```

## Dependencies

**Required**: bash, coreutils, procps

**Optional** (enhanced features):
- `btop` / `htop` - Interactive system monitor
- `smartmontools` - SMART disk monitoring
- `lm_sensors` - Temperature sensors
- `pciutils` - PCI device info
- `usbutils` - USB device info
- `sysstat` - I/O statistics
- `vnstat` - Bandwidth monitoring

## Integration

- **Plasma Widget**: `org.sanchala.sysmonitor` provides panel integration
- **Quick Settings**: Access via Control Center
- **Keyboard Shortcut**: `Ctrl+Alt+Delete` opens system monitor

## License

GPL-3.0 - Sanchala Team

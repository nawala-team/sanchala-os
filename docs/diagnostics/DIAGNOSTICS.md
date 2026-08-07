# Sanchala OS Diagnostics

System diagnostics and monitoring tools for Sanchala OS, providing macOS-style Activity Monitor and System Information functionality.

## Overview

Sanchala Diagnostics provides comprehensive system monitoring and hardware information tools, designed to give users full visibility into their system's performance and health.

## Tools

### sanchala-diagnostics

The main CLI tool for system diagnostics and monitoring.

```bash
# Quick overview
sanchala-diagnostics

# Detailed commands
sanchala-diagnostics cpu
sanchala-diagnostics memory
sanchala-diagnostics disk
sanchala-diagnostics network
sanchala-diagnostics hardware
```

See [Tool README](../../tools/sanchala-diagnostics/README.md) for full documentation.

### System Monitor Widget

The `org.sanchala.sysmonitor` Plasma widget provides:
- Real-time CPU usage in panel
- Memory usage indicator
- Click to expand for details
- Quick access to full system monitor

### btop Integration

Sanchala OS includes a customized btop configuration with:
- Sanchala color theme
- Optimized layout
- Temperature monitoring
- Network throughput display

## Features

### Process Monitoring (Activity Monitor)
- Real-time process list
- CPU/Memory per process
- Kill and priority management
- Tree view support

### System Information
| Category | Information |
|----------|-------------|
| CPU | Model, cores, frequency, governor, virtualization |
| Memory | Total, used, available, buffers, cache |
| Storage | Usage, partitions, SMART health |
| Network | Interfaces, IPs, routing, DNS |
| Hardware | PCI, USB, sensors, battery |

### Health Monitoring
- Automatic threshold alerts
- SMART disk monitoring
- Temperature warnings
- Network connectivity checks

## Architecture

```
sanchala-diagnostics/
├── sanchala-diagnostics     # Main CLI tool
├── lib/
│   ├── system.sh            # System overview functions
│   ├── process.sh           # Process management
│   ├── disk.sh              # Disk/SMART monitoring
│   ├── network.sh           # Network diagnostics
│   └── hardware.sh          # Hardware information
├── config/
│   ├── diagnostics.toml     # Main configuration
│   └── btop.conf            # btop theme/settings
└── scripts/
    └── install.sh           # Installation script
```

## Configuration

### Thresholds

Edit `/etc/sanchala/diagnostics/diagnostics.toml`:

```toml
[thresholds]
cpu_warning = 80        # Yellow warning at 80%
cpu_critical = 95       # Red alert at 95%
memory_warning = 80
memory_critical = 95
disk_warning = 80
disk_critical = 95
temperature_warning = 70
temperature_critical = 85
```

### SMART Monitoring

```toml
[smart]
enabled = true
check_interval = 24     # Hours between checks
devices = []            # Auto-detect if empty
alert_on_warning = true
```

## Dependencies

| Package | Purpose | Required |
|---------|---------|----------|
| bash | Shell scripting | Yes |
| coreutils | Basic utilities | Yes |
| procps-ng | Process utilities | Yes |
| btop | System monitor | Recommended |
| smartmontools | SMART monitoring | Recommended |
| lm_sensors | Temperature sensors | Optional |
| pciutils | PCI device info | Optional |
| usbutils | USB device info | Optional |

## Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| `Ctrl+Alt+Delete` | Open System Monitor |
| `Meta+Shift+S` | Quick system summary |

## Comparison with macOS

| macOS Feature | Sanchala Equivalent |
|---------------|---------------------|
| Activity Monitor | `sanchala-diagnostics top` (btop) |
| System Information | `sanchala-diagnostics hardware` |
| Disk Utility SMART | `sanchala-diagnostics smart` |
| Network Utility | `sanchala-diagnostics network` |
| Console.app | `sanchala-diagnostics logs` |

## Troubleshooting

### SMART not working
```bash
# Install smartmontools
sudo pacman -S smartmontools

# Check if drive supports SMART
sudo smartctl -i /dev/sda
```

### No temperature readings
```bash
# Install and configure sensors
sudo pacman -S lm_sensors
sudo sensors-detect
sensors
```

### btop not showing GPU
```bash
# Install GPU monitoring support
sudo pacman -S nvtop  # NVIDIA
sudo pacman -S radeontop  # AMD
```

## See Also

- [Performance Tuning](../performance/TUNING.md)
- [System Monitor Widget](../settings/WIDGETS.md)
- [Troubleshooting Guide](../user-guide/TROUBLESHOOTING.md)

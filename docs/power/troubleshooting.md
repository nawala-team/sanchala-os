# 🔧 Power Troubleshooting

## Diagnostic Commands

```bash
# Full TLP status
sudo tlp-stat

# Power profile
powerprofilesctl get

# What's using power
sudo powertop

# Battery details
upower -i /org/freedesktop/UPower/devices/battery_BAT0

# CPU frequencies
cat /proc/cpuinfo | grep MHz
```

## Common Issues

### Short Battery Life

```bash
# Find power hogs
sudo powertop

# Check if TLP is running
systemctl status tlp

# Verify power profile
powerprofilesctl get  # Should be "power-saver" on battery
```

### System Won't Suspend

```bash
# Check inhibitors
systemd-inhibit --list

# Check supported states
cat /sys/power/state

# Test suspend
sudo systemctl suspend
```

### Won't Wake from Hibernate

1. Verify swap ≥ RAM: `free -h`
2. Check resume parameter: `cat /proc/cmdline | grep resume`
3. Check logs: `journalctl -b -1 | grep -i hibernate`

### Charging Thresholds Not Working

```bash
# Check if driver loaded (ThinkPad)
lsmod | grep -E "tp_smapi|acpi_call"

# Check threshold status
tlp-stat -b | grep -i threshold
```

### High CPU Temperature

```bash
# Check current governor
cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor

# Check if turbo is disabled on battery
cat /sys/devices/system/cpu/intel_pstate/no_turbo
```

## Reset to Defaults

```bash
# Reload TLP configuration
sudo tlp start

# Restart power-profiles-daemon
sudo systemctl restart power-profiles-daemon
```

---
**Document Version:** 1.0

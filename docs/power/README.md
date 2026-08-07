# 🔋 SANCHALA OS Power Management

Sanchala OS implements intelligent power management targeting MacBook-level battery life on Linux.

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│               SANCHALA POWER MANAGEMENT STACK                   │
├─────────────────────────────────────────────────────────────────┤
│  User Interface (KDE Power Settings / sanchala-power-mgr)       │
├─────────────────────────────────────────────────────────────────┤
│  power-profiles-daemon (D-Bus API for desktop integration)      │
├─────────────────────────────────────────────────────────────────┤
│  TLP (Advanced power management for laptops)                    │
├─────────────────────────────────────────────────────────────────┤
│  Thermal / Sleep / Battery Health layers                        │
├─────────────────────────────────────────────────────────────────┤
│  Kernel (sysctl, cpufreq, ASPM, runtime PM)                     │
├─────────────────────────────────────────────────────────────────┤
│  Hardware (CPU P-states, GPU DPM, NVMe APST, WiFi PS)           │
└─────────────────────────────────────────────────────────────────┘
```

## Power Profiles

| Profile | CPU Governor | Turbo | Expected Battery |
|---------|--------------|-------|------------------|
| **Power Saver** | powersave | Off | 100% baseline |
| **Balanced** | schedutil | Auto | ~85% of baseline |
| **Performance** | performance | On | ~60% of baseline |

### Switching Profiles

```bash
# Via power-profiles-daemon
powerprofilesctl set power-saver

# Via TLP
sudo tlp bat    # Battery mode
sudo tlp ac     # AC mode
```

## Documentation

- [Battery Health Guide](battery-health.md) - Charging thresholds & longevity
- [Sleep Configuration](sleep-hibernate.md) - Suspend/hibernate settings
- [Thermal Management](thermal.md) - Temperature control
- [Troubleshooting](troubleshooting.md) - Common issues & fixes

## Configuration Files

| File | Purpose |
|------|---------|
| `/etc/tlp.d/00-sanchala-base.conf` | Core TLP settings |
| `/etc/tlp.d/01-sanchala-peripherals.conf` | USB/PCIe/Audio power |
| `/etc/tlp.d/10-sanchala-battery-health.conf` | Charging thresholds |
| `/etc/systemd/sleep.conf.d/sanchala-sleep.conf` | Sleep configuration |
| `/etc/systemd/logind.conf.d/sanchala-power.conf` | Lid/button behavior |
| `/etc/sanchala/power/thermal.conf` | Thermal management |

## Required Packages

```bash
sudo pacman -S tlp tlp-rdw power-profiles-daemon powertop upower
# ThinkPad: sudo pacman -S acpi_call-dkms tp_smapi-dkms
```

---
**Document Version:** 1.0 | **Last Updated:** August 2026

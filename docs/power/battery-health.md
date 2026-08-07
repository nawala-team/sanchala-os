# 🔋 Battery Health Guide

Sanchala implements smart charging to extend battery lifespan, similar to macOS "Optimized Battery Charging".

## Charging Modes

| Mode | Start | Stop | Use Case | Lifespan Benefit |
|------|-------|------|----------|------------------|
| **Maximum Longevity** | 40% | 80% | Always plugged in | 3-4x longer |
| **Balanced** | 30% | 85% | Normal laptop use | 2-3x longer |
| **Full Charge** | 95% | 100% | Before travel | None |
| **Travel** | 20% | 100% | Extended trips | None |

## How It Works

**Start Threshold**: Battery won't charge until it drops below this level.
**Stop Threshold**: Charging stops when battery reaches this level.

Example with "Maximum Longevity" (40%/80%):
- Battery at 75%: No charging occurs
- Battery drops to 39%: Charging begins
- Battery reaches 80%: Charging stops

## Supported Hardware

| Vendor | Driver | Support Level |
|--------|--------|---------------|
| ThinkPad | tp_smapi / acpi_call | ⭐ Full |
| ASUS | asus-wmi | ⭐ Full |
| Huawei | huawei-wmi | ⭐ Full |
| LG | lg-laptop | Good |
| Samsung | samsung-laptop | Good |
| Framework | ectool | ⭐ Full |
| System76 | system76-power | ⭐ Full |

## Configuration

Thresholds are set in `/etc/tlp.d/10-sanchala-battery-health.conf`:

```bash
# ThinkPad
START_CHARGE_THRESH_BAT0=40
STOP_CHARGE_THRESH_BAT0=80

# ASUS
ASUS_CHARGE_LIMIT=80
```

## Checking Battery Health

```bash
# Detailed battery stats
tlp-stat -b

# Quick health check
upower -i /org/freedesktop/UPower/devices/battery_BAT0

# Cycle count (ThinkPad)
cat /sys/class/power_supply/BAT0/cycle_count
```

## Battery Care Tips

1. **Avoid extremes**: Keep between 20-80% when possible
2. **Temperature matters**: Don't charge when hot (>35°C ambient)
3. **Monthly full cycle**: Once a month, let it drain to 20% then charge to 100%
4. **Storage**: If storing long-term, keep at 50%

---
**Document Version:** 1.0

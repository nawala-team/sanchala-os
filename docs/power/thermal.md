# 🌡️ Thermal Management

Sanchala prioritizes **quiet operation** over raw performance, using passive cooling first.

## Philosophy

1. **Reduce CPU/GPU power first** (passive cooling)
2. **Increase fan speed only if needed**
3. **Never reach damaging temperatures**

## Temperature Thresholds

| Component | Passive | Critical | Shutdown |
|-----------|---------|----------|----------|
| CPU | 75°C | 95°C | 100°C |
| GPU | 80°C | 95°C | - |
| Battery | 45°C* | 50°C | - |

*Charging disabled above 45°C

## Thermal Modes

Configure in `/etc/sanchala/power/thermal.conf`:

```ini
[Thermal]
# passive = quieter, active = cooler, balanced = mix
Mode=passive
```

## Monitoring

```bash
# CPU temperature
cat /sys/class/thermal/thermal_zone*/temp

# sensors (lm_sensors package)
sensors

# Continuous monitoring
watch -n1 sensors
```

## Intel Thermald

For Intel CPUs, thermald provides additional thermal management:

```bash
sudo pacman -S thermald
sudo systemctl enable --now thermald
```

## Fan Control

By default, Sanchala lets firmware control fans (safest). Manual control requires `nbfc` or vendor-specific tools.

---
**Document Version:** 1.0

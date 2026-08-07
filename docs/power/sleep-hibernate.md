# 😴 Sleep & Hibernate Configuration

Sanchala uses **suspend-then-hibernate** by default, matching macOS behavior for optimal battery life during sleep.

## Sleep Modes Explained

| Mode | Power Use | Wake Time | Data Safety |
|------|-----------|-----------|-------------|
| **Suspend (S3)** | ~0.5-2W | Instant | Lost if power fails |
| **Hibernate (S4)** | 0W | 10-20s | Safe (on disk) |
| **Hybrid Sleep** | ~0.5-2W | Instant | Safe (RAM + disk) |
| **Suspend-then-Hibernate** | 0W after delay | Varies | Safe |

## Default Behavior

Sanchala's suspend-then-hibernate workflow:

1. **Close lid** → System suspends to RAM (instant wake possible)
2. **After 3 hours** → System automatically hibernates to disk
3. **Wake up** → Fast if within 3 hours, slower if hibernated

This gives you instant wake for quick checks while preventing battery drain overnight.

## Lid Close Actions

| Condition | Action |
|-----------|--------|
| On battery | Suspend-then-hibernate |
| On AC power | Suspend only |
| Docked (external display) | No action |

## Configuration

### Change Hibernate Delay

Edit `/etc/systemd/sleep.conf.d/sanchala-sleep.conf`:

```ini
[Sleep]
HibernateDelaySec=10800  # 3 hours (default)
# HibernateDelaySec=3600   # 1 hour
# HibernateDelaySec=21600  # 6 hours
```

### Change Lid Behavior

Edit `/etc/systemd/logind.conf.d/sanchala-power.conf`:

```ini
[Login]
HandleLidSwitch=suspend-then-hibernate
HandleLidSwitchExternalPower=suspend
HandleLidSwitchDocked=ignore
```

Apply changes: `sudo systemctl restart systemd-logind`

## Requirements for Hibernate

1. **Swap space** ≥ RAM size
2. **Resume parameter** in kernel cmdline
3. **Initramfs** with resume hook

```bash
# Check swap
swapon --show

# Verify resume parameter
cat /proc/cmdline | grep resume
```

## Troubleshooting

**Won't suspend:**
```bash
systemd-inhibit --list  # Check inhibitors
cat /sys/power/state    # Verify supported states
```

**Won't wake from hibernate:**
- Ensure swap is large enough
- Check `/var/log/journal` for errors
- Verify resume= kernel parameter

---
**Document Version:** 1.0

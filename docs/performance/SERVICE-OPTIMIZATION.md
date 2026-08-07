# SANCHALA OS - Service Startup Optimization

Version: 1.0 | Optimized service management for <3s boot

---

## Service Classification

### Tier 1: Critical Path (Must Start During Boot)

These services are required for basic system functionality:

| Service | Target Time | Activation | Purpose |
|---------|-------------|------------|---------|
| systemd-journald | <100ms | Early | System logging |
| systemd-udevd | <200ms | Early | Device management |
| dbus | <50ms | Socket | IPC bus |
| systemd-logind | <100ms | Early | Session management |
| NetworkManager | <500ms | Direct | Network connectivity |
| sddm | <300ms | After network | Display manager |

### Tier 2: Desktop Required (Start With Desktop)

| Service | Target Time | Activation | Purpose |
|---------|-------------|------------|---------|
| pipewire | <100ms | Socket/User | Audio server |
| polkit | <50ms | D-Bus | Authorization |
| kwalletd | <100ms | D-Bus | Credential storage |
| powerdevil | <100ms | User session | Power management |

### Tier 3: Deferred (Start After Desktop Ready)

| Service | Defer Time | Activation | Purpose |
|---------|------------|------------|---------|
| cups | On-demand | Socket | Printing |
| bluetooth | On-demand | Socket/udev | Bluetooth |
| avahi-daemon | 30s | Timer | mDNS/DNS-SD |
| ModemManager | On-demand | D-Bus | Mobile broadband |
| packagekit | 60s | Timer | Package updates |
| fwupd | 120s | Timer | Firmware updates |
| udisks2 | On-demand | D-Bus | Disk management |
| accounts-daemon | On-demand | D-Bus | User accounts |

### Tier 4: Disabled (Enable If Needed)

| Service | Reason | Enable Command |
|---------|--------|----------------|
| lvm2-monitor | Not using LVM | `systemctl enable lvm2-monitor` |
| dmraid-activation | Not using dmraid | `systemctl enable dmraid-activation` |
| mdmonitor | Not using MD RAID | `systemctl enable mdmonitor` |

---

## Activation Methods

### Socket Activation

Services start only when their socket receives a connection:

```ini
# /etc/systemd/system/cups.socket
[Socket]
ListenStream=/run/cups/cups.sock
ListenStream=631

[Install]
WantedBy=sockets.target
```

**Benefits:**
- Zero boot time impact
- Service starts on first use
- Automatic restart on crash

**Sanchala Services Using Socket Activation:**
- cups.socket → cups.service
- bluetooth.socket → bluetooth.service (if available)
- pipewire.socket → pipewire.service

### D-Bus Activation

Services start when their D-Bus name is requested:

```ini
# /usr/share/dbus-1/system-services/org.freedesktop.UDisks2.service
[D-BUS Service]
Name=org.freedesktop.UDisks2
Exec=/usr/lib/udisks2/udisksd
User=root
SystemdService=udisks2.service
```

**Sanchala Services Using D-Bus Activation:**
- udisks2, accounts-daemon, polkit, ModemManager

### Timer-Based Deferral

Non-critical services start after a delay:

```ini
# /etc/systemd/system/sanchala-deferred.timer
[Timer]
OnBootSec=30s
Unit=sanchala-deferred.target

[Install]
WantedBy=timers.target
```

---

## Implementation Files

### Deferred Services Target

**Location:** `/etc/systemd/system/sanchala-deferred.target`

```ini
[Unit]
Description=Sanchala Deferred Services
After=graphical.target
```

### Boot Optimization Service

**Location:** `/etc/systemd/system/sanchala-boot-optimize.service`

```ini
[Unit]
Description=Sanchala Boot Optimization
After=graphical.target

[Service]
Type=oneshot
ExecStart=/usr/lib/sanchala/boot-optimize
RemainAfterExit=yes

[Install]
WantedBy=graphical.target
```

---

## Service Audit Commands

### Find Slow Services
```bash
# Top 10 slowest boot services
systemd-analyze blame | head -10

# Services taking >200ms
systemd-analyze blame | awk '$1 > 200 {print}'
```

### Check Critical Chain
```bash
# Show what's blocking boot
systemd-analyze critical-chain graphical.target
```

### List All Enabled Services
```bash
# System services
systemctl list-unit-files --type=service --state=enabled

# User services
systemctl --user list-unit-files --type=service --state=enabled
```

### Find Unnecessary Services
```bash
# Services that failed or are inactive
systemctl --failed
systemctl list-units --type=service --state=inactive
```

---

## Optimization Checklist

### Pre-Boot Services
- [ ] systemd-journald starts in <100ms
- [ ] systemd-udevd starts in <200ms
- [ ] dbus uses socket activation

### Display Manager
- [ ] SDDM starts in <500ms
- [ ] Plymouth transitions cleanly
- [ ] No getty conflicts

### Deferred Services
- [ ] cups.socket enabled (not cups.service)
- [ ] bluetooth deferred or socket-activated
- [ ] avahi-daemon deferred 30s+
- [ ] packagekit deferred 60s+

### Disabled Services
- [ ] lvm2-monitor disabled (if not using LVM)
- [ ] dmraid-activation disabled
- [ ] mdmonitor disabled (if not using MD RAID)

---

## Troubleshooting

### Service Taking Too Long

```bash
# Check service dependencies
systemctl list-dependencies <service> --reverse

# Check what service is waiting for
systemd-analyze critical-chain <service>

# Check service logs
journalctl -u <service> -b --no-pager
```

### Service Failing to Start

```bash
# Check service status
systemctl status <service>

# Check for missing dependencies
systemctl list-dependencies <service>
```

### Boot Blocked by Service

```bash
# Find blocking service
systemd-analyze critical-chain

# Temporarily disable to test
sudo systemctl disable <service>
# Reboot and measure
systemd-analyze
```

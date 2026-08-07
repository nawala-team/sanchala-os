# SANCHALA OS - Memory Footprint Analysis

Version: 1.0 | Target: <800 MB idle desktop RAM

---

## Memory Budget

### Target Allocation (8GB System)

| Component | Target | Maximum | Notes |
|-----------|--------|---------|-------|
| Kernel + drivers | 100 MB | 150 MB | Includes modules |
| systemd + core services | 80 MB | 120 MB | journald, udevd, dbus |
| NetworkManager | 30 MB | 50 MB | With DNS resolver |
| KDE Plasma shell | 250 MB | 350 MB | Plasmashell + kwin |
| System tray apps | 50 MB | 100 MB | Audio, network, etc. |
| File indexer (Baloo) | 0 MB | 50 MB | Disabled by default |
| Security services | 40 MB | 60 MB | AppArmor, guardian |
| **Total Idle** | **~550 MB** | **~800 MB** | |

---

## Measurement Commands

### Quick Memory Check
```bash
# Human-readable memory summary
free -h

# Expected idle output:
#               total        used        free      shared  buff/cache   available
# Mem:           7.7G        750M        5.2G        180M        1.8G        6.5G
```

### Detailed Process Memory
```bash
# Top memory consumers
ps aux --sort=-%mem | head -15

# Using smem for accurate PSS measurement
smem -tk | tail -10
```

### Per-Service Memory
```bash
# Systemd service memory usage
systemd-cgtop -m -n 1

# Specific service memory
systemctl status <service> | grep Memory
```

---

## Memory Optimization Configurations

### 1. ZRAM (Compressed Swap)

**Location:** `/etc/systemd/zram-generator.conf`

| Setting | Value | Effect |
|---------|-------|--------|
| Size | 50% RAM | 4GB ZRAM on 8GB system |
| Algorithm | zstd | 3-4x compression ratio |
| Priority | 100 | Used before disk swap |

**Effective Memory Expansion:**
```
Physical: 8 GB
ZRAM: 4 GB (compresses to ~1.3 GB actual)
Effective: ~11-12 GB usable
```

### 2. Swappiness

**Location:** `/etc/sysctl.d/10-sanchala-performance.conf`

```
vm.swappiness = 10
```

- Low value keeps applications in RAM
- Only truly idle pages get swapped
- Maintains desktop responsiveness

### 3. Cache Pressure

```
vm.vfs_cache_pressure = 50
```

- Balanced between file cache and app memory
- Keeps frequently accessed files cached
- Doesn't starve applications

---

## Component Analysis

### Kernel Memory

```bash
# Check kernel memory usage
cat /proc/meminfo | grep -E "^(MemTotal|Slab|KernelStack|PageTables)"
```

**Typical Values:**
| Item | Size |
|------|------|
| Slab | 60-80 MB |
| KernelStack | 10-20 MB |
| PageTables | 20-40 MB |

### KDE Plasma Components

```bash
# Plasma process memory
ps aux | grep -E "plasma|kwin" | awk '{sum+=$6} END {print sum/1024 " MB"}'
```

| Process | Typical RAM |
|---------|-------------|
| plasmashell | 150-200 MB |
| kwin_wayland | 80-120 MB |
| kded5 | 30-50 MB |
| polkit-kde | 15-25 MB |

### Background Services

| Service | RAM | Can Disable? |
|---------|-----|--------------|
| systemd-journald | 20-40 MB | No |
| NetworkManager | 25-35 MB | No |
| pipewire | 15-25 MB | No (audio) |
| dbus-daemon | 5-10 MB | No |
| cupsd | 10-15 MB | Yes (socket) |
| bluetoothd | 5-10 MB | Yes |

---

## Memory Leak Detection

### 24-Hour Test Procedure

1. Boot to desktop, wait 60 seconds
2. Record baseline: `free -m > ~/mem-baseline.txt`
3. Leave system idle for 24 hours (display on)
4. Record final: `free -m > ~/mem-24h.txt`
5. Compare: used memory should increase <400 MB

### Monitoring Script

```bash
#!/bin/bash
# Log memory every hour
while true; do
    echo "$(date): $(free -m | awk '/^Mem:/ {print $3}') MB used" >> ~/mem-log.txt
    sleep 3600
done
```

### Known Memory Consumers

| Application | Behavior | Mitigation |
|-------------|----------|------------|
| Firefox | Grows with tabs | Tab unloader extension |
| Electron apps | High baseline | Limit concurrent apps |
| Baloo indexer | Spikes during index | Disabled by default |

---

## Optimization Checklist

- [ ] ZRAM enabled and configured
- [ ] Swappiness set to 10
- [ ] Baloo file indexer disabled
- [ ] No memory leaks after 24h
- [ ] Idle RAM <800 MB
- [ ] Available RAM >80% of total

---

## Verification Sign-Off

| Metric | Target | Measured | Status |
|--------|--------|----------|--------|
| Idle RAM (CLI) | <200 MB | | ☐ |
| Idle RAM (Desktop) | <800 MB | | ☐ |
| 24h RAM growth | <400 MB | | ☐ |
| ZRAM compression | >2.5x | | ☐ |

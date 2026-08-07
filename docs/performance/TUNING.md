# Sanchala OS Performance Tuning Guide

Version: 1.0 | Target: <3 second boot, responsive desktop

## Performance Philosophy

Sanchala OS is tuned for **desktop responsiveness** over raw throughput. This means:

- Applications feel snappy and responsive
- System remains usable under load
- Boot completes quickly
- Memory pressure is handled gracefully

## Boot Time Optimization

### Target Metrics

| Metric | Target | Measured |
|--------|--------|----------|
| Kernel init → systemd | <0.5s | TBD |
| systemd → display manager | <2.0s | TBD |
| Display manager → desktop | <1.0s | TBD |
| **Total boot time** | **<3.0s** | TBD |

### Boot Optimization Techniques

1. **Fast Initramfs**
   - LZ4 compression (fastest decompression)
   - Minimal modules (autodetect hook)
   - systemd-based init (parallel initialization)
   - Early KMS for instant display

2. **Kernel Parameters**
   ```
   quiet loglevel=3 splash
   ```
   - Reduces console output overhead
   - Plymouth provides visual feedback without blocking

3. **Service Parallelization**
   - systemd's default parallelization
   - Socket activation for on-demand services
   - Deferred non-critical services

4. **Readahead Prefetching**
   - Boot file collection and replay
   - Page cache warming for common files

### Measuring Boot Time

```bash
# Full boot analysis
systemd-analyze

# Blame (slowest services)
systemd-analyze blame | head -20

# Critical path
systemd-analyze critical-chain

# Plot SVG timeline
systemd-analyze plot > boot-timeline.svg
```

## Memory Management

### ZRAM Configuration

ZRAM provides compressed RAM-based swap, faster than any SSD:

| Setting | Value | Rationale |
|---------|-------|-----------|
| Size | 50% RAM | Effective ~100-150% with compression |
| Algorithm | zstd | Best ratio, acceptable speed |
| Priority | 100 | Use before disk swap |

### Swappiness

```
vm.swappiness = 10
```

Low swappiness keeps applications in RAM while still allowing swap for truly idle pages.

### VFS Cache Pressure

```
vm.vfs_cache_pressure = 50
```

Balanced between keeping filesystem metadata cached and freeing memory for applications.

### Dirty Page Thresholds

```
vm.dirty_ratio = 10
vm.dirty_background_ratio = 5
```

Lower thresholds mean more frequent, smaller writes—better for responsiveness, prevents I/O storms.

## I/O Scheduling

### Scheduler Selection

| Device Type | Scheduler | Rationale |
|-------------|-----------|-----------|
| NVMe SSD | none | Hardware queuing sufficient |
| SATA SSD | mq-deadline | Low latency, simple |
| HDD | bfq | Fair queuing, prevents starvation |
| Virtual | none | Hypervisor handles scheduling |

### Read-ahead Settings

| Device | Read-ahead | Rationale |
|--------|------------|-----------|
| NVMe | 128 KB | Fast random access |
| SSD | 256 KB | Moderate benefit |
| HDD | 1024 KB | Sequential read benefit |

## CPU Governors

### Default: schedutil

The `schedutil` governor is kernel scheduler-integrated:

- Frequency decisions based on actual CPU demand
- Faster response than load-based governors
- Energy efficient (doesn't overshoot)

### Power Profiles

| Profile | Governor | Turbo | Use Case |
|---------|----------|-------|----------|
| Performance | performance | On | Demanding tasks, AC power |
| Balanced | schedutil | On | Default, mixed workloads |
| Power Saver | schedutil | Off | Battery life priority |

Switch profiles:
```bash
powerprofilesctl set balanced
```

## Desktop Responsiveness

### Kernel Scheduler

```
kernel.sched_autogroup_enabled = 1
```

Automatic process grouping prevents one busy process from starving the desktop.

### inotify Limits

```
fs.inotify.max_user_watches = 524288
```

High limits for IDEs, file managers, and development tools.

## Benchmarking

### Boot Time

```bash
# Requires multiple reboots for accuracy
sanchala-benchmark boot
```

### Memory

```bash
# Memory usage at idle
sanchala-benchmark memory

# Memory pressure handling
sanchala-benchmark memory-pressure
```

### I/O

```bash
# Disk throughput
sanchala-benchmark io

# Latency under load
sanchala-benchmark io-latency
```

### Desktop Responsiveness

```bash
# Frame latency during load
sanchala-benchmark desktop
```

## Troubleshooting

### Slow Boot

1. Check `systemd-analyze blame` for slow services
2. Disable unnecessary services
3. Verify initramfs is optimized
4. Check for disk errors: `journalctl -b | grep -i error`

### Memory Pressure

1. Check zram status: `zramctl`
2. Review `free -h` output
3. Check for memory leaks: `smem -tk`
4. Adjust swappiness if needed

### I/O Bottlenecks

1. Check scheduler: `cat /sys/block/*/queue/scheduler`
2. Monitor I/O: `iotop`
3. Check disk health: `smartctl -a /dev/sdX`

### CPU Throttling

1. Check current frequency: `cpupower frequency-info`
2. Check thermal throttling: `journalctl | grep -i thermal`
3. Verify governor: `cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor`

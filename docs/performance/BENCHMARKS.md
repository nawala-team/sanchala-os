# Sanchala OS Performance Benchmarks Specification

Version: 1.0 | Standardized performance measurement methodology

## Overview

This document defines the standard benchmarks for measuring Sanchala OS performance. All benchmark results should be reproducible and comparable across different hardware.

## Test Environment Requirements

### Hardware Baseline

Benchmarks should be run on reference hardware configurations:

**Minimum Spec (Low-end laptop):**
- CPU: 4 cores, 2.0 GHz
- RAM: 4 GB
- Storage: SATA SSD
- GPU: Integrated

**Recommended Spec (Modern desktop):**
- CPU: 8 cores, 3.0 GHz+
- RAM: 16 GB
- Storage: NVMe SSD
- GPU: Dedicated or integrated

### Test Conditions

1. Fresh installation (no user data)
2. All updates applied
3. Reboot before testing
4. No background user applications
5. Network connected but idle
6. Display at native resolution

## Benchmark Categories

### 1. Boot Time (BOOT)

**Measurement Method:**
```bash
systemd-analyze
```

**Metrics:**

| ID | Metric | Target | Critical |
|----|--------|--------|----------|
| BOOT-001 | Kernel load time | <0.5s | <1.0s |
| BOOT-002 | Initramfs time | <0.5s | <1.0s |
| BOOT-003 | Userspace time | <2.0s | <3.0s |
| BOOT-004 | Total boot time | <3.0s | <5.0s |
| BOOT-005 | Time to login screen | <3.0s | <5.0s |
| BOOT-006 | Time to usable desktop | <5.0s | <8.0s |

**Test Procedure:**
1. Cold boot (power off for 30 seconds)
2. Record BIOS POST time separately
3. Run `systemd-analyze` immediately after login
4. Record 5 consecutive boots, use median

### 2. Memory Usage (MEM)

**Measurement Method:**
```bash
free -m
smem -t
```

**Metrics:**

| ID | Metric | Target | Critical |
|----|--------|--------|----------|
| MEM-001 | Idle memory (CLI) | <200 MB | <400 MB |
| MEM-002 | Idle memory (Desktop) | <800 MB | <1200 MB |
| MEM-003 | Memory after 24h uptime | <1.2 GB | <2.0 GB |
| MEM-004 | ZRAM compression ratio | >2.5x | >2.0x |

**Test Procedure:**
1. Boot to desktop
2. Wait 60 seconds for services to settle
3. Record memory usage
4. For 24h test, leave system idle with screen on

### 3. I/O Performance (IO)

**Measurement Method:**
```bash
fio --name=test --rw=randread --bs=4k --runtime=30 --ioengine=libaio --direct=1 --numjobs=4 --iodepth=32
```

**Metrics:**

| ID | Metric | Target (NVMe) | Target (SATA) |
|----|--------|---------------|---------------|
| IO-001 | Sequential read | >2000 MB/s | >500 MB/s |
| IO-002 | Sequential write | >1500 MB/s | >400 MB/s |
| IO-003 | Random read 4K | >50k IOPS | >30k IOPS |
| IO-004 | Random write 4K | >40k IOPS | >25k IOPS |
| IO-005 | Latency (avg) | <0.1ms | <0.5ms |

**Test Procedure:**
1. Use dedicated test partition (not root)
2. Run fio with standardized parameters
3. Record 3 runs, use median

### 4. Desktop Responsiveness (RESP)

**Measurement Method:**
- Manual testing with timer
- Frame time measurement tools

**Metrics:**

| ID | Metric | Target | Critical |
|----|--------|--------|----------|
| RESP-001 | Application launch (Dolphin) | <0.5s | <1.0s |
| RESP-002 | Application launch (Firefox) | <2.0s | <4.0s |
| RESP-003 | Window resize latency | <16ms | <33ms |
| RESP-004 | Desktop usable under CPU load | Yes | Yes |
| RESP-005 | Input latency | <20ms | <50ms |

**Test Procedure:**
1. Use stopwatch for launch times
2. For latency, use compositor frame timing
3. CPU load test: run `stress -c $(nproc)` and verify desktop remains responsive

### 5. Shutdown Time (SHUT)

**Metrics:**

| ID | Metric | Target | Critical |
|----|--------|--------|----------|
| SHUT-001 | Logout time | <2s | <5s |
| SHUT-002 | Shutdown time | <5s | <10s |
| SHUT-003 | Reboot time | <8s | <15s |

**Test Procedure:**
1. From idle desktop
2. Measure from command/click to power off/login screen
3. Record 3 runs, use median

## Benchmark Script

Location: `/usr/lib/sanchala/benchmark`

```bash
#!/bin/bash
# Usage: sanchala-benchmark [category]
# Categories: boot, memory, io, desktop, shutdown, all

case "$1" in
    boot)
        systemd-analyze
        systemd-analyze blame | head -10
        ;;
    memory)
        free -h
        echo "---"
        smem -tk 2>/dev/null || echo "smem not installed"
        ;;
    io)
        echo "Running fio benchmark..."
        fio --name=sanchala-bench --rw=randrw --bs=4k --runtime=30 \
            --ioengine=libaio --direct=1 --numjobs=4 --iodepth=32 \
            --filename=/tmp/fio-test --size=1G
        rm -f /tmp/fio-test
        ;;
    desktop)
        echo "Manual test required - see docs/performance/BENCHMARKS.md"
        ;;
    shutdown)
        echo "Manual test required - measure from click to power off"
        ;;
    all)
        for cat in boot memory io; do
            echo "=== $cat ==="
            $0 $cat
            echo
        done
        ;;
    *)
        echo "Usage: sanchala-benchmark [boot|memory|io|desktop|shutdown|all]"
        ;;
esac
```

## Reporting Format

Benchmark results should be reported in this format:

```yaml
benchmark_report:
  date: 2024-XX-XX
  version: 1.0.0
  hardware:
    cpu: "AMD Ryzen 7 5800X"
    ram: "16 GB DDR4-3200"
    storage: "Samsung 980 Pro 1TB NVMe"
    gpu: "AMD Radeon RX 6700 XT"
  
  results:
    boot:
      kernel: 0.42s
      initramfs: 0.38s
      userspace: 1.85s
      total: 2.65s
      verdict: PASS
    
    memory:
      idle_cli: 185 MB
      idle_desktop: 720 MB
      verdict: PASS
    
    io:
      seq_read: 3200 MB/s
      seq_write: 2800 MB/s
      rand_read_iops: 85000
      rand_write_iops: 72000
      verdict: PASS
    
    responsiveness:
      dolphin_launch: 0.3s
      firefox_launch: 1.5s
      verdict: PASS

  overall: PASS
```

## Regression Testing

Performance benchmarks should be run:

1. Before each release
2. After kernel updates
3. After systemd updates
4. After major configuration changes

Any regression >10% from baseline requires investigation before release.

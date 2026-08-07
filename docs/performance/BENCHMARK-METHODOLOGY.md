# SANCHALA OS - Benchmark Methodology

Version: 1.0 | Standardized performance measurement for release validation

---

## Overview

This document defines the official benchmark methodology for validating SANCHALA OS performance claims. All benchmarks must follow these procedures for reproducible, comparable results.

---

## Test Environment

### Hardware Reference Configurations

**Minimum Spec (Validation Required):**
- CPU: 4-core, 2.0 GHz (Intel i3/AMD Ryzen 3)
- RAM: 4 GB DDR4
- Storage: SATA SSD 120GB+
- GPU: Integrated (Intel UHD/AMD Vega)

**Recommended Spec (Primary Testing):**
- CPU: 8-core, 3.0 GHz+ (Intel i5/AMD Ryzen 5)
- RAM: 16 GB DDR4-3200
- Storage: NVMe SSD 256GB+
- GPU: Integrated or dedicated

### Pre-Test Conditions

1. Fresh installation (no user data/apps)
2. All system updates applied
3. Reboot before each test series
4. Wait 60 seconds after desktop loads
5. No user applications running
6. Network connected but idle
7. Display at native resolution
8. Room temperature 20-25°C

---

## Benchmark Categories

### BOOT: Boot Time

**Tool:** `systemd-analyze`

| ID | Metric | Target | Critical | Method |
|----|--------|--------|----------|--------|
| BOOT-01 | Kernel + initrd | <0.5s | <1.0s | systemd-analyze |
| BOOT-02 | Userspace | <2.0s | <3.0s | systemd-analyze |
| BOOT-03 | Total boot | <3.0s | <5.0s | systemd-analyze |
| BOOT-04 | To login screen | <3.0s | <5.0s | Stopwatch |
| BOOT-05 | To usable desktop | <5.0s | <8.0s | Stopwatch |

**Procedure:**
1. Cold boot (power off 30 seconds)
2. Start stopwatch at power button
3. Stop at login screen / desktop ready
4. Run `systemd-analyze` immediately after login
5. Record 5 consecutive boots, report median

### MEM: Memory Usage

**Tools:** `free`, `smem`, `ps`

| ID | Metric | Target | Critical | Method |
|----|--------|--------|----------|--------|
| MEM-01 | Idle (CLI, no X) | <200 MB | <400 MB | free -m |
| MEM-02 | Idle (Desktop) | <800 MB | <1200 MB | free -m |
| MEM-03 | After 24h idle | <1200 MB | <2000 MB | free -m |
| MEM-04 | ZRAM ratio | >2.5x | >2.0x | zramctl |

**Procedure:**
1. Boot to target (CLI or desktop)
2. Wait 60 seconds for services to settle
3. Run measurement command 3 times
4. Report median of "used" column

### IO: Storage Performance

**Tool:** `fio`

| ID | Metric | NVMe Target | SATA Target | Method |
|----|--------|-------------|-------------|--------|
| IO-01 | Seq Read | >2000 MB/s | >500 MB/s | fio |
| IO-02 | Seq Write | >1500 MB/s | >400 MB/s | fio |
| IO-03 | Rand Read 4K | >50k IOPS | >30k IOPS | fio |
| IO-04 | Rand Write 4K | >40k IOPS | >25k IOPS | fio |

**Procedure:**
```bash
# Sequential read/write
fio --name=seq --rw=readwrite --bs=1M --size=1G \
    --numjobs=1 --runtime=30 --time_based --direct=1

# Random 4K
fio --name=rand --rw=randrw --bs=4k --size=1G \
    --numjobs=4 --iodepth=32 --runtime=30 --direct=1
```

### RESP: Desktop Responsiveness

**Tools:** Manual timing, frame analysis

| ID | Metric | Target | Critical | Method |
|----|--------|--------|----------|--------|
| RESP-01 | Dolphin launch | <0.5s | <1.0s | Stopwatch |
| RESP-02 | Firefox launch | <2.0s | <4.0s | Stopwatch |
| RESP-03 | Settings launch | <0.5s | <1.0s | Stopwatch |
| RESP-04 | Frame time | <16ms | <33ms | Compositor stats |
| RESP-05 | Under CPU load | Usable | Usable | Subjective |

**Procedure:**
1. Close all applications
2. Click application icon, start timer
3. Stop when window is fully rendered
4. Repeat 3 times, report median

### SHUT: Shutdown Time

| ID | Metric | Target | Critical | Method |
|----|--------|--------|----------|--------|
| SHUT-01 | Logout | <2s | <5s | Stopwatch |
| SHUT-02 | Shutdown | <5s | <10s | Stopwatch |
| SHUT-03 | Reboot | <8s | <15s | Stopwatch |

---

## Benchmark Script Usage

```bash
# Run specific benchmark
sanchala-benchmark boot
sanchala-benchmark memory
sanchala-benchmark io

# Run all benchmarks
sanchala-benchmark all

# Generate report
sanchala-benchmark report > benchmark-results.txt
```

---

## Results Format

### YAML Report Template

```yaml
benchmark_report:
  metadata:
    date: "2024-XX-XX"
    version: "1.0.0-gati"
    tester: "Name"
    
  hardware:
    cpu: "AMD Ryzen 5 5600X"
    ram: "16 GB DDR4-3200"
    storage: "Samsung 980 Pro 500GB NVMe"
    gpu: "AMD Radeon RX 6600"
    
  results:
    boot:
      kernel_initrd: "0.42s"
      userspace: "1.85s"
      total: "2.27s"
      verdict: "PASS"
      
    memory:
      idle_desktop: "720 MB"
      zram_ratio: "3.2x"
      verdict: "PASS"
      
    io:
      seq_read: "3200 MB/s"
      seq_write: "2800 MB/s"
      verdict: "PASS"
      
    responsiveness:
      dolphin: "0.3s"
      firefox: "1.5s"
      verdict: "PASS"
      
  overall_verdict: "PASS"
  notes: "All targets met on reference hardware"
```

---

## Release Criteria

### Must Pass (Release Blocker)
- BOOT-03: Total boot <5.0s (critical threshold)
- MEM-02: Idle desktop <1200 MB
- All services start without failure

### Should Pass (Quality Gate)
- BOOT-03: Total boot <3.0s (target)
- MEM-02: Idle desktop <800 MB
- RESP-01 through RESP-03 meet targets

### Regression Rules
- Any metric >10% worse than previous release requires investigation
- Any metric >20% worse blocks release
- Document all regressions with root cause

---

## Comparison Benchmarks

Run same tests on competitor distros for comparison:

| Distro | Install | Configure | Test |
|--------|---------|-----------|------|
| EndeavourOS | Default KDE | None | Same procedure |
| Manjaro KDE | Default | None | Same procedure |
| Fedora KDE | Default | None | Same procedure |
| Arch + KDE | Manual | Minimal | Same procedure |

Document hardware, date, and version for all comparisons.

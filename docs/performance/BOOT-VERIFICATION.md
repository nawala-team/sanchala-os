# SANCHALA OS - Boot Time Verification Checklist

Version: 1.0 | Target: <3 seconds boot time

---

## Pre-Flight Checklist

Before measuring boot time, verify these conditions:

- [ ] Fresh installation or clean state
- [ ] All system updates applied
- [ ] No user applications set to autostart
- [ ] BIOS/UEFI fast boot enabled
- [ ] Secure Boot configured (if applicable)
- [ ] NVMe/SSD storage (HDD will be slower)

---

## Boot Time Breakdown Target

| Phase | Target | Maximum | Measurement |
|-------|--------|---------|-------------|
| UEFI/BIOS | <1.0s | 2.0s | Stopwatch |
| Bootloader (GRUB) | 0s | 0s | Timeout=0 |
| Kernel + initramfs | <0.5s | 1.0s | systemd-analyze |
| Userspace services | <2.0s | 3.0s | systemd-analyze |
| Display manager ready | <0.5s | 1.0s | systemd-analyze |
| **Total (post-BIOS)** | **<3.0s** | **5.0s** | systemd-analyze |

---

## Verification Commands

### 1. Basic Boot Analysis
```bash
# Total boot time breakdown
systemd-analyze

# Expected output:
# Startup finished in X.XXXs (firmware) + X.XXXs (loader) + 
# X.XXXs (kernel) + X.XXXs (initrd) + X.XXXs (userspace) = X.XXXs
```

### 2. Slowest Services
```bash
# Top 15 slowest services
systemd-analyze blame | head -15

# Target: No service >500ms except NetworkManager
```

### 3. Critical Chain
```bash
# Show critical boot path
systemd-analyze critical-chain

# Target: graphical.target reached in <3s
```

### 4. Boot Plot (Visual)
```bash
# Generate SVG timeline
systemd-analyze plot > /tmp/boot-timeline.svg

# Open in browser to visualize parallel startup
```

---

## Checklist Items

### Kernel & Initramfs

- [ ] **Kernel parameters optimized**
  ```
  quiet loglevel=3 rd.systemd.show_status=auto splash
  ```

- [ ] **Initramfs uses systemd hook**
  ```bash
  grep -q "systemd" /etc/mkinitcpio.conf && echo "OK"
  ```

- [ ] **Initramfs compression is zstd**
  ```bash
  grep "COMPRESSION=" /etc/mkinitcpio.conf
  # Should show: COMPRESSION="zstd"
  ```

- [ ] **Initramfs size <30MB**
  ```bash
  ls -lh /boot/initramfs-linux*.img
  ```

- [ ] **Early KMS enabled**
  ```bash
  grep -q "kms" /etc/mkinitcpio.conf && echo "OK"
  ```

### Bootloader

- [ ] **GRUB timeout is 0**
  ```bash
  grep "GRUB_TIMEOUT=" /etc/default/grub
  # Should show: GRUB_TIMEOUT=0
  ```

- [ ] **GRUB hidden timeout enabled**
  ```bash
  grep "GRUB_TIMEOUT_STYLE=" /etc/default/grub
  # Should show: GRUB_TIMEOUT_STYLE=hidden
  ```

### Systemd Configuration

- [ ] **Default timeouts reduced**
  ```bash
  cat /etc/systemd/system.conf.d/10-sanchala.conf | grep Timeout
  # DefaultTimeoutStopSec=15s
  # DefaultTimeoutStartSec=30s
  ```

- [ ] **No failed services**
  ```bash
  systemctl --failed
  # Should show: 0 loaded units listed
  ```

### Service Optimization

- [ ] **Non-critical services deferred**
  ```bash
  # These should NOT be in critical chain:
  # cups, bluetooth, avahi-daemon, ModemManager, packagekit
  systemd-analyze critical-chain | grep -E "cups|bluetooth|avahi"
  # Should return nothing
  ```

- [ ] **Socket activation configured**
  ```bash
  systemctl list-units --type=socket | grep -c "\.socket"
  # Should show multiple socket units
  ```

- [ ] **No unnecessary services enabled**
  ```bash
  # Check for common unnecessary services
  systemctl is-enabled lvm2-monitor dmraid-activation mdmonitor 2>/dev/null
  # Should show "disabled" or "not-found"
  ```

### Display Manager

- [ ] **SDDM configured for fast start**
  ```bash
  systemd-analyze blame | grep sddm
  # Target: <500ms
  ```

---

## Performance Targets by Hardware

### NVMe SSD (Recommended)
| Metric | Target |
|--------|--------|
| Kernel + initrd | <0.4s |
| Userspace | <1.8s |
| **Total** | **<2.5s** |

### SATA SSD
| Metric | Target |
|--------|--------|
| Kernel + initrd | <0.6s |
| Userspace | <2.2s |
| **Total** | **<3.0s** |

### HDD (Not Recommended)
| Metric | Target |
|--------|--------|
| Kernel + initrd | <1.5s |
| Userspace | <5.0s |
| **Total** | **<8.0s** |

---

## Troubleshooting Slow Boot

### If kernel+initrd > 1.0s:
1. Rebuild initramfs: `mkinitcpio -P`
2. Verify autodetect hook is present
3. Check for unnecessary modules in MODULES=()

### If userspace > 3.0s:
1. Run `systemd-analyze blame` to find slow services
2. Disable/defer non-critical services
3. Check `systemd-analyze critical-chain` for blockers

### If specific service is slow:
```bash
# Analyze single service
systemd-analyze blame | grep <service>

# Check service dependencies
systemctl list-dependencies <service>

# Check service logs
journalctl -u <service> -b
```

---

## Sign-Off

| Check | Status | Verified By | Date |
|-------|--------|-------------|------|
| Boot time <3.0s | ☐ | | |
| No failed services | ☐ | | |
| Critical chain clean | ☐ | | |
| All checklist items pass | ☐ | | |

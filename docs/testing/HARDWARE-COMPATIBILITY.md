# 🖥️ SANCHALA OS - Hardware Compatibility Matrix

## Overview

This document tracks hardware compatibility status for Sanchala OS. Our goal is broad hardware support while maintaining security and stability.

## Compatibility Levels

| Level | Symbol | Meaning |
|-------|--------|---------|
| Certified | ✅ | Fully tested and supported |
| Compatible | 🟢 | Works well, community tested |
| Partial | 🟡 | Works with limitations |
| Unsupported | 🔴 | Known issues, not recommended |
| Unknown | ⚪ | Not yet tested |

---

## CPU Compatibility

### Intel

| Generation | Status | Notes |
|------------|--------|-------|
| 14th Gen (Meteor Lake) | ⚪ | Testing needed |
| 13th Gen (Raptor Lake) | ⚪ | Testing needed |
| 12th Gen (Alder Lake) | ⚪ | Testing needed |
| 11th Gen (Tiger Lake) | ⚪ | Expected compatible |
| 10th Gen (Comet Lake) | ⚪ | Expected compatible |
| 8th-9th Gen | ⚪ | Expected compatible |
| 6th-7th Gen | ⚪ | Expected compatible |

### AMD

| Generation | Status | Notes |
|------------|--------|-------|
| Ryzen 7000 (Zen 4) | ⚪ | Testing needed |
| Ryzen 5000 (Zen 3) | ⚪ | Testing needed |
| Ryzen 3000 (Zen 2) | ⚪ | Expected compatible |
| Ryzen 1000/2000 (Zen/Zen+) | ⚪ | Expected compatible |

---

## GPU Compatibility

### NVIDIA

| Series | Status | Driver | Notes |
|--------|--------|--------|-------|
| RTX 40 Series | ⚪ | nvidia-dkms | Testing needed |
| RTX 30 Series | ⚪ | nvidia-dkms | Expected compatible |
| RTX 20 Series | ⚪ | nvidia-dkms | Expected compatible |
| GTX 16 Series | ⚪ | nvidia-dkms | Expected compatible |
| GTX 10 Series | ⚪ | nvidia-dkms | Expected compatible |
| GTX 900 Series | ⚪ | nvidia-dkms | May need legacy driver |

### AMD

| Series | Status | Driver | Notes |
|--------|--------|--------|-------|
| RX 7000 (RDNA 3) | ⚪ | amdgpu | Kernel 6.2+ recommended |
| RX 6000 (RDNA 2) | ⚪ | amdgpu | Expected compatible |
| RX 5000 (RDNA) | ⚪ | amdgpu | Expected compatible |
| RX Vega | ⚪ | amdgpu | Expected compatible |
| RX 500 Series | ⚪ | amdgpu | Expected compatible |

### Intel

| Series | Status | Driver | Notes |
|--------|--------|--------|-------|
| Arc A-Series | ⚪ | i915 | Kernel 6.2+ recommended |
| Iris Xe | ⚪ | i915 | Expected compatible |
| UHD Graphics | ⚪ | i915 | Expected compatible |

---

## Laptop Compatibility

### Premium Laptops

| Vendor | Model | Status | Notes |
|--------|-------|--------|-------|
| Framework | 13/16 | ⚪ | Expected excellent |
| ThinkPad | X1 Carbon | ⚪ | Testing needed |
| ThinkPad | T14 | ⚪ | Testing needed |
| Dell | XPS 13/15 | ⚪ | Testing needed |
| HP | EliteBook | ⚪ | Testing needed |
| ASUS | ZenBook | ⚪ | Testing needed |

### Gaming Laptops

| Vendor | Model | Status | Notes |
|--------|-------|--------|-------|
| ASUS | ROG Series | ⚪ | Hybrid GPU setup |
| Razer | Blade | ⚪ | Testing needed |
| MSI | Gaming | ⚪ | Testing needed |

---

## Wireless Hardware

### WiFi

| Chipset | Status | Driver | Notes |
|---------|--------|--------|-------|
| Intel AX2xx | ⚪ | iwlwifi | Expected compatible |
| Intel AX1xx | ⚪ | iwlwifi | Expected compatible |
| Intel AC 9xxx | ⚪ | iwlwifi | Expected compatible |
| Qualcomm Atheros | ⚪ | ath11k/ath10k | Check specific model |
| Realtek | 🟡 | rtw88/rtw89 | Often needs firmware |
| Broadcom | 🟡 | brcmfmac | May need AUR driver |
| MediaTek MT7921 | ⚪ | mt7921e | Kernel 5.12+ |

### Bluetooth

| Chipset | Status | Notes |
|---------|--------|-------|
| Intel Bluetooth | ⚪ | Usually bundled with WiFi |
| Qualcomm | ⚪ | Check specific model |
| Realtek | 🟡 | May need firmware |

---

## Storage

| Type | Status | Notes |
|------|--------|-------|
| NVMe SSD | ⚪ | Full support expected |
| SATA SSD | ⚪ | Full support expected |
| HDD | ⚪ | Full support expected |
| eMMC | ⚪ | Should work |
| SD Cards | ⚪ | Depends on reader |

---

## Security Hardware

| Feature | Status | Notes |
|---------|--------|-------|
| TPM 2.0 | ⚪ | Required for full security |
| TPM 1.2 | 🟡 | Limited support |
| Secure Boot | ⚪ | Supported with signed kernel |
| FIDO2 Keys | ⚪ | USB keys supported |
| Fingerprint | 🟡 | Varies by sensor |

---

## Testing Procedures

### Minimum Test Checklist

- [ ] ISO boots from USB
- [ ] Installation completes successfully
- [ ] System boots after installation
- [ ] Desktop environment loads
- [ ] WiFi connects
- [ ] Bluetooth pairs
- [ ] Audio works (speakers + headphones)
- [ ] Display at native resolution
- [ ] Suspend/Resume works
- [ ] Webcam functions
- [ ] Keyboard backlight (if present)
- [ ] Function keys work
- [ ] Touchpad gestures

### Extended Test Checklist

- [ ] External displays
- [ ] Thunderbolt/USB-C docking
- [ ] Hibernate
- [ ] GPU switching (hybrid laptops)
- [ ] TPM enrollment
- [ ] Secure Boot chain
- [ ] Battery life (reasonable)
- [ ] Thermal management
- [ ] All USB ports

---

## Reporting Hardware Compatibility

### To Report a Tested System

1. Run: `inxi -Fxxxz` (or `sanchala-hw-report` when available)
2. Complete the test checklist above
3. Submit via GitHub Issue with "Hardware Report" template

### Required Information

```
System: [Vendor Model]
CPU: [Model]
GPU: [Model]
WiFi: [Chipset]
Storage: [Type/Size]
RAM: [Size]
Sanchala Version: [X.Y.Z]
Kernel: [Version]
Test Date: [YYYY-MM-DD]
Tester: [GitHub username]
```

---

## Known Issues

| Hardware | Issue | Workaround | Status |
|----------|-------|------------|--------|
| _None documented yet_ | | | |

---

## Contributing

Help us expand hardware compatibility:

1. Test Sanchala OS on your hardware
2. Report results (even if everything works!)
3. Document workarounds for issues
4. Submit PRs to update this matrix

**Contact:** hardware@sanchala.id

---

_Last Updated: Phase 1_
_Maintainer: qa-lead_

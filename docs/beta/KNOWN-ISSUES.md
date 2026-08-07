# ⚠️ Known Issues

> Sanchala OS Beta — Current Known Issues and Workarounds

**Last Updated:** August 2025  
**Beta Version:** 1.0-beta.2

---

## Critical Issues

> Issues that may cause data loss or prevent system use

| ID | Issue | Status | Workaround |
|----|-------|--------|------------|
| — | No critical issues at this time | — | — |

---

## High Priority Issues

> Major features broken or significantly impaired

| ID | Issue | Affected | Status | Workaround |
|----|-------|----------|--------|------------|
| #142 | NVIDIA 40-series suspend/resume crash | RTX 4070+ | 🔧 In Progress | Disable suspend or use hybrid sleep |
| #138 | Installer fails on NVMe with 4K sectors | Some NVMe | 🔧 In Progress | Use manual partitioning |
| #131 | Bluetooth audio stutters after 30min | All | 📋 Triaged | Restart PipeWire: `systemctl --user restart pipewire` |

---

## Medium Priority Issues

> Features impaired but workarounds available

| ID | Issue | Affected | Status | Workaround |
|----|-------|----------|--------|------------|
| #156 | Global menu doesn't show for Electron apps | Electron apps | 📋 Triaged | Use in-window menu (Alt key) |
| #149 | Dock magnification janky on 4K displays | 4K/HiDPI | 🔧 In Progress | Reduce magnification factor in settings |
| #145 | Sanchala Store slow to load categories | All | 📋 Triaged | Wait ~5s on first load; subsequent loads normal |
| #139 | Fingerprint setup fails on some readers | Validity sensors | ❓ Investigating | Use password authentication |
| #134 | Theme doesn't apply to Flatpak GTK4 apps | Flatpak GTK4 | 📋 Triaged | Manual: copy theme to ~/.var/app/*/config/gtk-4.0/ |

---

## Low Priority Issues

> Minor issues, cosmetic problems

| ID | Issue | Affected | Status |
|----|-------|----------|--------|
| #162 | Wallpaper picker shows duplicates | All | 📋 Triaged |
| #158 | Clock widget seconds flicker | Some themes | 📋 Triaged |
| #152 | "About" dialog shows placeholder text | All | 📋 Triaged |
| #147 | Shutdown sound plays twice occasionally | All | ❓ Investigating |

---

## Hardware-Specific Issues

### NVIDIA Graphics
| Issue | Cards Affected | Status | Workaround |
|-------|----------------|--------|------------|
| Suspend crash | RTX 40-series | 🔧 In Progress | Hybrid sleep |
| Screen tearing | GTX 10/16-series | 📋 Triaged | Enable Force Composition in NVIDIA Settings |

### Intel Graphics
| Issue | Hardware | Status | Workaround |
|-------|----------|--------|------------|
| HDR not working | Intel Arc | ❓ Investigating | Disable HDR |

### AMD Graphics
| Issue | Hardware | Status | Workaround |
|-------|----------|--------|------------|
| No known issues | — | ✅ | — |

### WiFi/Network
| Issue | Hardware | Status | Workaround |
|-------|----------|--------|------------|
| Slow reconnect after suspend | Intel AX200/210 | 🔧 In Progress | Toggle WiFi off/on |
| 5GHz not detected | Realtek RTL8821CE | ❓ Investigating | Use 2.4GHz |

### Laptops
| Issue | Models | Status | Workaround |
|-------|--------|--------|------------|
| Fn brightness keys delayed | ThinkPad X1 Carbon Gen 11 | 📋 Triaged | Use notification slider |
| Touchpad gestures inconsistent | HP Spectre x360 | ❓ Investigating | — |

---

## Status Legend

| Status | Meaning |
|--------|---------|
| ✅ Fixed | Resolved in next build |
| 🔧 In Progress | Actively being worked on |
| 📋 Triaged | Confirmed, prioritized |
| ❓ Investigating | Being researched |
| ⏸️ Deferred | Postponed to future release |
| 🚫 Won't Fix | By design or not feasible |

---

## Recently Fixed

*Issues fixed in the latest beta build*

| ID | Issue | Fixed In |
|----|-------|----------|
| #125 | Installer crashes on 2GB RAM systems | beta.2 |
| #118 | AppArmor denials for Firefox camera | beta.2 |
| #112 | Grub theme not applied on BIOS systems | beta.2 |

---

## Reporting New Issues

Found something not listed here?

1. Check [GitHub Issues](https://github.com/sanchala-os/sanchala-os/issues)
2. If new, [report it](https://github.com/sanchala-os/sanchala-os/issues/new?template=beta-bug-report.yml)
3. See [Bug Reporting Guidelines](BUG-REPORTING.md)

---

## Updates

This document is updated with each beta release. Subscribe to releases on GitHub for notifications.

---

**Beta Coordinator:** beta@sanchala.id

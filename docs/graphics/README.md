# 🖥️ SANCHALA OS - Graphics Stack Documentation

## Overview

Sanchala OS provides a modern, hardware-accelerated graphics stack optimized for smooth 60fps desktop performance with Wayland and KDE Plasma 6.

## 🎯 Design Goals

1. **Smooth 60fps Desktop** - No stuttering, tearing, or lag
2. **Automatic GPU Detection** - Works out-of-box with AMD, Intel, NVIDIA
3. **Wayland-First** - Native Wayland with XWayland fallback
4. **HiDPI Support** - Crisp rendering on high-resolution displays
5. **Multi-Monitor** - Hot-plug support with per-display scaling
6. **Multi-GPU** - Hybrid graphics (PRIME) support for laptops

## 📚 Documentation Index

| Document | Description |
|----------|-------------|
| [GPU Drivers](GPU-DRIVERS.md) | Supported GPUs and driver packages |
| [Multi-GPU Setup](MULTI-GPU.md) | Hybrid graphics and PRIME configuration |
| [HiDPI Configuration](HIDPI.md) | High-resolution display scaling |
| [Troubleshooting](TROUBLESHOOTING.md) | Common issues and solutions |

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────────────┐
│                    SANCHALA GRAPHICS STACK                          │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │                    KDE PLASMA 6 SHELL                        │   │
│  │  • Plasmashell  • KRunner  • System Settings                │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                              │                                      │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │                    KWIN WAYLAND COMPOSITOR                   │   │
│  │  • OpenGL Rendering  • VSync  • Effects  • Window Mgmt      │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                              │                                      │
│  ┌──────────────────┐  ┌──────────────────┐  ┌─────────────────┐   │
│  │   WAYLAND        │  │   XWAYLAND       │  │   PIPEWIRE      │   │
│  │   Protocol       │  │   (X11 compat)   │  │   (Screenshare) │   │
│  └──────────────────┘  └──────────────────┘  └─────────────────┘   │
│                              │                                      │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │                    MESA / VULKAN / VA-API                    │   │
│  │  • OpenGL 4.6  • Vulkan 1.3  • Video Decode/Encode          │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                              │                                      │
│  ┌──────────────────┐  ┌──────────────────┐  ┌─────────────────┐   │
│  │   AMD (amdgpu)   │  │   Intel (i915)   │  │   NVIDIA        │   │
│  │   RADV Vulkan    │  │   ANV Vulkan     │  │   Proprietary   │   │
│  └──────────────────┘  └──────────────────┘  └─────────────────┘   │
│                              │                                      │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │                    DRM / KMS (Kernel)                        │   │
│  │  • Mode Setting  • Buffer Management  • Display Output      │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

## ⚙️ Configuration Files

### Environment Variables

| File | Purpose |
|------|---------|
| `/etc/environment.d/50-sanchala-graphics.conf` | Wayland session defaults |
| `/etc/environment.d/55-sanchala-multigpu.conf` | Multi-GPU/PRIME config |
| `/etc/environment.d/60-sanchala-hidpi.conf` | HiDPI scaling variables |

### Kernel Module Options

| File | Purpose |
|------|---------|
| `/etc/modprobe.d/sanchala-gpu.conf` | AMD/Intel/NVIDIA kernel params |

### udev Rules

| File | Purpose |
|------|---------|
| `/etc/udev/rules.d/70-sanchala-gpu.rules` | GPU permissions, power mgmt |

### KDE/KWin Settings

| File | Purpose |
|------|---------|
| `~/.config/kwinrc` | KWin compositor settings |
| `~/.config/kscreenrc` | Display/monitor configuration |

---

**Document Version:** 1.0  
**Last Updated:** Phase 1  
**Author:** Graphics Stack Engineer

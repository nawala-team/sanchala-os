# 🎉 Sanchala Welcome - First-Run Experience

## Overview

**sanchala-welcome** is the premier first-boot setup wizard for Sanchala OS, delivering a macOS Setup Assistant-quality onboarding experience.

## Design Philosophy

> "The first impression is the lasting impression."

- **Beautiful**: Smooth animations, polished UI, delightful micro-interactions
- **Secure**: Privacy-first defaults, transparent choices, no dark patterns
- **Intelligent**: Smart defaults, hardware detection, adaptive flows
- **Accessible**: Full keyboard navigation, screen reader support, high contrast

## Wizard Flow (12 Pages, ~4-5 minutes)

| # | Page | Purpose | Smart Features |
|---|------|---------|----------------|
| 1 | Welcome | Brand introduction | Hardware detection starts |
| 2 | Language | UI language selection | Live preview, auto-detect |
| 3 | Region | Location & formats | Interactive map, IP geolocation |
| 4 | Keyboard | Layout selection | Type-to-test, auto-detect |
| 5 | Network | WiFi/Ethernet setup | Signal strength, WPA3 support |
| 6 | Account | User creation | Avatar camera, password strength |
| 7 | Security | Encryption, biometrics | TPM detection, fingerprint |
| 8 | Privacy | Telemetry, location | All OFF by default |
| 9 | Appearance | Theme, accent, wallpaper | Live preview |
| 10 | Online Accounts | Optional cloud | Skip-friendly |
| 11 | All Done | Completion celebration | Confetti, summary |
| 12 | Tour Offer | Feature tour invitation | Contextual recommendations |

## Technology Stack

| Component | Technology |
|-----------|------------|
| Backend | Rust (async, safe) |
| Frontend | Qt 6 / QML |
| IPC | D-Bus + PolicyKit |
| Config | TOML |
| Animations | Lottie + QML |

## CLI Interface

```bash
sanchala-welcome                      # Launch wizard
sanchala-welcome --force              # Re-run setup
sanchala-welcome --page=privacy       # Jump to page
sanchala-welcome --headless --config=setup.toml
sanchala-welcome --tour               # Feature tour
sanchala-welcome --tips               # Show tips
sanchala-welcome --check-first-boot   # Exit 0/1
sanchala-welcome --reset              # Reset state
sanchala-welcomd                      # Daemon mode
```

## File Locations

| File | Purpose |
|------|---------|
| `/etc/sanchala/welcome.toml` | Configuration |
| `/var/lib/sanchala/welcome/state.json` | Wizard state |
| `/var/lib/sanchala/welcome/first-boot-complete` | First-boot flag |
| `/usr/share/sanchala/welcome/` | QML, assets, tours |
| `~/.config/sanchala/welcome/` | User preferences |

## D-Bus Interface

**Bus Name:** `id.sanchala.Welcome1`

**Methods:** Launch, GetCurrentPage, SetPageData, NavigateNext/Back, StartTour, GetNextTip  
**Signals:** PageChanged, SetupComplete, TourStepChanged, TipAvailable

---

**Document Version:** 3.0 | **Part of SANCHALA OS**

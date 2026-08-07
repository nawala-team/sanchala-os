# Sanchala OS Release Channels

> Stable, Beta, and Nightly channel specifications

## Overview

Sanchala OS provides three release channels to balance stability with access to new features.

```
┌─────────────────────────────────────────────────────────────────┐
│   [Development] ──► [Nightly] ──► [Beta] ──► [Stable]          │
│        │              │            │            │               │
│     Commits        Daily        2-4 weeks    6 months          │
└─────────────────────────────────────────────────────────────────┘
```

---

## Stable Channel

**Target:** General users, production systems

| Property | Value |
|----------|-------|
| Release Cycle | Every 6 months |
| Support Period | 12 months |
| Update Frequency | Security + critical fixes |
| Testing Level | Full QA cycle |

```ini
[sanchala-stable]
Server = https://repo.sanchala.id/stable/$arch
```

- Thoroughly tested packages
- Security updates within 48 hours
- No breaking changes within release
- Professional support available

---

## Beta Channel

**Target:** Enthusiasts, testers, early adopters

| Property | Value |
|----------|-------|
| Release Cycle | 2-4 weeks before stable |
| Support Period | Until stable release |
| Update Frequency | Weekly |
| Testing Level | Feature complete |

```ini
[sanchala-beta]
Server = https://repo.sanchala.id/beta/$arch
```

- New features for testing
- May contain known bugs
- Community feedback encouraged

**Switch to Beta:**
```bash
sudo sanchala-channel beta && sudo pacman -Syu
```

---

## Nightly Channel

**Target:** Developers, contributors

| Property | Value |
|----------|-------|
| Release Cycle | Daily (automated) |
| Support Period | None |
| Update Frequency | Daily |
| Testing Level | CI only |

```ini
[sanchala-nightly]
Server = https://repo.sanchala.id/nightly/$arch
```

- Latest development code
- May break at any time
- No stability guarantees

**Switch to Nightly:**
```bash
sudo sanchala-channel nightly --i-understand-the-risks
```

---

## Channel Comparison

| Feature | Stable | Beta | Nightly |
|---------|--------|------|---------|
| Stability | ★★★★★ | ★★★☆☆ | ★☆☆☆☆ |
| Latest Features | ★★☆☆☆ | ★★★★☆ | ★★★★★ |
| Security Updates | Immediate | Fast | Immediate |
| Support | Full | Community | None |

---

## Update Policies

| Channel | Security | Critical Bugs | Features |
|---------|----------|---------------|----------|
| Stable | 48 hours | 1 week | Next minor |
| Beta | Weekly | Weekly | As completed |
| Nightly | Daily | Daily | Immediate |

---

## Channel Management

```bash
#!/bin/bash
# /usr/bin/sanchala-channel

case "$1" in
    stable|beta)
        sed -i "s/sanchala-[a-z]*/sanchala-$1/" /etc/pacman.d/sanchala-repos.conf
        ;;
    nightly)
        [[ "$2" == "--i-understand-the-risks" ]] || { echo "Add --i-understand-the-risks"; exit 1; }
        sed -i 's/sanchala-[a-z]*/sanchala-nightly/' /etc/pacman.d/sanchala-repos.conf
        ;;
    status)
        grep -o 'sanchala-[a-z]*' /etc/pacman.d/sanchala-repos.conf | head -1
        ;;
esac
```

---

## Downgrade Procedure

**Beta → Stable:**
```bash
sudo sanchala-channel stable && sudo pacman -Syyuu
```

**Nightly → Stable:** Fresh install recommended

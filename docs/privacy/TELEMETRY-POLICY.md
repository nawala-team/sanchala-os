# 📡 Sanchala OS Telemetry Policy

## Executive Summary

**Sanchala OS collects ZERO telemetry by default.**

All data collection is:
- **Opt-in only** - You must explicitly enable it
- **Transparent** - You can see exactly what would be collected
- **Revocable** - You can disable it at any time

## What We DON'T Collect (by default)

| Data Type | Status | Reason |
|-----------|--------|--------|
| Crash reports | ❌ OFF | Your crashes, your business |
| Usage statistics | ❌ OFF | How you use your PC is private |
| Hardware info | ❌ OFF | No fingerprinting |
| Location data | ❌ OFF | Your location is sensitive |
| Search queries | ❌ OFF | Your searches are private |
| App usage | ❌ OFF | What you run is your choice |
| Network activity | ❌ OFF | Your connections are private |
| File access | ❌ OFF | Your files are yours |

## Opt-In Telemetry Categories

If you CHOOSE to help improve Sanchala OS, you can enable:

### 1. Crash Reports (Medium Privacy Impact)
**What's collected:**
- Application crash stack trace
- App version and OS version
- Basic system state at crash time

**What's NOT collected:**
- File contents
- Personal data
- Browsing history

### 2. Usage Statistics (High Privacy Impact)
**What's collected:**
- Anonymous feature usage counts
- Session duration (aggregated)
- UI interaction patterns

**What's NOT collected:**
- Personal identifiers
- Specific activities
- Timestamps

### 3. Hardware Survey (Medium Privacy Impact)
**What's collected:**
- CPU family (not serial)
- GPU model
- RAM amount
- Display resolution

**What's NOT collected:**
- Serial numbers
- MAC addresses
- Unique identifiers

## How to Check Telemetry Status

```bash
# View all telemetry settings
sanchala-privacy telemetry --status

# Output (default):
#   ✅ Crash Reports: OFF
#   ✅ Usage Statistics: OFF
#   ✅ Hardware Info: OFF
#   ✅ Location Services: OFF
```

## How to Enable/Disable

```bash
# Block everything (default state)
sanchala-privacy telemetry --block-all

# Opt-in to crash reports only
sanchala-privacy telemetry --allow crash-reports

# Disable a specific category
sanchala-privacy telemetry --block usage-statistics
```

## Network-Level Blocking

Even if an application tries to send telemetry, Sanchala OS blocks known telemetry domains at the network level:

- `telemetry.microsoft.com`
- `vortex.data.microsoft.com`
- `clientservices.googleapis.com`
- `incoming.telemetry.mozilla.org`
- `metrics.ubuntu.com`

## Third-Party Applications

Flatpak applications are sandboxed and cannot send telemetry without:
1. Network permission (visible in permission manager)
2. Bypassing our DNS/firewall blocks (difficult)

For native applications, AppArmor profiles restrict network access.

## Our Commitment

1. **No silent collection** - We will never collect data without asking
2. **No selling data** - We will never sell any data
3. **No partnerships** - No data sharing with third parties
4. **Full transparency** - This policy is always accurate and current

---

**Policy Version:** 1.0  
**Effective Date:** Sanchala OS 1.0 (Gati)  
**Contact:** privacy@sanchala.id

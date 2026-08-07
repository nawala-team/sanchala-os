# 🔐 Sanchala Privacy - Privacy Dashboard & Controls

## Overview

**sanchala-privacy** is the central privacy management system for Sanchala OS. It provides a unified dashboard for managing all privacy settings, permission auditing, telemetry controls, and data transparency.

## Design Philosophy

> "Privacy is not about having something to hide. It's about having control over your own data."

Sanchala OS is built with **privacy-by-default**:
- All telemetry is **OFF** by default
- All permissions require **explicit consent**
- All data collection is **transparent and auditable**
- Users have **complete control** over their data

## Architecture

```
┌─────────────────────────────────────────────────────────────────────────┐
│                      SANCHALA PRIVACY DASHBOARD                          │
├─────────────────────────────────────────────────────────────────────────┤
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  ┌─────────────┐ │
│  │   Privacy    │  │  Permission  │  │  Telemetry   │  │    Data     │ │
│  │   Overview   │  │    Audit     │  │   Controls   │  │  Inventory  │ │
│  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘  └──────┬──────┘ │
│         └─────────────────┴─────────────────┴──────────────────┘        │
│                         ┌──────────┴──────────┐                         │
│                         │   Privacy Engine    │                         │
│                         │   (sanchala-privd)  │                         │
│                         └──────────┬──────────┘                         │
└────────────────────────────────────┼────────────────────────────────────┘
         ┌───────────────────────────┼───────────────────────────┐
         ▼                           ▼                           ▼
    ┌─────────┐              ┌──────────────┐             ┌──────────┐
    │Guardian │              │  Permission  │             │ Telemetry│
    │   API   │              │   Manager    │             │  Service │
    └─────────┘              └──────────────┘             └──────────┘
```

## Components

### 1. Privacy Dashboard (`sanchala-privacy-dashboard`)
- Unified UI for all privacy settings
- Real-time privacy score calculation
- Visual permission overview

### 2. Privacy Daemon (`sanchala-privd`)
- Background service for privacy enforcement
- Integration with sanchala-guardian
- Telemetry blocking enforcement

### 3. Permission Auditor (`sanchala-permission-audit`)
- Comprehensive permission analysis

## CLI Interface

```bash
# Show privacy dashboard summary
sanchala-privacy status

# Run privacy audit
sanchala-privacy audit

# Show permission report for all apps
sanchala-privacy permissions --list

# Show specific app permissions
sanchala-privacy permissions --app com.brave.Browser

# Check telemetry status
sanchala-privacy telemetry --status

# Block all telemetry (default)
sanchala-privacy telemetry --block-all

# Show data inventory
sanchala-privacy data --inventory

# Export privacy report
sanchala-privacy report --export ~/privacy-report.json
```

## D-Bus Interface

**Bus Name:** `id.sanchala.Privacy`  
**Object Path:** `/id/sanchala/Privacy`

### Methods
- `GetPrivacyScore() -> (u)` - Returns privacy score 0-100
- `GetPrivacyReport() -> (s)` - Full JSON privacy report
- `GetPermissionAudit(days: u) -> (s)` - Permission audit for N days
- `GetTelemetryStatus() -> (s)` - Telemetry settings as JSON
- `SetTelemetryOption(option: s, enabled: b) -> (b)` - Toggle telemetry option

### Signals
- `PrivacyScoreChanged(score: u)` - Privacy score updated
- `PermissionAccessed(app_id: s, permission: s)` - Permission was used
- `TelemetryBlocked(source: s, destination: s)` - Telemetry attempt blocked

## File Locations

| File | Purpose |
|------|---------|
| `/etc/sanchala/privacy.toml` | Main privacy configuration |
| `/etc/sanchala/telemetry.toml` | Telemetry settings |
| `/var/lib/sanchala/privacy/audit.db` | Permission audit database |
| `/var/log/sanchala/privacy.log` | Privacy daemon log |

## Privacy Score Calculation

| Factor | Weight | Best Practice |
|--------|--------|---------------|
| Telemetry disabled | 25% | All telemetry OFF |
| Permission hygiene | 25% | Minimal permissions granted |
| Network privacy | 20% | DoH, MAC randomization |
| Data retention | 15% | Minimal data stored |
| Security posture | 15% | Encryption, firewall |

---

**Document Version:** 1.0  
**Part of SANCHALA OS** - Privacy by Default

- Historical access logs
- Anomaly detection

### 4. Telemetry Controller (`sanchala-telemetry-ctl`)
- Granular telemetry controls
- Network-level blocking
- Opt-in consent management

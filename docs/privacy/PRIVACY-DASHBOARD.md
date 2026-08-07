# 📊 Sanchala Privacy Dashboard Guide

## Overview

The Privacy Dashboard provides a unified view of your privacy status and controls.

## Accessing the Dashboard

### GUI Method
1. Open **System Settings**
2. Navigate to **Privacy & Security**
3. Click **Privacy Dashboard**

### CLI Method
```bash
sanchala-privacy status
```

## Dashboard Sections

### 1. Privacy Score
The main indicator showing your overall privacy health (0-100).

```
╔══════════════════════════════════════════════════════════════╗
║          SANCHALA PRIVACY - Dashboard                        ║
╚══════════════════════════════════════════════════════════════╝

  Privacy Score: 🟢 EXCELLENT (97/100)
```

### 2. Telemetry Status
Shows how many telemetry options are enabled (should be 0/8 for maximum privacy).

```
  ✅ Telemetry: 0/8 options enabled
```

### 3. Network Privacy
Percentage of network privacy features enabled.

```
  ✅ Network Privacy: 100%
```

### 4. Permission Audit
Shows if permission tracking is active.

```
  ✅ Permission Audit: Active
```

## Score Breakdown

| Component | Max Points | How to Maximize |
|-----------|------------|-----------------|
| Telemetry | 25 | Keep all telemetry OFF |
| Permissions | 25 | Enable audit + notifications |
| Network | 20 | Enable DoH, MAC randomization |
| Data Retention | 15 | Short retention, no clipboard |
| Security | 15 | Encryption + firewall |

## Actions

### Improve Your Score
```bash
# Block all telemetry
sanchala-privacy telemetry --block-all

# Enable permission notifications
sanchala-privacy config --set permissions.notify_on_access=true
```

### Export Privacy Report
```bash
sanchala-privacy report --export ~/my-privacy-report.json
```

---

**Document Version:** 1.0

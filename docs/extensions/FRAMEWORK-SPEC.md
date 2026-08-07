# Extension Framework Specification

## 1. Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│                  SANCHALA EXTENSION RUNTIME                  │
├─────────────────────────────────────────────────────────────┤
│  ┌────────────────────────────────────────────────────┐     │
│  │         Extension Manager (sanchala-extensiond)    │     │
│  └────────────────────────┬───────────────────────────┘     │
│         ┌─────────────────┼─────────────────┐               │
│         ▼                 ▼                 ▼               │
│  ┌────────────┐   ┌────────────┐   ┌────────────┐          │
│  │  Package   │   │  Runtime   │   │ Permission │          │
│  │  Manager   │   │  Sandbox   │   │  Manager   │          │
│  └────────────┘   └────────────┘   └────────────┘          │
└─────────────────────────────────────────────────────────────┘
```

## 2. Package Format

### 2.1 Plasmoid Structure
```
org.sanchala.example/
├── metadata.json           # Required
├── contents/
│   ├── ui/main.qml        # Entry point
│   ├── code/logic.js      # JavaScript
│   └── config/main.xml    # Config schema
└── LICENSE
```

### 2.2 KWin Script Structure
```
sanchala-example/
├── metadata.json
├── contents/
│   ├── code/main.js       # Entry point
│   └── config/main.xml
└── LICENSE
```

### 2.3 Metadata Schema
```json
{
    "KPlugin": {
        "Id": "org.sanchala.example",
        "Name": "Example Widget",
        "Version": "1.0.0",
        "License": "GPL-3.0"
    },
    "X-Plasma-API": "declarativeappletscript",
    "X-Plasma-MainScript": "ui/main.qml",
    "X-Sanchala-Permissions": ["network", "notifications"],
    "X-Sanchala-MinVersion": "1.0"
}
```

## 3. Permission System

| Permission | Description | Risk |
|------------|-------------|------|
| `network` | Internet access | Medium |
| `notifications` | System notifications | Low |
| `clipboard` | Clipboard access | Medium |
| `filesystem:read` | Read files | High |
| `filesystem:write` | Write files | High |
| `system-info` | System information | Low |
| `dbus:session` | Session D-Bus | Medium |
| `dbus:system` | System D-Bus | High |
| `exec` | Execute commands | Critical |
| `hardware` | Hardware sensors | Medium |

## 4. Signing Requirements

All extensions must be GPG-signed. Signature chain:
- **Root CA** → Extension Signing Key → Developer Key (optional)

```bash
sanchala-extensions sign ./widget.plasmoid --key ~/.gnupg/key.asc
sanchala-extensions verify ./widget.plasmoid
```

## 5. Resource Limits

| Resource | Default | Configurable |
|----------|---------|--------------|
| CPU | 10% | Yes |
| Memory | 100 MB | Yes |
| Network | 1 MB/s | Yes |
| File handles | 100 | No |

## 6. Extension Lifecycle

```
Available → Installed → Active
                ↓          ↓
            Removed    Disabled
```

---
**Version:** 1.0 | **Last Updated:** August 2026

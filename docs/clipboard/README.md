# 📋 SANCHALA OS - Universal Clipboard

## Overview

Sanchala OS features a **Universal Clipboard** system inspired by Apple's seamless cross-device clipboard experience. Copy on your phone, paste on your desktop. Copy an image on your tablet, paste it in your document on your laptop.

## Key Features

| Feature | Description |
|---------|-------------|
| 🔄 Cross-Device Sync | Seamless clipboard sharing via KDE Connect |
| 📜 100-Item History | Extended clipboard history with search |
| 🖼️ Rich Content | Images, files, formatted text, colors |
| 🔒 Auto-Clear Secrets | Passwords cleared in 30 seconds |
| ✋ Handoff | Continue work on another device |
| 🔍 Smart Actions | Context-aware paste actions |

## Quick Start

```bash
# Show clipboard history
Meta+V

# Paste as plain text
Meta+Shift+Ctrl+V

# Clear clipboard
Meta+Shift+V

# Search clipboard history
Meta+Ctrl+F
```

## Documentation Index

| Document | Description |
|----------|-------------|
| [CLIPBOARD-SYNC.md](CLIPBOARD-SYNC.md) | Cross-device sync setup |
| [SENSITIVE-DATA.md](SENSITIVE-DATA.md) | Password & sensitive data handling |
| [RICH-CONTENT.md](RICH-CONTENT.md) | Images, files, and formatting |
| [CONFIGURATION.md](CONFIGURATION.md) | All settings explained |

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Universal Clipboard                       │
├─────────────────────────────────────────────────────────────┤
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │   Klipper   │  │  Security   │  │    KDE Connect      │  │
│  │   Backend   │  │   Filter    │  │   Sync Provider     │  │
│  └──────┬──────┘  └──────┬──────┘  └──────────┬──────────┘  │
│         │                │                     │             │
│         ▼                ▼                     ▼             │
│  ┌─────────────────────────────────────────────────────────┐│
│  │              Clipboard Manager Core                      ││
│  │  • History (100 items)  • Rich Content  • Actions       ││
│  └─────────────────────────────────────────────────────────┘│
│         │                │                     │             │
│         ▼                ▼                     ▼             │
│  ┌───────────┐    ┌───────────┐    ┌───────────────────┐   │
│  │  Desktop  │    │   Phone   │    │      Tablet       │   │
│  │  (Linux)  │    │ (Android) │    │  (Android/Linux)  │   │
│  └───────────┘    └───────────┘    └───────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

## Comparison with Other Systems

| Feature | Sanchala | macOS | Windows | GNOME |
|---------|----------|-------|---------|-------|
| History Size | 100 | 1 | 25 | 1 |
| Cross-Device | ✅ | ✅ | ✅ | ❌ |
| Image Support | ✅ | ✅ | ✅ | ✅ |
| Auto-Clear Secrets | ✅ | ❌ | ❌ | ❌ |
| Handoff | ✅ | ✅ | ❌ | ❌ |
| Open Source | ✅ | ❌ | ❌ | ✅ |

## Privacy & Security

- **Sensitive data auto-clears** in 30 seconds
- **Password managers** trigger immediate clear
- **No sync of sensitive data** by default
- **Encrypted transit** for cross-device sync
- **Local history** never sent to cloud

---

**Document Version:** 1.0  
**Part of SANCHALA OS** - Universal Clipboard

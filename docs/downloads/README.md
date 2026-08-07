# 📥 SANCHALA OS - Download Management System

## Overview

Sanchala OS provides an integrated download management system combining high-speed HTTP/FTP downloads via **aria2** with robust BitTorrent support via **qBittorrent**. The system features browser integration, bandwidth scheduling, and privacy-focused defaults.

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    SANCHALA DOWNLOAD MANAGEMENT STACK                        │
├─────────────────────────────────────────────────────────────────────────────┤
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │                        Browser Integration                           │   │
│  │   Firefox │ Chromium │ Brave │ Vivaldi │ Native Messaging API       │   │
│  └──────────────────────────────┬──────────────────────────────────────┘   │
│                                 │                                           │
│  ┌──────────────────────────────▼──────────────────────────────────────┐   │
│  │              sanchala-browser-download (Interceptor)                 │   │
│  │         URL Analysis │ Size Check │ Extension Match │ Routing        │   │
│  └──────────┬───────────────────────────────────────────┬──────────────┘   │
│             │                                           │                   │
│  ┌──────────▼──────────┐                    ┌───────────▼───────────┐      │
│  │    aria2 Daemon     │                    │     qBittorrent       │      │
│  │   (HTTP/FTP/Meta)   │                    │   (BitTorrent/P2P)    │      │
│  │   RPC: port 6800    │                    │   Port: 6881-6999     │      │
│  └──────────┬──────────┘                    └───────────┬───────────┘      │
│             │                                           │                   │
│  ┌──────────▼───────────────────────────────────────────▼──────────────┐   │
│  │                   Bandwidth Scheduler Service                        │   │
│  │        Time-based Limits │ Battery Aware │ Metered Detection        │   │
│  └──────────────────────────────────────────────────────────────────────┘   │
│                                 │                                           │
│  ┌──────────────────────────────▼──────────────────────────────────────┐   │
│  │                      Download Directories                            │   │
│  │   ~/Downloads │ ~/Downloads/Torrents │ ~/Downloads/Incomplete       │   │
│  └──────────────────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## 🚀 Components

### 1. aria2 Download Accelerator

High-performance, multi-protocol download utility supporting:

| Protocol | Features |
|----------|----------|
| HTTP/HTTPS | Multi-connection, resume, cookies |
| FTP/SFTP | Passive mode, resume support |
| BitTorrent | DHT, PEX, encryption, magnet |
| Metalink | Auto mirror selection |

**Key Features:**
- 16 connections per download (configurable)
- Automatic file segmentation
- JSON-RPC interface for GUI integration
- Session persistence (resume on restart)

### 2. qBittorrent Torrent Client

Modern, feature-rich BitTorrent client:

- **Anonymous Mode** enabled by default
- **Encryption** required for all connections
- RSS feed support with auto-download rules
- Built-in search engine
- IP filtering support
- Sequential downloading option

### 3. Browser Integration

Seamless download capture from all major browsers:

- Automatic interception of large files (>10MB)
- Extension-based capture (.exe, .iso, .zip, etc.)
- Magnet link handling
- Torrent file association

---

## 📁 Configuration Files

```
/etc/
├── aria2/
│   └── aria2.conf                    # aria2 daemon configuration
├── qbittorrent/
│   ├── qBittorrent.conf              # Main qBittorrent config
│   └── qBittorrent-preferences.conf  # User preferences
├── sanchala/downloads/
│   └── downloads.conf                # Central download settings
├── chromium/native-messaging-hosts/
│   └── sanchala_download_manager.json
└── systemd/user/
    ├── sanchala-aria2@.service       # aria2 user service
    ├── sanchala-bandwidth-scheduler.service
    └── sanchala-bandwidth-scheduler.timer

/usr/lib/
├── mozilla/native-messaging-hosts/
│   └── sanchala_download_manager.json
└── sanchala/
    ├── sanchala-download-manager.sh
    ├── sanchala-bandwidth-scheduler.sh
    └── sanchala-browser-download.sh
```

---

## 🔗 Related Documentation

- [aria2 Configuration](ARIA2-CONFIG.md)
- [qBittorrent Setup](QBITTORRENT-SETUP.md)
- [uGet GUI Guide](UGET-GUIDE.md)
- [Browser Integration](BROWSER-INTEGRATION.md)
- [Bandwidth Scheduling](BANDWIDTH-SCHEDULING.md)
- [Privacy Settings](PRIVACY.md)

---

**Document Version:** 1.0 | **Author:** Download Manager Engineer

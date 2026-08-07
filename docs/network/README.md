# 🌐 SANCHALA OS - Network Stack Documentation

## Overview

Sanchala OS implements a **Zero Trust Network** architecture (Layer 8 of our security model) that provides secure-by-default networking with privacy-first design principles.

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    SANCHALA NETWORK STACK                               │
├─────────────────────────────────────────────────────────────────────────┤
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │                     Applications                                 │   │
│  └─────────────────────────────────────────────────────────────────┘   │
│                              │                                          │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │              systemd-resolved (DoH/DoT/DNSSEC)                   │   │
│  │  Cloudflare 1.1.1.1 │ Quad9 9.9.9.9 │ Mullvad 194.242.2.2       │   │
│  └─────────────────────────────────────────────────────────────────┘   │
│                              │                                          │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │                   NetworkManager                                 │   │
│  │      Privacy Config │ Security Config │ VPN Config              │   │
│  └─────────────────────────────────────────────────────────────────┘   │
│                              │                                          │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │                nftables Firewall                                 │   │
│  │      Input Chain │ Forward Chain │ Output Chain │ NAT Table     │   │
│  └─────────────────────────────────────────────────────────────────┘   │
│                              │                                          │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │      Ethernet eth0 │ WiFi wlan0 │ WireGuard wg0 │ OpenVPN tun0  │   │
│  └─────────────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## 🔒 Security Features

### 1. MAC Address Randomization

| Mode | Description | Use Case |
|------|-------------|----------|
| **Stable** (default) | Same MAC per network SSID | Daily use |
| **Random** | New MAC every connection | Public networks |
| **Permanent** | Hardware MAC | Enterprise MAB |

### 2. DNS-over-HTTPS (DoH) / DNS-over-TLS (DoT)

All DNS queries encrypted by default:
- **Primary:** Cloudflare (1.1.1.1) - Fast, privacy-focused
- **Secondary:** Quad9 (9.9.9.9) - Malware blocking
- **Fallback:** Mullvad (194.242.2.2) - No logging

### 3. Firewall (nftables)

Default policy: **DROP incoming, ACCEPT outgoing**

### 4. IPv6 Privacy Extensions

- Temporary addresses (RFC 4941) enabled
- Stable-privacy addressing mode

---

## 📁 Configuration Files

```
/etc/
├── NetworkManager/
│   ├── NetworkManager.conf              # Main config
│   ├── conf.d/
│   │   ├── 10-sanchala-privacy.conf     # MAC randomization
│   │   ├── 20-sanchala-security.conf    # Security hardening
│   │   └── 30-sanchala-vpn.conf         # VPN settings
│   ├── dispatcher.d/
│   │   ├── 40-sanchala-dns-leak-protect # DNS leak prevention
│   │   └── 50-sanchala-vpn-killswitch   # VPN kill switch
│   └── system-connections/              # Saved connections
├── systemd/resolved.conf.d/
│   ├── sanchala-dns.conf                # DoH/DoT config
│   └── sanchala-dns-strict.conf.example # Strict mode template
└── nftables.conf → /security/firewall/nftables-sanchala.conf
```

---

## 🔗 Related Documentation

- [VPN Integration Spec](VPN-INTEGRATION.md)
- [DNS Security](DNS-SECURITY.md)
- [Firewall Guide](FIREWALL.md)

**Document Version:** 1.0 | **Author:** Network Stack Engineer

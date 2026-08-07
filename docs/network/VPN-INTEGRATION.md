# 🔐 SANCHALA OS - VPN Integration Specification

## Overview

VPN integration for Sanchala OS implements Layer 8 (Zero Trust Network) of the security architecture.

## 🎯 Design Goals

1. **Seamless Integration** - Works out-of-the-box with NetworkManager
2. **Privacy by Default** - Kill switch and DNS leak protection enabled
3. **User Choice** - Support multiple VPN providers and protocols
4. **No Vendor Lock-in** - Standard protocols only

---

## 📦 Required Packages

```bash
wireguard-tools          # WireGuard userspace tools
networkmanager           # Network management daemon
networkmanager-openvpn   # OpenVPN plugin
networkmanager-strongswan # IKEv2/IPsec plugin
plasma-nm               # KDE Plasma network widget
```

---

## 🔧 WireGuard Integration

### Why WireGuard?

| Feature | WireGuard | OpenVPN |
|---------|-----------|---------|
| Codebase | ~4,000 lines | ~100,000 lines |
| Speed | Excellent | Good |
| Battery | Low impact | Higher |
| Crypto | Modern (ChaCha20) | Configurable |

### Configuration Format

```ini
[connection]
id=MyVPN
type=wireguard
interface-name=wg0

[wireguard]
private-key=<base64_private_key>

[wireguard-peer.<public_key>]
endpoint=vpn.example.com:51820
allowed-ips=0.0.0.0/0;::/0;
persistent-keepalive=25

[ipv4]
address1=10.x.x.x/32
method=manual
dns=10.x.x.1;
```

### Import Config

```bash
nmcli connection import type wireguard file wg0.conf
```

---

## 🛡️ Kill Switch Implementation

The kill switch prevents traffic leaks when VPN disconnects:

```
VPN Connected:     All traffic → VPN tunnel → Internet
VPN Disconnected:  All traffic → BLOCKED (except local)
Kill Switch Off:   All traffic → Direct to Internet
```

### nftables Rules

```nft
table inet sanchala_killswitch {
    chain output {
        type filter hook output priority filter + 10; policy drop;
        oifname "wg*" accept
        oifname "tun*" accept
        oif "lo" accept
        udp dport 67 accept
        counter drop
    }
}
```

---

## 🔒 DNS Leak Protection

Prevents DNS queries from bypassing VPN:
1. VPN connects → Only VPN DNS allowed
2. DoH/DoT traffic always permitted
3. Plain DNS blocked to non-VPN interfaces

---

## 📊 Provider Compatibility

| Provider | Protocol | Status |
|----------|----------|--------|
| Mullvad | WireGuard | ✅ Verified |
| ProtonVPN | WireGuard | ✅ Verified |
| NordVPN | WireGuard | ✅ Verified |
| ExpressVPN | OpenVPN | ✅ Verified |
| IVPN | WireGuard | ✅ Verified |
| Custom/Self-hosted | WireGuard | ✅ Verified |

**Document Version:** 1.0 | **Author:** Network Stack Engineer

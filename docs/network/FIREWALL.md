# 🔥 SANCHALA OS - Firewall Configuration

## Overview

Sanchala OS uses **nftables** for firewall management with a default-deny incoming policy.

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                    NFTABLES FIREWALL                            │
├─────────────────────────────────────────────────────────────────┤
│  table inet sanchala_firewall                                   │
│  ├── chain input    (policy: DROP)                              │
│  ├── chain forward  (policy: DROP)                              │
│  ├── chain output   (policy: ACCEPT)                            │
│  └── sets: allowed_tcp_ports, allowed_udp_ports, rate_limit     │
├─────────────────────────────────────────────────────────────────┤
│  table ip sanchala_nat                                          │
│  ├── chain prerouting                                           │
│  └── chain postrouting (masquerade for VPN/VMs)                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🛡️ Default Rules

### Input Chain
- ✅ Established/related connections
- ✅ Loopback interface
- ✅ ICMP with rate limiting (5/sec)
- ✅ ICMPv6 for IPv6 functionality
- ✅ DHCP client
- ❌ Everything else (logged)

### Output Chain
- ✅ All outgoing traffic allowed
- ❌ Known bad hosts blocked

---

## 🔧 Common Commands

```bash
# View all rules
sudo nft list ruleset

# View specific table
sudo nft list table inet sanchala_firewall

# Allow a TCP port
sudo nft add element inet sanchala_firewall allowed_tcp_ports { 8080 }

# Remove a port
sudo nft delete element inet sanchala_firewall allowed_tcp_ports { 8080 }

# Block an IP
sudo nft add element inet sanchala_firewall blocked_hosts_v4 { 1.2.3.4 }

# View dropped packets log
sudo journalctl -k | grep SANCHALA-DROP
```

---

## 📁 Configuration Files

| File | Purpose |
|------|---------|
| `/security/firewall/nftables-sanchala.conf` | Base firewall rules |
| `/security/firewall/nftables-sanchala-enhanced.conf` | VPN-aware rules |

---

## 🔒 VPN Kill Switch

When VPN is active, additional rules block non-VPN traffic:

```bash
# Check if kill switch is active
sudo nft list table inet sanchala_killswitch 2>/dev/null && echo "ACTIVE" || echo "INACTIVE"
```

**Document Version:** 1.0 | **Author:** Network Stack Engineer

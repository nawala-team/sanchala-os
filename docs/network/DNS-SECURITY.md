# 🔒 SANCHALA OS - DNS Security

## Overview

Sanchala OS encrypts all DNS traffic by default using DNS-over-TLS (DoT) with DNSSEC validation.

---

## 🏗️ Architecture

```
┌──────────────┐     TLS (Port 853)     ┌──────────────┐
│  Your Device │ ◄─────────────────────► │  DNS Server  │
│   resolved   │     Encrypted DNS       │   1.1.1.1    │
└──────────────┘                         └──────────────┘
```

---

## 🌐 Default DNS Servers

| Server | IP | Features |
|--------|-----|----------|
| **Cloudflare** | 1.1.1.1, 1.0.0.1 | Fast, privacy-focused |
| **Quad9** | 9.9.9.9 | Malware blocking |
| **Mullvad** | 194.242.2.2 | No logging, privacy |

---

## ⚙️ Configuration Modes

### Opportunistic (Default)
- Try TLS, fallback to plain DNS if unavailable
- Maximum compatibility
- Config: `DNSOverTLS=opportunistic`

### Strict Mode
- Require TLS for all queries
- Fail if TLS unavailable
- Config: `DNSOverTLS=yes`

Enable strict mode:
```bash
sudo cp /etc/systemd/resolved.conf.d/sanchala-dns-strict.conf.example \
        /etc/systemd/resolved.conf.d/sanchala-dns-strict.conf
sudo systemctl restart systemd-resolved
```

---

## 🛡️ DNSSEC

DNSSEC validates DNS responses cryptographically:

```bash
# Check DNSSEC status
resolvectl status

# Test DNSSEC validation
resolvectl query sigok.verteiltesysteme.net  # Should succeed
resolvectl query sigfail.verteiltesysteme.net # Should fail
```

---

## 🔧 Troubleshooting

```bash
# Check DNS status
resolvectl status

# Test resolution
resolvectl query archlinux.org

# View statistics
resolvectl statistics

# Flush cache
resolvectl flush-caches
```

**Document Version:** 1.0 | **Author:** Network Stack Engineer

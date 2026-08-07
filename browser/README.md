# Sanchala Browser

Privacy-first, maximum security web browser based on Chromium/Brave with native KDE/Qt integration.

## Features

### Security (MAX Level - Exceeds Safari/Chrome/Brave)

| Feature | Status | Description |
|---------|--------|-------------|
| Strict Site Isolation | ✅ Default ON | Every site in separate process |
| DNS over HTTPS (DoH) | ✅ Default ON | Cloudflare/Quad9/NextDNS |
| Encrypted Client Hello | ✅ Default ON | SNI privacy protection |
| Certificate Transparency | ✅ Default ON | CT log verification |
| HTTPS-Only Mode | ✅ Default ON | Auto-upgrade, block HTTP |
| Phishing Protection | ✅ Default ON | Real-time threat detection |
| Malware Protection | ✅ Default ON | Download scanning |

### Fingerprint Protection (All Default ON)

- **Canvas** - Noise injection per-origin
- **WebGL** - Masked vendor/renderer
- **Audio** - AudioContext noise
- **Font** - Standard font set only
- **Hardware** - Masked CPU/RAM/Screen
- **WebRTC** - IP leak protection (relay-only)
- **User-Agent** - Randomization
- **Referrer** - Strict stripping

### Sanchala Shield (Ad/Tracker Blocker)

- EasyList + EasyPrivacy filters
- Disconnect.me tracker database
- Cosmetic filtering (element hiding)
- Script blocking (optional)
- Cookie control
- HTTPS upgrades

### Privacy Features

- Tor integration (one-click)
- Built-in VPN (WireGuard)
- Private browsing mode
- Cookie auto-delete
- Permission hardening
- Clipboard protection

### UI Features

- Vertical tabs
- Tab groups
- Split view
- Sidebar (bookmarks, history, downloads)
- Reader mode
- Picture-in-Picture
- Screenshot tool
- PDF viewer
- Built-in translate

### Services

- Sync (encrypted, self-hosted option)
- Password manager (Keychain integration)
- Crypto wallet
- Extensions (Chrome Web Store compatible)
- Parental controls

### Integration

- **Sanchala Keychain** - Native password/secret storage
- **Sanchala Guardian** - Real-time threat protection
- **KDE/Qt** - Native theme integration

## Building

```bash
# Install dependencies
./scripts/install-deps.sh

# Fetch Chromium source
./scripts/build.sh fetch

# Apply patches
./scripts/build.sh patch

# Configure
./scripts/build.sh config

# Build
./scripts/build.sh build

# Package
./scripts/build.sh package

# Or all at once
./scripts/build.sh all
```

## Configuration

Default config: `config/sanchala.conf`

All security features enabled by default at MAX level.

## License

MPL-2.0

## Security Policy

Report vulnerabilities to security@sanchala.org

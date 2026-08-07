# Game Streaming Guide

Stream games from your PC to other devices or from cloud gaming services.

## Moonlight (Client)

Play games streamed from another PC running Sunshine or NVIDIA GameStream.

### Setup

```bash
moonlight-qt
```

1. Launch Moonlight
2. Enter host PC IP address
3. Pair with PIN code displayed on host
4. Select game/desktop to stream

### Optimal Settings

| Setting | Recommended |
|---------|-------------|
| Resolution | Match your display |
| FPS | 60 (or 120 if supported) |
| Bitrate | 20-50 Mbps (wired), 10-20 Mbps (WiFi) |
| Codec | HEVC (H.265) if supported |

## Sunshine (Server)

Stream your games to Moonlight clients.

### Installation

```bash
sudo pacman -S sunshine
```

### Configuration

```bash
# Start service
systemctl --user enable --now sunshine

# Access web UI
xdg-open https://localhost:47990
```

### First-Time Setup

1. Open web UI (https://localhost:47990)
2. Set username and password
3. Configure apps (games) to stream
4. Pair clients via PIN

### Adding Games

In web UI → Applications:

```json
{
  "name": "Steam Big Picture",
  "cmd": "steam -bigpicture"
}
```

### Network Setup

For remote streaming (outside LAN):

1. Forward ports: 47984-47990 (TCP/UDP)
2. Or use ZeroTier/Tailscale VPN

## Performance Tips

### Wired Connection

Use Ethernet for lowest latency. WiFi 6 is acceptable.

### Hardware Encoding

| GPU | Encoder |
|-----|---------|
| NVIDIA | NVENC (best) |
| AMD | VAAPI/AMF |
| Intel | QuickSync |

### Reduce Latency

```bash
# In Moonlight settings
- Enable "Frame pacing"
- Disable V-Sync on client
- Use Game Mode on host
```

## Cloud Gaming

### Steam Remote Play

Built into Steam. Enable in:
**Steam → Settings → Remote Play**

### Xbox Cloud Gaming

```bash
# Use Edge browser or:
flatpak install flathub com.microsoft.Edge
```

### GeForce NOW

```bash
# Browser or app
flatpak install flathub com.nvidia.geforcenow
```

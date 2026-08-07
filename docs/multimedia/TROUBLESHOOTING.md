# Multimedia Troubleshooting

Common issues and solutions for audio/video in SANCHALA OS.

## Audio Issues

### No Sound

```bash
# 1. Restart PipeWire stack
systemctl --user restart pipewire pipewire-pulse wireplumber

# 2. Check service status
systemctl --user status pipewire

# 3. Check for errors
journalctl --user -u pipewire -u wireplumber --since "5 min ago"

# 4. Verify output device
wpctl status
wpctl set-default <sink-id>
```

### Crackling / Dropouts

```bash
# Increase buffer size
pw-metadata -n settings 0 clock.force-quantum 512

# Or switch to powersave mode
sanchala-audio-mode powersave

# Check for xruns
pw-top
```

### Application Has No Sound

```bash
# Check if app appears in PipeWire
pw-cli list-objects Node | grep -i "app-name"

# Restart the application after PipeWire restart
```

### Wrong Output Device

```bash
# List sinks
wpctl status

# Set default
wpctl set-default <sink-id>

# Set volume
wpctl set-volume @DEFAULT_AUDIO_SINK@ 80%
```

## Bluetooth Audio

### Device Won't Connect

```bash
# Restart Bluetooth
sudo systemctl restart bluetooth

# Remove and re-pair
bluetoothctl
> remove XX:XX:XX:XX:XX:XX
> scan on
> pair XX:XX:XX:XX:XX:XX
> connect XX:XX:XX:XX:XX:XX
```

### Low Quality Audio (HFP instead of A2DP)

```bash
# Check current profile
pactl list cards | grep -A5 "bluez"

# Switch to A2DP
pactl set-card-profile bluez_card.XX_XX_XX_XX_XX_XX a2dp-sink
```

### Codec Not Available

Ensure codec packages are installed:
```bash
sudo pacman -S libldac libfreeaptx
systemctl --user restart pipewire
```

## Video Issues

### No Hardware Acceleration

```bash
# Check VA-API
vainfo

# If empty, check driver
LIBVA_DRIVER_NAME=radeonsi vainfo  # AMD
LIBVA_DRIVER_NAME=iHD vainfo       # Intel

# Check permissions
groups  # Should include 'video'
ls -la /dev/dri/
```

### Screen Recording Black Screen

```bash
# Check portal is running
systemctl --user status xdg-desktop-portal-kde

# Restart portal
systemctl --user restart xdg-desktop-portal-kde

# Check PipeWire screencast
pw-cli list-objects | grep -i screen
```

### Camera Not Detected

```bash
# List devices
v4l2-ctl --list-devices

# Check permissions
ls -la /dev/video*
# User should be in 'video' group

# Check PipeWire camera
pw-cli list-objects | grep -i v4l2
```

## Service Recovery

### Full Reset

```bash
# Stop all services
systemctl --user stop pipewire pipewire-pulse wireplumber

# Clear runtime state
rm -rf ~/.local/state/pipewire
rm -rf ~/.local/state/wireplumber

# Restart
systemctl --user start pipewire wireplumber
```

### Check Logs

```bash
# PipeWire logs
journalctl --user -u pipewire -f

# WirePlumber logs
journalctl --user -u wireplumber -f

# Verbose mode
PIPEWIRE_DEBUG=3 pipewire
```

## Getting Help

If issues persist:
1. Check `pw-top` for real-time diagnostics
2. Review logs with `journalctl --user -u pipewire`
3. Report issues with hardware info: `inxi -A`

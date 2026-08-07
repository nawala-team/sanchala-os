# Gaming Performance Guide

Optimize your system for the best gaming performance.

## Game Mode

Enable system-wide optimizations:

```bash
sanchala-gaming start
```

What it does:
- CPU governor → performance
- GPU power → high
- Compositor → suspended
- Indexers → paused

## MangoHud (Performance Overlay)

### Enable

```bash
# Per-game (Steam launch options)
MANGOHUD=1 %command%

# Or globally
echo 'MANGOHUD=1' >> ~/.profile
```

### Toggle In-Game

**Right Shift + F12**

### Configuration

Edit `~/.config/MangoHud/MangoHud.conf`:

```ini
fps
frametime
cpu_stats
cpu_temp
gpu_stats
gpu_temp
vram
ram
position=top-left
```

### GUI Configuration

```bash
goverlay
```

## Gamescope (SteamOS Compositor)

Consistent frame pacing and upscaling:

```bash
# Basic usage
gamescope -w 1920 -h 1080 -f -- game

# With FSR upscaling (1080p → 1440p)
gamescope -w 1920 -h 1080 -W 2560 -H 1440 -f -- game

# SteamOS-like session
gamescope -e -- steam -gamepadui
```

## FSR (FidelityFX Super Resolution)

Enable in Wine/Proton:

```bash
WINE_FULLSCREEN_FSR=1 WINE_FULLSCREEN_FSR_STRENGTH=2 %command%
```

Strength: 0 (sharpest) to 5 (softest)

## VkBasalt (Post-Processing)

Add sharpening and effects:

```bash
# Enable
ENABLE_VKBASALT=1 game_command
```

Config `~/.config/vkBasalt/vkBasalt.conf`:

```ini
effects = cas
casSharpness = 0.4
```

## Frame Limiting

```bash
# MangoHud
MANGOHUD_CONFIG=fps_limit=60 game

# libstrangle
strangle 60 game
```

## GPU Optimization

### AMD

```bash
# Performance mode
echo high | sudo tee /sys/class/drm/card0/device/power_dpm_force_performance_level

# Monitor
corectrl
```

### NVIDIA

```bash
# Performance mode
nvidia-settings -a "[gpu:0]/GpuPowerMizerMode=1"

# Monitor
nvidia-smi -l 1
```

## CPU Optimization

```bash
# Set performance governor
sudo cpupower frequency-set -g performance

# Disable CPU boost (reduces heat)
echo 0 | sudo tee /sys/devices/system/cpu/cpufreq/boost
```

## Kernel Parameters

Add to `/etc/sysctl.d/99-gaming.conf`:

```ini
vm.swappiness=10
vm.vfs_cache_pressure=50
vm.dirty_ratio=10
```

## Troubleshooting

### Check Performance

```bash
sanchala-gaming status
sanchala-gaming gpu
```

### Low FPS

1. Verify game mode is active
2. Check GPU driver: `vulkaninfo --summary`
3. Monitor with MangoHud

### Stuttering

```bash
# Enable async shader compilation
DXVK_ASYNC=1 %command%
```

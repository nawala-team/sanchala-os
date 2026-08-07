# Steam Integration Guide

## Installation

Steam is pre-installed. If needed:

```bash
sudo pacman -S steam steam-native-runtime
```

## First Launch Setup

1. Launch Steam and log in
2. Go to **Steam → Settings → Compatibility**
3. Enable **Steam Play for supported titles**
4. Enable **Steam Play for all other titles**
5. Select **Proton Experimental** as default

## Proton Versions

| Version | Use Case |
|---------|----------|
| Proton Experimental | Latest features |
| Proton 8.0 | Stable release |
| Proton-GE | Community patches, best compatibility |

### Install Proton-GE

```bash
sanchala-gaming proton-ge
# Or: protonup-qt
```

## Per-Game Settings

Right-click game → **Properties**

### Force Proton Version

1. **Compatibility** tab
2. Check **Force specific compatibility tool**
3. Select version

### Launch Options

```bash
# Performance overlay
MANGOHUD=1 %command%

# Game mode + FSR
gamemoderun WINE_FULLSCREEN_FSR=1 %command%

# NVIDIA DLSS
PROTON_ENABLE_NVAPI=1 PROTON_HIDE_NVIDIA_GPU=0 %command%

# Disable Proton logs
PROTON_LOG=0 %command%

# Skip launcher
STEAM_COMPAT_LAUNCH_SKIP_LAUNCHER=1 %command%
```

## Protontricks

```bash
# Install
sudo pacman -S protontricks

# List games
protontricks -l

# Configure game
protontricks <APPID>

# Install component
protontricks <APPID> vcrun2019
```

### Common Fixes

```bash
protontricks <APPID> vcrun2019      # Visual C++
protontricks <APPID> dotnet48       # .NET Framework
protontricks <APPID> d3dcompiler_47 # DirectX
protontricks <APPID> corefonts      # Fonts
```

## Troubleshooting

### Check ProtonDB

Visit [protondb.com](https://www.protondb.com) for compatibility reports.

### Enable Logging

```bash
PROTON_LOG=1 %command%
```

### Reset Prefix

```bash
rm -rf ~/.local/share/Steam/steamapps/compatdata/<APPID>
```

### Common Issues

**Black screen:** `PROTON_USE_WINED3D=1 %command%`

**Crashes:** `protontricks <APPID> vcrun2019 d3dcompiler_47`

**Stuttering:** `DXVK_ASYNC=1 %command%`

# Proton & Wine Guide

## Proton (Steam)

Proton is Valve's compatibility layer for running Windows games on Linux.

### Environment Variables

| Variable | Purpose |
|----------|---------|
| `PROTON_LOG=1` | Enable logging |
| `PROTON_USE_WINED3D=1` | Use OpenGL instead of Vulkan |
| `PROTON_NO_ESYNC=1` | Disable ESync |
| `PROTON_NO_FSYNC=1` | Disable FSync |
| `PROTON_ENABLE_NVAPI=1` | Enable NVIDIA API (DLSS) |
| `DXVK_ASYNC=1` | Async shader compilation |
| `WINE_FULLSCREEN_FSR=1` | Enable FSR |
| `WINE_FULLSCREEN_FSR_STRENGTH=2` | FSR sharpness (0-5) |

### Prefix Location

```
~/.local/share/Steam/steamapps/compatdata/<APPID>/pfx/
```

## Wine (Non-Steam Games)

### Create Wine Prefix

```bash
# 64-bit prefix
sanchala-gaming wine-prefix mygame win64

# 32-bit prefix
sanchala-gaming wine-prefix oldgame win32
```

### Manual Setup

```bash
export WINEPREFIX=~/.wine_prefixes/mygame
winetricks vcrun2019 dxvk d3dcompiler_47
wine setup.exe
wine game.exe
```

### DXVK (DirectX to Vulkan)

DXVK translates DirectX 9/10/11 to Vulkan for better performance:

```bash
# Install to prefix
winetricks dxvk
```

### VKD3D (DirectX 12)

```bash
winetricks vkd3d
```

## Lutris

Lutris manages Wine prefixes and provides install scripts:

```bash
# Install game
lutris lutris:install/game-slug

# List games
lutris -l

# Launch game
lutris lutris:rungame/game-slug
```

## Bottles

Modern Wine prefix manager with GUI:

```bash
flatpak install flathub com.usebottles.bottles
```

## Heroic Games Launcher

For Epic Games Store and GOG:

```bash
sudo pacman -S heroic-games-launcher-bin
```

## Common Wine Dependencies

```bash
winetricks vcrun2019    # Visual C++ 2019
winetricks vcrun2017    # Visual C++ 2017
winetricks dotnet48     # .NET Framework 4.8
winetricks d3dx9        # DirectX 9
winetricks d3dcompiler_47
winetricks corefonts    # Microsoft fonts
winetricks dxvk         # Vulkan translation
```

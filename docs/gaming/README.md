# Sanchala OS Gaming Guide

Sanchala OS delivers a SteamOS-level gaming experience on a traditional Linux desktop.

## Quick Start

```bash
# Enable game mode for optimal performance
sanchala-gaming start

# Check gaming status
sanchala-gaming status

# Launch a game with optimizations
sanchala-gaming launch /path/to/game

# Show GPU information
sanchala-gaming gpu
```

## Game Mode

Game Mode automatically optimizes your system for gaming:

- Sets CPU governor to performance
- Enables GPU high-performance mode
- Suspends desktop compositor (reduces latency)
- Pauses background indexers
- Inhibits screen saver

### Commands

```bash
sanchala-gaming start    # Activate game mode
sanchala-gaming stop     # Deactivate game mode
sanchala-gaming toggle   # Toggle on/off
sanchala-gaming status   # Show current status
```

## Steam & Proton

### Initial Setup

1. Launch Steam from the application menu
2. Go to **Settings → Compatibility**
3. Enable **Steam Play for all titles**
4. Select Proton version (Proton Experimental recommended)

### Proton-GE (Recommended)

```bash
sanchala-gaming proton-ge
```

### Launch Options

```bash
# Enable MangoHud overlay
MANGOHUD=1 %command%

# Enable FSR upscaling
WINE_FULLSCREEN_FSR=1 %command%

# Combined optimizations
gamemoderun MANGOHUD=1 WINE_FULLSCREEN_FSR=1 %command%
```

## Configuration Files

| File | Purpose |
|------|---------|
| `/etc/sanchala/gaming/gaming.conf` | Main gaming config |
| `/etc/sanchala/gaming/controllers.conf` | Controller settings |
| `/etc/sanchala/gaming/streaming.conf` | Streaming config |
| `/etc/gamemode.ini` | Feral GameMode config |

## Documentation

- [Steam Integration](STEAM.md)
- [Proton & Wine Guide](PROTON-WINE.md)
- [Controller Setup](CONTROLLERS.md)
- [Game Streaming](STREAMING.md)
- [Performance Tuning](PERFORMANCE.md)

# Emulation Guide

Sanchala OS supports retro gaming through RetroArch and standalone emulators.

## RetroArch (Recommended)

Unified interface for multiple emulators:

```bash
retroarch
```

### First-Time Setup

1. **Main Menu → Online Updater**
2. Update Core Info Files
3. Update Assets
4. Download cores you need

### Recommended Cores

| System | Core | Notes |
|--------|------|-------|
| NES | Nestopia | Accurate |
| SNES | Snes9x | Fast & compatible |
| Genesis | Genesis Plus GX | Accurate |
| PS1 | Beetle PSX HW | Hardware accelerated |
| N64 | Mupen64Plus-Next | Best compatibility |
| GBA | mGBA | Most accurate |
| DS | DeSmuME / melonDS | melonDS for accuracy |
| PSP | PPSSPP | Excellent |

### BIOS Files

Place BIOS files in: `~/.config/retroarch/system/`

Required BIOS:
- PS1: `scph5501.bin`
- PS2: Various (see PCSX2)
- Saturn: `saturn_bios.bin`

## Standalone Emulators

### PlayStation 2 - PCSX2

```bash
pcsx2-qt
```

BIOS required in: `~/.config/PCSX2/bios/`

### PlayStation 3 - RPCS3

```bash
rpcs3
```

Firmware required. Download from Sony website.

### GameCube/Wii - Dolphin

```bash
dolphin-emu
```

No BIOS needed. Configure paths for game ISOs.

### Nintendo Switch - Yuzu/Ryujinx

```bash
yuzu      # Faster
ryujinx   # More accurate
```

Requires `prod.keys` and firmware dump.

### PSP - PPSSPP

```bash
ppsspp
```

No BIOS needed. Excellent compatibility.

## Controller Mapping

RetroArch: **Settings → Input → Port 1 Controls**

Most emulators auto-detect controllers. Use Steam Input for complex mapping.

## Performance Tips

- Enable **Run Ahead** in RetroArch for reduced latency
- Use **Vulkan** video driver when available
- Enable **Threaded Video** for multi-core CPUs
- Set **Frame Delay** to reduce input lag

## Legal Note

Only use emulators with games you legally own. Dump your own BIOS files from consoles you own.

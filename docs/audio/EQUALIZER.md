# Equalizer Configuration

## System-Wide EQ

Sanchala OS includes a system-wide parametric equalizer using PipeWire's filter-chain module.

## Available Presets

| Preset | Description | Best For |
|--------|-------------|----------|
| `flat` | No processing | Reference, production |
| `speakers-balanced` | Balanced with bass boost | Laptop speakers |
| `headphones-flat` | Neutral response | Critical listening |
| `bass-boost` | Enhanced low-end | EDM, Hip-Hop |
| `vocal-clarity` | Speech enhancement | Podcasts, calls |
| `gaming` | Footsteps, positional | Competitive gaming |
| `movie` | Cinematic dynamics | Films, TV |
| `classical` | Warm, natural | Orchestra, acoustic |
| `rock` | Punchy, aggressive | Rock, metal |

## Using EQ

### Command Line
```bash
# List presets
sanchala-audio eq list

# Apply preset
sanchala-audio eq apply bass-boost

# Disable EQ
sanchala-audio eq off
```

### GUI (EasyEffects)
For advanced users, install EasyEffects:
```bash
sudo pacman -S easyeffects
```

## Preset Format

Presets stored in `/etc/sanchala/audio/eq-presets/`:

```ini
[Preset]
Name=Bass Boost
Description=Enhanced bass for electronic music
Category=Music

[Equalizer]
Enabled=true
Type=parametric
Bands=8

[Band.1]
Type=LowShelf
Frequency=60
Gain=5.0
Q=0.7

[Band.2]
Type=Peak
Frequency=150
Gain=3.0
Q=1.0
```

## Filter Types

| Type | Use |
|------|-----|
| `LowShelf` | Boost/cut below frequency |
| `HighShelf` | Boost/cut above frequency |
| `Peak` | Boost/cut at frequency (Q controls width) |
| `HighPass` | Remove frequencies below |
| `LowPass` | Remove frequencies above |

## Creating Custom Presets

1. Copy existing preset:
   ```bash
   cp /etc/sanchala/audio/eq-presets/flat.conf \
      ~/.config/sanchala/audio/eq-presets/custom.conf
   ```

2. Edit bands as needed

3. Apply:
   ```bash
   sanchala-audio eq apply custom
   ```

## Technical Implementation

EQ runs via PipeWire filter-chain:
```
/etc/pipewire/filter-chain.conf.d/50-sanchala-eq.conf
```

Uses built-in biquad filters for low CPU usage.

# Per-Application Volume Control

## Overview

Sanchala OS provides automatic per-application volume control through WirePlumber. Each application's volume and routing preferences are saved and restored.

## How It Works

1. **Stream Detection**: WirePlumber detects new audio streams
2. **Application Matching**: Matches stream to application rules
3. **State Restoration**: Restores saved volume/routing
4. **Role Assignment**: Assigns media role for policy

## Application Roles

| Role | Priority | Behavior | Examples |
|------|----------|----------|----------|
| Accessibility | 150 | Highest priority | Screen readers |
| Communication | 100 | Corks other audio | Discord, Zoom |
| Navigation | 75 | Ducks music | GPS apps |
| Notification | 50 | Brief duck | System sounds |
| Game | 50 | Normal mixing | Steam, games |
| Music | 25 | Can be ducked | Spotify, VLC |
| Movie | 25 | Can be ducked | Video players |

## Ducking Behavior

**Duck**: Lower volume of other streams (default: 30%)
**Cork**: Pause other streams entirely
**Mix**: Normal mixing, no interaction

### Example: Incoming Call

1. Discord starts voice stream (Communication role)
2. Spotify is playing (Music role)
3. Policy: Communication → cork Music
4. Result: Spotify pauses
5. Call ends → Spotify resumes

## Configuration

### Policy Rules Location
```
/etc/wireplumber/policy.lua.d/50-sanchala-policy.lua
```

### Adding Custom App Rules

```lua
-- Example: Set custom role for app
{
  matches = {
    { { "application.name", "equals", "my-app" } },
  },
  apply_properties = {
    ["media.role"] = "Game",
    ["stream.restore.volume"] = true,
  },
}
```

## Volume State Storage

Per-app volumes stored in:
```
~/.local/state/wireplumber/stream-restore/
```

## GUI Control

- **KDE Plasma**: System tray volume → Applications tab
- **pavucontrol**: Full per-stream control
- **CLI**: `wpctl set-volume <stream-id> <level>`

## Listing Active Streams

```bash
# Show all streams with volumes
wpctl status

# Detailed stream info
pw-cli ls Node | grep -A5 "media.class.*Stream"
```

# Sanchala Voice - Offline Voice Assistant

## Overview

**sanchala-voice** is the privacy-first voice system for Sanchala OS, providing Siri-like voice features while keeping all processing 100% local. No audio ever leaves your device.

## Architecture

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                        SANCHALA VOICE SYSTEM                                 │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐         │
│  │   Whisper   │  │    Piper    │  │   Voice     │  │  Dictation  │         │
│  │    STT      │  │    TTS      │  │  Commands   │  │   Engine    │         │
│  │  (faster)   │  │  (neural)   │  │  (actions)  │  │  (typing)   │         │
│  └──────┬──────┘  └──────┬──────┘  └──────┬──────┘  └──────┬──────┘         │
│         │                │                │                │                 │
│         └────────────────┴────────────────┴────────────────┘                 │
│                                   │                                          │
│                          ┌───────┴───────┐                                   │
│                          │  Voice Daemon │                                   │
│                          │   (D-Bus)     │                                   │
│                          └───────┬───────┘                                   │
│                                  │                                           │
│         ┌────────────────────────┼────────────────────────┐                  │
│         │                        │                        │                  │
│  ┌──────┴──────┐         ┌───────┴──────┐        ┌───────┴──────┐           │
│  │   Hotword   │         │  PipeWire    │        │  Sanchala    │           │
│  │  Detection  │         │   Audio      │        │     AI       │           │
│  │  "Hey San"  │         │   Stream     │        │  Integration │           │
│  └─────────────┘         └──────────────┘        └──────────────┘           │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

## Privacy Guarantee

🔒 **ALL VOICE PROCESSING IS 100% LOCAL**
- No cloud speech recognition
- No audio uploaded anywhere
- Models run entirely on your hardware
- Works completely offline after setup
- Audio is never stored unless you opt-in

## Features

| Feature | Description | Technology |
|---------|-------------|------------|
| Speech Recognition | Voice to text | Whisper (faster-whisper) |
| Text-to-Speech | Natural voice output | Piper (neural TTS) |
| Voice Commands | "Hey San" activation | Custom hotword |
| Dictation | Voice typing anywhere | Real-time STT |
| Accessibility | Screen reader support | espeak-ng fallback |
| Multi-language | 99+ languages | Whisper multilingual |

## Components

### 1. Speech Recognition (STT)
- **Primary:** faster-whisper (optimized Whisper)
- **Models:** tiny, base, small, medium (configurable)
- **Languages:** Auto-detect or specify
- **Latency:** ~200ms (tiny) to ~2s (medium)

### 2. Text-to-Speech (TTS)
- **Primary:** Piper (neural voices)
- **Fallback:** espeak-ng (lightweight)
- **Voices:** 20+ natural voices
- **Speed/Pitch:** Adjustable

### 3. Voice Commands
- Hotword: "Hey Sanchala" or "Hey San"
- System actions (open apps, settings)
- AI assistant queries
- Custom command macros

### 4. Dictation
- Real-time voice typing
- Works in any text field
- Punctuation commands
- Continuous mode

## Quick Start

```bash
# Install
sudo pacman -S sanchala-voice

# Download voice model (pick size)
sanchala-voice-setup --model small

# Test speech recognition
sanchala-voice listen

# Test text-to-speech
sanchala-voice speak "Hello from Sanchala OS"

# Start voice assistant
sanchala-voice assistant
```

## Voice Commands

| Command | Action |
|---------|--------|
| "Hey San, open Firefox" | Launch application |
| "Hey San, what time is it" | Speak current time |
| "Hey San, take a screenshot" | Capture screen |
| "Hey San, search for..." | Web search |
| "Hey San, ask AI..." | Query Sanchala AI |
| "Start dictation" | Enable voice typing |
| "Stop dictation" | Disable voice typing |

## D-Bus Interface

**Bus:** `id.sanchala.Voice`  
**Path:** `/id/sanchala/Voice`

### Methods
- `Listen() → string` - Recognize speech
- `Speak(text: string)` - Text to speech
- `StartDictation()` - Begin voice typing
- `StopDictation()` - End voice typing
- `SetVoice(voice: string)` - Change TTS voice
- `GetStatus() → dict` - System status

### Signals
- `SpeechRecognized(text: string)`
- `HotwordDetected()`
- `DictationText(text: string)`

## Configuration

`~/.config/sanchala-voice/config.json`:
```json
{
  "stt": {
    "engine": "whisper",
    "model": "small",
    "language": "auto",
    "device": "cpu"
  },
  "tts": {
    "engine": "piper",
    "voice": "en_US-amy-medium",
    "rate": 1.0,
    "pitch": 1.0
  },
  "hotword": {
    "enabled": true,
    "phrase": "hey san",
    "sensitivity": 0.5
  },
  "dictation": {
    "continuous": false,
    "punctuation": true,
    "auto_capitalize": true
  }
}
```

## Hardware Requirements

| Model | RAM | Speed | Quality |
|-------|-----|-------|---------|
| tiny | 1GB | ★★★★★ | ★★☆☆☆ |
| base | 1GB | ★★★★☆ | ★★★☆☆ |
| small | 2GB | ★★★☆☆ | ★★★★☆ |
| medium | 5GB | ★★☆☆☆ | ★★★★★ |

## Accessibility

Sanchala Voice integrates with accessibility tools:
- Screen reader support (Orca)
- Voice control for navigation
- Dictation for motor impairments
- Audio feedback options

---
**Part of SANCHALA OS** - "Set Your System in Motion"

# Sanchala AI - Privacy-First Local Intelligence

## Overview

**sanchala-ai** is the local AI assistant for Sanchala OS, providing Apple Intelligence-like features while keeping all processing on-device. No data ever leaves your computer.

## Architecture

```
┌─────────────────────────────────────────────────────────────────────┐
│                      SANCHALA AI SYSTEM                              │
├─────────────────────────────────────────────────────────────────────┤
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐               │
│  │   Assistant  │  │     OCR      │  │    Smart     │               │
│  │   (Ollama)   │  │  (Tesseract) │  │   Search     │               │
│  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘               │
│         └─────────────────┼─────────────────┘                        │
│                    ┌──────┴──────┐                                   │
│                    │  Sanchala   │                                   │
│                    │   AI Core   │                                   │
│                    │  (D-Bus)    │                                   │
│                    └─────────────┘                                   │
└─────────────────────────────────────────────────────────────────────┘
```

## Privacy Guarantee

🔒 **ALL AI PROCESSING IS 100% LOCAL**
- No cloud API calls
- No telemetry or data collection  
- Models run entirely on your hardware
- Offline-capable after initial model download

## Features

| Feature | Description | Technology |
|---------|-------------|------------|
| AI Assistant | Natural language chat | Ollama (llama3.2) |
| OCR Engine | Text extraction from images | Tesseract |
| Smart Search | Intelligent suggestions | Local ML |
| Image Intel | Classification & detection | Local models |

## Supported Models

| Model | Size | Use Case |
|-------|------|----------|
| llama3.2:1b | 1.3GB | Fast, low RAM |
| llama3.2:3b | 2.0GB | Balanced |
| mistral:7b | 4.1GB | High quality |
| codellama:7b | 4.1GB | Code help |

## Quick Start

```bash
# Install
sudo pacman -S sanchala-ai

# Download model
ollama pull llama3.2:3b

# Chat
sanchala-ai chat "How do I use Flatpak?"

# OCR
sanchala-ocr scan image.png
```

## D-Bus Interface

**Bus:** `id.sanchala.AI` | **Path:** `/id/sanchala/AI`

Methods: `Chat(prompt)`, `OCR(path)`, `Suggest(query)`

---
**Part of SANCHALA OS** - "Set Your System in Motion"

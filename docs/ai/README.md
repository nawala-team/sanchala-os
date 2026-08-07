# Sanchala AI Documentation

Welcome to Sanchala AI - the privacy-first local AI assistant for Sanchala OS.

## Overview

Sanchala AI provides Apple Intelligence-like features while keeping all processing 100% local. Your data never leaves your device.

## Features

| Feature | Description | Status |
|---------|-------------|--------|
| AI Chat | Natural language assistant | ✅ Ready |
| OCR | Text extraction from images | ✅ Ready |
| Smart Search | Intelligent suggestions | ✅ Ready |
| Image Intel | Classification & detection | 🚧 Planned |

## Quick Start

```bash
# Install
sudo pacman -S sanchala-ai

# Setup LLM
ollama pull llama3.2:3b

# Start chatting
sanchala-ai chat -i
```

## Documentation

- [User Guide](USER-GUIDE.md) - How to use Sanchala AI
- [Architecture](ARCHITECTURE.md) - Technical design
- [API Reference](API-REFERENCE.md) - Developer documentation

## Privacy Promise

🔒 **Your data stays on your device**

- No cloud API calls
- No telemetry
- No data collection
- Works offline

---

Part of [SANCHALA OS](../../README.md) - "Set Your System in Motion"

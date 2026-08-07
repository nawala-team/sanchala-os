# Sanchala AI - Technical Documentation

## Architecture Overview

Sanchala AI provides Apple Intelligence-like features while maintaining complete privacy through local-only processing.

```
┌─────────────────────────────────────────────────────────────────────┐
│                    SANCHALA AI ARCHITECTURE                          │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│   User Interface Layer                                               │
│   ┌─────────────┐ ┌─────────────┐ ┌─────────────┐                   │
│   │   CLI       │ │   Plasma    │ │   D-Bus     │                   │
│   │  sanchala-  │ │   Widget    │ │   Clients   │                   │
│   │    ai       │ │             │ │             │                   │
│   └──────┬──────┘ └──────┬──────┘ └──────┬──────┘                   │
│          │               │               │                           │
│          └───────────────┼───────────────┘                           │
│                          │                                           │
│   ┌──────────────────────┴──────────────────────┐                   │
│   │            sanchala-aid (Daemon)            │                   │
│   │  ┌──────────┐ ┌──────────┐ ┌──────────┐    │                   │
│   │  │ Ollama   │ │ Tesseract│ │  Smart   │    │                   │
│   │  │ Client   │ │   OCR    │ │ Suggest  │    │                   │
│   │  └────┬─────┘ └────┬─────┘ └────┬─────┘    │                   │
│   └───────┼────────────┼────────────┼──────────┘                   │
│           │            │            │                               │
│   ┌───────┴────┐ ┌─────┴─────┐ ┌────┴────┐                         │
│   │   Ollama   │ │ Tesseract │ │ SQLite  │                         │
│   │   Server   │ │  Engine   │ │   DB    │                         │
│   └────────────┘ └───────────┘ └─────────┘                         │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

## Components

### 1. sanchala-aid (Daemon)
Main service providing D-Bus interface for all AI features.

**D-Bus Interface:** `id.sanchala.AI`

| Method | Parameters | Returns | Description |
|--------|------------|---------|-------------|
| Chat | prompt: string | JSON response | Send message to LLM |
| OCR | path: string, lang?: string | JSON with text | Extract text from image |
| Suggest | query: string | JSON array | Get search suggestions |
| GetStatus | - | JSON status | System status |

### 2. Ollama Integration
Local LLM runtime providing chat capabilities.

**Supported Models:**
- llama3.2:1b - Fast, 1.3GB RAM
- llama3.2:3b - Balanced, 2GB RAM  
- mistral:7b - Quality, 4GB RAM
- codellama:7b - Code assistance

### 3. Tesseract OCR
Text extraction from images with multi-language support.

**Features:**
- 100+ language support
- Searchable PDF creation
- Configurable DPI and PSM

### 4. Smart Suggestions
Learning-based search assistance using local SQLite database.

## Privacy Model

```
┌─────────────────────────────────────────┐
│         PRIVACY GUARANTEES              │
├─────────────────────────────────────────┤
│ ✓ All AI models run locally             │
│ ✓ No network requests to AI services    │
│ ✓ Chat history stored locally only      │
│ ✓ OCR processing entirely offline       │
│ ✓ Suggestions based on local data       │
│ ✓ No telemetry or analytics             │
│ ✓ User can delete all data anytime      │
└─────────────────────────────────────────┘
```

## File Locations

| Path | Purpose |
|------|---------|
| `~/.config/sanchala-ai/config.json` | User configuration |
| `~/.local/share/sanchala-ai/history.db` | Chat history |
| `~/.local/share/sanchala-ai/suggestions.db` | Search patterns |
| `/usr/share/sanchala-ai/` | System resources |

## Integration Points

- **KDE Plasma:** Desktop widget for quick access
- **Dolphin:** Right-click OCR integration
- **KRunner:** AI-powered search suggestions
- **System Settings:** AI configuration panel

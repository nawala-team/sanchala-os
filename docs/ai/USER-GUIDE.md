# Sanchala AI - User Guide

## Getting Started

Sanchala AI is your local, privacy-respecting AI assistant. All processing happens on your device - nothing is sent to the cloud.

## Installation

```bash
# Install Sanchala AI
sudo pacman -S sanchala-ai

# Install Ollama (for chat features)
curl -fsSL https://ollama.com/install.sh | sh

# Download a model
ollama pull llama3.2:3b

# Enable the AI daemon
systemctl --user enable --now sanchala-aid
```

## Using the AI Chat

### Interactive Mode
```bash
sanchala-ai chat -i
```

This opens an interactive chat session:
```
Sanchala AI (llama3.2:3b) - type 'exit' to quit

🧑 You: What is Flatpak?
🤖 AI: Flatpak is a universal packaging system for Linux...

🧑 You: How do I install apps with it?
🤖 AI: You can install Flatpak apps using...
```

### Single Question
```bash
sanchala-ai chat "How do I update my system?"
```

## Using OCR

Extract text from images, screenshots, or scanned documents.

### Basic Usage
```bash
# Extract text and print to terminal
sanchala-ocr image.png

# Save to file
sanchala-ocr scan.jpg -o extracted.txt

# Use specific language
sanchala-ocr document.png -l ind  # Indonesian

# Create searchable PDF
sanchala-ocr scan.png --pdf output.pdf
```

### Supported Languages
```bash
sanchala-ocr --list-langs
```

Install additional languages:
```bash
sudo pacman -S tesseract-data-ind   # Indonesian
sudo pacman -S tesseract-data-jpn   # Japanese
```

## Smart Suggestions

Get intelligent search suggestions based on your history:

```bash
sanchala-suggest "doc"
  📜 documents
  📜 docker setup
  💡 documentation
```

## System Status

Check if AI services are running:

```bash
sanchala-ai status
```

Output:
```
Sanchala AI Status
==============================
Ollama:    ✓ llama3.2:3b
Tesseract: ✓
```

## Managing Models

```bash
# List installed models
sanchala-ai models

# Download a new model
sanchala-ai models --pull mistral:7b

# See recommended models
sanchala-ai-models recommend
```

## Privacy

Your privacy is guaranteed:
- All AI runs 100% locally
- No internet connection required after model download
- Chat history stored only on your device
- Delete all data: `rm -rf ~/.local/share/sanchala-ai`

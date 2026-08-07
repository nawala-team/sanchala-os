# Sanchala AI - API Reference

## D-Bus API

**Bus Name:** `id.sanchala.AI`  
**Object Path:** `/id/sanchala/AI`

### Methods

#### Chat(prompt: string) → string
Send a message to the AI assistant.

```python
import dbus
bus = dbus.SessionBus()
ai = bus.get_object('id.sanchala.AI', '/id/sanchala/AI')
iface = dbus.Interface(ai, 'id.sanchala.AI')

response = iface.Chat("What is Linux?")
# Returns JSON: {"response": "Linux is...", "model": "llama3.2:3b"}
```

#### OCR(path: string, lang: string) → string
Extract text from an image file.

```python
result = iface.OCR("/home/user/scan.png", "eng")
# Returns JSON: {"text": "Extracted text...", "language": "eng"}
```

#### Suggest(query: string) → string
Get search suggestions based on partial input.

```python
suggestions = iface.Suggest("doc")
# Returns JSON array: [{"text": "documents", "type": "history", "score": 1.0}]
```

#### GetStatus() → string
Get AI system status.

```python
status = iface.GetStatus()
# Returns JSON: {"ollama_available": true, "tesseract_available": true, ...}
```

### Signals

#### AIResponse(session_id: string, response: string)
Emitted when AI generates a response (for async operations).

#### OCRComplete(path: string, text: string)
Emitted when OCR processing completes.

## CLI Reference

### sanchala-ai

```
sanchala-ai [--json] <command> [options]

Commands:
  chat [prompt]     Chat with AI assistant
    -i, --interactive    Interactive mode
  
  ocr <image>       Extract text from image
    -l, --lang LANG      OCR language
    -o, --output FILE    Save to file
  
  status            Show AI system status
  
  models            Manage AI models
    --pull MODEL         Download a model

Options:
  --json            Output as JSON
```

### sanchala-ocr

```
sanchala-ocr <image> [options]

Options:
  -l, --lang LANG       OCR language (default: eng)
  -o, --output FILE     Save text to file
  --pdf FILE            Create searchable PDF
  --list-langs          List available languages
  --json                JSON output
```

### sanchala-suggest

```
sanchala-suggest <query> [options]

Options:
  -n, --limit N         Max suggestions (default: 10)
  --record QUERY        Record a search for learning
  --json                JSON output
```

## Python API

```python
from sanchala_aid import SanchalaAIDaemon, Config

# Initialize
daemon = SanchalaAIDaemon()

# Chat
result = daemon.chat("Hello!")
print(result)  # JSON string

# OCR
text = daemon.ocr_scan("/path/to/image.png", "eng")

# Suggestions
suggestions = daemon.suggest("doc")

# Status
status = daemon.get_status()
```

## Configuration

Config file: `~/.config/sanchala-ai/config.json`

```json
{
  "assistant": {
    "model": "llama3.2:3b",
    "context_length": 4096,
    "temperature": 0.7,
    "system_prompt": "You are Sanchala AI..."
  },
  "ocr": {
    "default_language": "eng",
    "dpi": 300,
    "psm": 3
  },
  "suggestions": {
    "enabled": true,
    "max_results": 10,
    "learning": true
  },
  "privacy": {
    "telemetry": false,
    "store_history": true,
    "history_days": 30
  }
}
```

## Error Handling

All methods return JSON with an `error` field on failure:

```json
{
  "error": "Ollama not available",
  "response": ""
}
```

Common errors:
- `Ollama not available` - Ollama service not running
- `Tesseract not available` - Tesseract not installed
- `File not found` - Image path invalid
- `Request timeout` - Operation took too long

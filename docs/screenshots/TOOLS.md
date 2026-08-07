# SANCHALA OS - Screenshot CLI Tools

## sanchala-share - Quick Share

Share screenshots to various destinations:

```bash
# Copy to clipboard (default)
sanchala-share screenshot.png

# Save to file with dialog
sanchala-share -f screenshot.png

# Upload to Imgur
sanchala-share -i screenshot.png

# Show destination picker
sanchala-share -d screenshot.png

# From clipboard
sanchala-share -i  # uploads clipboard image to Imgur
```

Options:
- `-c, --clipboard` - Copy to clipboard (default)
- `-f, --file` - Save to file
- `-i, --imgur` - Upload to Imgur
- `-e, --email` - Send via email
- `-p, --print` - Print screenshot
- `-d, --destination` - Show picker dialog

## sanchala-ocr - Text Extraction

Extract text from screenshots using Tesseract OCR:

```bash
# OCR from file
sanchala-ocr screenshot.png

# OCR and copy to clipboard
sanchala-ocr -c screenshot.png

# Capture region and OCR
sanchala-ocr -r -c

# OCR with different language
sanchala-ocr -l jpn japanese_text.png

# OCR with notification
sanchala-ocr -r -c -n
```

Supported languages:
- `eng` - English (default)
- `deu` - German
- `fra` - French
- `spa` - Spanish
- `jpn` - Japanese
- `chi_sim` - Simplified Chinese
- `kor` - Korean

## sanchala-record - Screen Recording

Record screen with wf-recorder (Wayland):

```bash
# Record full screen
sanchala-record

# Record selected region
sanchala-record -r

# Record with audio
sanchala-record -a

# Record region with audio at 30fps
sanchala-record -r -a -f 30

# Stop recording
sanchala-record --stop
```

Options:
- `-r, --region` - Record selected region
- `-w, --window` - Record active window
- `-s, --screen` - Record full screen
- `-a, --audio` - Include audio
- `-f, --fps` - Frame rate (default: 60)
- `-q, --quality` - Quality 1-10 (default: 8)
- `--stop` - Stop current recording

## sanchala-annotate - Quick Annotation

Open screenshots for annotation:

```bash
# Open in Spectacle (default)
sanchala-annotate screenshot.png

# Open in Krita (full editor)
sanchala-annotate -k screenshot.png

# Open in Gwenview
sanchala-annotate -g screenshot.png

# Annotate clipboard image
sanchala-annotate -c
```

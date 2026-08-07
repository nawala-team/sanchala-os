# 📄 Content Indexing Guide

## Overview

Sanchala OS indexes content inside documents for deep search capabilities. Find that email, report, or code snippet instantly.

---

## Supported Document Types

### Full Content Indexing

| Type | Extensions | Extractor |
|------|------------|----------|
| Plain Text | txt, log, cfg, ini, json, xml, csv | Internal |
| Markdown | md, rst, adoc | Internal |
| Source Code | py, js, ts, java, c, cpp, rs, go, rb, php, sh | Internal |
| PDF | pdf | Poppler |
| Office | doc, docx, odt, xls, xlsx, ppt, pptx | LibreOffice |
| Ebooks | epub, mobi, fb2 | ebook-tools |
| Rich Text | rtf | Internal |

### Metadata Only

| Type | Extensions | Indexed Fields |
|------|------------|---------------|
| Images | jpg, png, gif, webp, heic, raw | EXIF (date, location, camera) |
| Audio | mp3, flac, ogg, m4a | ID3 (title, artist, album) |
| Video | mp4, mkv, webm, avi | Codec, duration, resolution |

---

## Search Syntax

### Basic Content Search
```
budget 2024              # Finds files containing "budget" and "2024"
"quarterly report"       # Exact phrase match
project AND deadline     # Boolean AND
meeting OR conference    # Boolean OR
report NOT draft         # Exclude term
```

### Field-Specific Search
```
filename:report          # Search file names only
content:confidential     # Search content only
ext:pdf                  # Filter by extension
path:Documents           # Filter by path
modified:today           # Modified today
modified:thisweek        # Modified this week
size:>1MB                # Larger than 1MB
```

### Combined Queries
```
filename:invoice ext:pdf content:2024
path:Projects content:"api key" modified:thismonth
```

---

## Performance Tuning

### Limit File Size
```ini
# ~/.config/baloofilerc
[ContentIndexing]
maxFileSize=10485760     # 10MB limit
```

### Reduce Index Scope
```ini
# Index only specific folders
[General]
folders[$e]=$HOME/Documents,$HOME/Projects
```

### Disable for Battery
```ini
[Performance]
indexOnBattery=false
```

---

## Excluding Content

### By Directory
```ini
[General]
exclude folders[$e]=$HOME/Downloads,$HOME/Videos
```

### By File Pattern
```ini
exclude filters=*.log,*.tmp,*.cache
```

### Using .noindex
```bash
# Create marker to skip folder
touch ~/SensitiveData/.noindex
```

---

## Troubleshooting

### Content Not Searchable

1. **Check if file type is supported**
   ```bash
   balooctl6 config
   ```

2. **Verify file size limit**
   - Default: 15MB max
   - Large PDFs may be skipped

3. **Check extractor availability**
   ```bash
   which pdftotext    # For PDFs
   which soffice      # For Office docs
   ```

### Rebuild Content Index
```bash
balooctl6 disable
rm -rf ~/.local/share/baloo
balooctl6 enable
# Wait for reindexing
balooctl6 monitor
```

---

## Privacy Considerations

- Content index stored locally at `~/.local/share/baloo`
- No cloud sync or network transmission
- Sensitive folders excluded by default
- Optional index encryption available
- Respect file permissions

---

*Content search makes your files instantly accessible.*

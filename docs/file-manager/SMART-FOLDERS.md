# Smart Folders Guide

Smart folders are virtual folders that show files matching specific criteria, powered by Baloo file indexing.

## Built-in Smart Folders

### Time-Based
| Folder | Shows |
|--------|-------|
| Today | Files modified today |
| Yesterday | Files from yesterday |
| This Month | Files from current month |

### Type-Based
| Folder | Shows |
|--------|-------|
| All Images | JPEG, PNG, GIF, WebP, SVG, etc. |
| All Videos | MP4, MKV, WebM, AVI, MOV |
| All Audio | MP3, FLAC, OGG, WAV |
| All Documents | PDF, DOC, ODT, TXT |

### Tag-Based
| Folder | Shows |
|--------|-------|
| All Tags | Browse all tags |
| Important | Files tagged "Important" |
| Work | Files tagged "Work" |
| Personal | Files tagged "Personal" |

## Creating Custom Smart Folders

### Method 1: Save Search
1. Press `Ctrl+F` in Dolphin
2. Enter search criteria
3. Click "Save" button
4. Choose name and location in sidebar

### Method 2: Edit Places File
Edit `~/.local/share/user-places.xbel`:

```xml
<bookmark href="baloosearch://?query=SEARCH_QUERY">
  <title>Folder Name</title>
  <info>
    <metadata owner="http://freedesktop.org">
      <bookmark:icon name="icon-name"/>
    </metadata>
  </info>
</bookmark>
```

## Search Query Syntax

### Basic Search
```
report                    # Filename contains "report"
"quarterly report"        # Exact phrase
```

### By File Type
```
type:document            # Documents
type:image               # Images
type:video               # Videos
type:audio               # Audio files
type:archive             # Archives
type:folder              # Folders only
```

### By Date
```
modified:today           # Modified today
modified:yesterday       # Modified yesterday
modified:thisweek        # This week
modified:thismonth       # This month
modified:thisyear        # This year
modified>=2024-01-01     # Since date
modified<=2024-06-30     # Before date
```

### By Size
```
size:small               # < 100KB
size:medium              # 100KB - 1MB
size:large               # > 1MB
size>=10M                # >= 10 MB
size<=100K               # <= 100 KB
```

### By Tag
```
tag:Important            # Tagged "Important"
tag:Work                 # Tagged "Work"
tags:Important,Work      # Multiple tags (OR)
```

### By Rating
```
rating>=4                # 4+ stars
rating:5                 # Exactly 5 stars
```

### Combining Queries
```
type:document modified:thisweek
type:image size:large
filename:*.pdf modified>=2024-01-01
```

## Useful Smart Folder Examples

### Large Files (>100MB)
```
baloosearch://?query=size>=100M
```

### Recent Downloads
```
baloosearch://?query=modified:thisweek&path=$HOME/Downloads
```

### Work Documents This Month
```
baloosearch://?query=tag:Work type:document modified:thismonth
```

### All Screenshots
```
baloosearch://?query=filename:Screenshot* type:image
```

### Untagged Files
```
baloosearch://?query=type:document -tag:*
```

## Troubleshooting

### Smart folders are empty
```bash
# Check if Baloo is running
balooctl status

# Enable indexing
balooctl enable

# Start initial index
balooctl check
```

### Files not appearing in searches
```bash
# Force reindex specific folder
balooctl index /path/to/folder

# Monitor indexing progress
balooctl monitor
```

### Disable content indexing (privacy)
Edit `~/.config/baloofilerc`:
```ini
[General]
only basic indexing=true
```
This indexes filenames only, not file contents.

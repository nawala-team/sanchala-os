# ⚙️ Search Configuration Guide

## Configuration Files Overview

| File | Purpose |
|------|--------|
| `~/.config/baloofilerc` | File indexing (Baloo) |
| `~/.config/krunnerrc` | Search runner (KRunner) |
| `~/.config/sanchala/search.conf` | Unified search settings |
| `~/.config/sanchala/content-search.conf` | Document content indexing |
| `~/.config/sanchala/calculator.conf` | Calculator & conversions |

---

## Baloo Configuration

### Enable/Disable Indexing
```ini
# ~/.config/baloofilerc
[Basic Settings]
Indexing-Enabled=true      # Master switch

[General]
only basic indexing=false  # false = content indexing
index hidden folders=false # Skip hidden dirs
```

### Control What Gets Indexed
```ini
[General]
# Exclude directories (comma-separated)
exclude folders[$e]=$HOME/.cache,$HOME/.local/share/Trash,/tmp

# Exclude file patterns
exclude filters=*.o,*.pyc,*.log,node_modules,.git
```

### Content Indexing
```ini
[ContentIndexing]
enabled=true
indexText=true
maxFileSize=15728640       # 15MB
indexPDF=true
indexOfficeDocuments=true
indexSourceCode=true
```

### Performance Settings
```ini
[Performance]
indexOnBattery=false       # Save battery
lowPriority=true           # Don't slow system
memoryLimit=256            # MB
indexDuringIdle=true       # Index when idle
idleTimeSeconds=120        # Idle threshold
```

---

## KRunner Configuration

### Appearance
```ini
# ~/.config/krunnerrc
[General]
FreeFloating=true          # Centered overlay
ActivateWhenTypingOnDesktop=true
RetainPriorSearch=false    # Clear on close
```

### Enable/Disable Plugins
```ini
[Plugins]
applicationsEnabled=true   # App launcher
baloosearchEnabled=true    # File search
calculatorEnabled=true     # Math
unitconverterEnabled=true  # Conversions
webshortcutsEnabled=true   # Web searches
shellEnabled=true          # Commands
PowerDevilEnabled=true     # Power actions
windowsEnabled=true        # Window search

# Disable for privacy
plasma-runnerwikipediaEnabled=false
browserhistoryEnabled=false
```

### Search History
```ini
[History]
EnableHistory=true
MaxEntries=100
ClearOnLogout=false
```

---

## Sanchala Search Configuration

### Category Weights
```ini
# ~/.config/sanchala/search.conf
[Categories][Applications]
Enabled=true
Weight=100                 # Highest priority
MaxResults=8

[Categories][Files]
Enabled=true
Weight=90
MaxResults=10
SearchContent=true

[Categories][Calculator]
Enabled=true
Weight=95                  # High for instant calc
```

### Privacy Settings
```ini
[Privacy]
EnableHistory=true
HistorySize=100
ClearHistoryOnLogout=false
AllowNetworkSearch=false   # No online searches
AllowSearchSuggestions=false

ExcludedPaths=$HOME/.gnupg,$HOME/.ssh
```

### Performance
```ini
[Performance]
EnableCache=true
CacheTimeout=300           # 5 minutes
MaxMemoryMB=256
MaxCPUPercent=25
```

---

## Calculator Configuration

### Basic Settings
```ini
# ~/.config/sanchala/calculator.conf
[General]
Enabled=true
TriggerPrefix==            # Use = for calc
CopyOnEnter=true

[Display]
DecimalPrecision=10
UseThousandsSeparator=true
```

### Features Toggle
```ini
[Features]
BasicArithmetic=true
Functions=true             # sin, cos, sqrt, etc.
Constants=true             # pi, e, phi
BaseConversion=true        # hex, binary
BitwiseOperations=true
Percentage=true
```

### Unit Conversion
```ini
[UnitConversion]
Enabled=true

[UnitConversion][Length]
Enabled=true
Units=km,m,cm,mm,mi,yd,ft,in

[UnitConversion][Temperature]
Enabled=true
Units=C,F,K
```

---

## Web Shortcuts

### Add Custom Shortcut
```ini
# ~/.config/kuaborashortcutsrc
[Shortcuts]
mysite=https://mysite.com/search?q=\\{@}
mysite_Name=My Site
mysite_Keys=my,ms
```

### Change Default Search
```ini
[General]
DefaultSearchEngine=ddg    # DuckDuckGo
# Options: ddg, gg, wp, etc.
```

---

## Command Line Tools

### Baloo Management
```bash
# Status
balooctl6 status
balooctl6 monitor

# Configuration
balooctl6 config
balooctl6 config add excludeFolders /path

# Index management
balooctl6 enable
balooctl6 disable
balooctl6 purge
balooctl6 check
```

### Search Testing
```bash
# Search from terminal
baloosearch6 "query"
baloosearch6 -l 20 "query"  # Limit results

# File info
balooshow6 /path/to/file
```

---

## Best Practices

1. **Exclude large directories** - node_modules, .git, build folders
2. **Set reasonable file size limits** - 10-15MB for content
3. **Disable battery indexing** - Save power on laptops
4. **Use idle-time indexing** - Don't slow active work
5. **Exclude sensitive data** - .gnupg, .ssh, password stores
6. **Periodic maintenance** - Check index health monthly

---

*Fine-tune search for your workflow.*

# 🌐 SANCHALA OS - Localization Framework Specification

## 1. Overview

This document defines the internationalization (i18n) and localization (l10n) framework for Sanchala OS, enabling support for 50+ languages across all system components.

---

## 2. Core Components

### 2.1 Locale System

```
/etc/locale.conf          # System-wide defaults
/etc/locale.gen           # Available locales to generate
~/.config/locale.conf     # User overrides
```

**Locale Format:** `language_TERRITORY.ENCODING@modifier`
- Example: `de_DE.UTF-8@euro`

### 2.2 Locale Categories

| Category | Purpose | Example |
|----------|---------|---------|
| LC_CTYPE | Character classification | UTF-8 handling |
| LC_NUMERIC | Number formatting | 1,234.56 vs 1.234,56 |
| LC_TIME | Date/time formats | MM/DD/YYYY vs DD.MM.YYYY |
| LC_COLLATE | String sorting | ä after a or after z |
| LC_MONETARY | Currency formatting | $1,234 vs 1.234 € |
| LC_MESSAGES | UI translations | Error messages |
| LC_PAPER | Paper size | Letter vs A4 |
| LC_NAME | Name formatting | First Last vs Last, First |
| LC_ADDRESS | Address formats | Country-specific |
| LC_TELEPHONE | Phone formats | +1 (555) vs +49 555 |
| LC_MEASUREMENT | Units | Metric vs Imperial |

---

## 3. Translation Infrastructure

### 3.1 Message Catalogs

**GNU gettext** for system tools:
```
/usr/share/locale/{lang}/LC_MESSAGES/*.mo
```

**Qt/KDE translations**:
```
/usr/share/locale/{lang}/LC_MESSAGES/*.qm
/usr/share/locale/{lang}/kf5_*.qm
```

### 3.2 Translation File Formats

| Format | Use Case | Tools |
|--------|----------|-------|
| PO/MO | GNU gettext apps | msgfmt, msginit |
| QM | Qt applications | lrelease |
| TS | Qt source files | lupdate |
| XLIFF | Exchange format | Various |
| JSON | Web/Electron apps | Custom |

### 3.3 String Extraction

```bash
# Extract from C/C++ sources
xgettext -k_ -kN_ -ktr -o messages.pot src/*.cpp

# Extract from Qt sources  
lupdate src/*.cpp -ts translations/app_en.ts

# Extract from shell scripts
bash --dump-po-strings script.sh >> messages.pot
```

---

## 4. Sanchala-Specific Components

### 4.1 Translatable Components

| Component | Format | Location |
|-----------|--------|----------|
| sanchala-welcome | PO | /usr/share/locale/*/LC_MESSAGES/sanchala-welcome.mo |
| sanchala-settings | QM | /usr/share/sanchala/translations/ |
| sanchala-installer | PO | /usr/share/calamares/lang/ |
| sanchala-tcc | PO | /usr/share/locale/*/LC_MESSAGES/sanchala-tcc.mo |
| Desktop entries | Desktop | /usr/share/applications/*.desktop |
| Notifications | JSON | /usr/share/sanchala/notifications/i18n/ |

### 4.2 Desktop Entry Localization

```ini
[Desktop Entry]
Name=Sanchala Welcome
Name[de]=Sanchala Willkommen
Name[id]=Selamat Datang Sanchala
Name[ja]=Sanchala へようこそ
Name[ar]=مرحباً بك في سانشالا
Comment=Welcome to Sanchala OS
Comment[de]=Willkommen bei Sanchala OS
Comment[id]=Selamat datang di Sanchala OS
```

---

## 5. API Specifications

### 5.1 Qt/KDE (KLocalizedString)

```cpp
#include <KLocalizedString>

// Simple string
QString msg = i18n("Welcome to Sanchala OS");

// With arguments
QString msg = i18n("Hello, %1!", userName);

// Plural forms
QString msg = i18np("1 file selected", "%1 files selected", count);

// With context (for translators)
QString msg = i18nc("@action:button", "Apply");

// Domain-specific
QString msg = ki18nd("sanchala-welcome", "Next").toString();
```

### 5.2 GTK/GLib

```c
#include <glib/gi18n.h>

// Initialize
bindtextdomain("sanchala-app", "/usr/share/locale");
textdomain("sanchala-app");

// Simple string
const char *msg = _("Welcome to Sanchala OS");

// Plural
const char *msg = ngettext("1 file", "%d files", count);

// Context
const char *msg = C_("button", "Apply");
```

### 5.3 Python

```python
import gettext

# Setup
gettext.bindtextdomain('sanchala-app', '/usr/share/locale')
gettext.textdomain('sanchala-app')
_ = gettext.gettext
ngettext = gettext.ngettext

# Usage
msg = _("Welcome to Sanchala OS")
msg = ngettext("1 file", "{} files", count).format(count)
```

### 5.4 Shell Scripts

```bash
#!/bin/bash
export TEXTDOMAIN="sanchala-scripts"
export TEXTDOMAINDIR="/usr/share/locale"

# Using $"..." syntax
echo $"Welcome to Sanchala OS"

# Using gettext command
echo "$(gettext 'Installation complete')"

# With variables (use eval carefully)
filename="test.txt"
eval_gettext 'File $filename saved successfully'
```

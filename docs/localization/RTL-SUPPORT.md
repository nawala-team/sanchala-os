# ↔️ SANCHALA OS - RTL Language Support

## 1. Overview

Sanchala OS provides comprehensive Right-to-Left (RTL) language support for Arabic, Hebrew, Persian, Urdu, and other RTL scripts. This document covers configuration and implementation details.

---

## 2. Supported RTL Languages

| Language | Code | Script | Status |
|----------|------|--------|--------|
| Arabic | ar_SA, ar_EG | Arabic | ✅ Full |
| Hebrew | he_IL | Hebrew | ✅ Full |
| Persian/Farsi | fa_IR | Arabic | ✅ Full |
| Urdu | ur_PK | Arabic | ✅ Full |
| Pashto | ps_AF | Arabic | ✅ Full |
| Kurdish (Sorani) | ckb_IQ | Arabic | ✅ Full |
| Yiddish | yi_IL | Hebrew | ⏳ Planned |
| Dhivehi | dv_MV | Thaana | ⏳ Planned |

---

## 3. System Configuration

### 3.1 Plasma Desktop RTL

```ini
# ~/.config/kdeglobals
[General]
LayoutDirection=RTL

[Locale]
Language=ar_SA
```

### 3.2 Qt RTL Environment

```bash
# /etc/environment.d/50-rtl.conf (for RTL locales)
QT_LAYOUT_DIRECTION=RightToLeft
```

### 3.3 GTK RTL Support

```css
/* ~/.config/gtk-3.0/gtk.css */
* {
    direction: rtl;
}
```

---

## 4. Font Configuration

### 4.1 Arabic Font Stack

```xml
<!-- /etc/fonts/conf.d/65-sanchala-arabic.conf -->
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>
  <match>
    <test name="lang" compare="contains">
      <string>ar</string>
    </test>
    <edit name="family" mode="prepend">
      <string>Noto Naskh Arabic</string>
      <string>Noto Sans Arabic</string>
      <string>Amiri</string>
    </edit>
  </match>
</fontconfig>
```

### 4.2 Hebrew Font Stack

```xml
<!-- /etc/fonts/conf.d/65-sanchala-hebrew.conf -->
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>
  <match>
    <test name="lang" compare="contains">
      <string>he</string>
    </test>
    <edit name="family" mode="prepend">
      <string>Noto Sans Hebrew</string>
      <string>Noto Serif Hebrew</string>
    </edit>
  </match>
</fontconfig>
```

---

## 5. Application Guidelines

### 5.1 Qt/QML RTL

```qml
// Automatic mirroring
LayoutMirroring.enabled: Qt.application.layoutDirection === Qt.RightToLeft
LayoutMirroring.childrenInherit: true

// Manual control for specific items
Row {
    layoutDirection: Qt.RightToLeft
    // Items flow right-to-left
}
```

### 5.2 CSS RTL

```css
/* Use logical properties */
.sidebar {
    margin-inline-start: 1rem;  /* Replaces margin-left */
    padding-inline-end: 0.5rem; /* Replaces padding-right */
}

/* Direction-aware */
[dir="rtl"] .icon-arrow {
    transform: scaleX(-1);
}
```

### 5.3 Bidirectional Text

```cpp
// Handle mixed LTR/RTL content
QString text = "Welcome مرحبا";
// Use Unicode control characters if needed:
// LRE (U+202A), RLE (U+202B), PDF (U+202C)
```

---

## 6. Testing RTL

```bash
# Force RTL mode regardless of locale
QT_LAYOUT_DIRECTION=RightToLeft sanchala-settings

# Test specific RTL locale
LANG=ar_SA.UTF-8 sanchala-welcome

# Verify bidirectional rendering
echo -e "English \u202Bעברית\u202C back to English"
```

---

## 7. Common Issues

| Issue | Solution |
|-------|----------|
| Icons not mirroring | Add to exceptions list or use scaleX(-1) |
| Numbers displaying RTL | Use unicode-bidi: embed |
| Text alignment wrong | Use text-align: start/end not left/right |
| Scrollbars on wrong side | Automatic in Qt, check GTK settings |

---

**Document Version:** 1.0 | **Last Updated:** August 2026

# 🔤 SANCHALA OS - Font Packages for All Scripts

## 1. Overview

Sanchala OS includes comprehensive font support for all major world scripts, ensuring proper text rendering for 50+ languages.

---

## 2. Core Font Packages

### 2.1 Base Fonts (Always Installed)

```bash
# /iso/packages/fonts.list
noto-fonts                # Latin, Cyrillic, Greek
noto-fonts-cjk            # Chinese, Japanese, Korean
noto-fonts-emoji          # Emoji support
ttf-dejavu                # DejaVu family
ttf-liberation            # Liberation family (MS compat)
ttf-jetbrains-mono        # Monospace (coding)
inter-font                # UI font
```

### 2.2 Extended Script Fonts

```bash
# Additional script support
noto-fonts-extra          # Extended Latin, symbols
ttf-noto-naskh-arabic     # Arabic script
ttf-noto-hebrew           # Hebrew script
ttf-noto-devanagari       # Hindi, Sanskrit, Marathi
ttf-noto-bengali          # Bengali, Assamese
ttf-noto-tamil            # Tamil
ttf-noto-telugu           # Telugu
ttf-noto-kannada          # Kannada
ttf-noto-malayalam        # Malayalam
ttf-noto-thai             # Thai
ttf-noto-armenian         # Armenian
ttf-noto-georgian         # Georgian
ttf-noto-ethiopic         # Amharic, Tigrinya
ttf-noto-myanmar          # Burmese
ttf-noto-khmer            # Khmer
ttf-noto-lao              # Lao
ttf-noto-sinhala          # Sinhala
ttf-noto-tibetan          # Tibetan
```

---

## 3. Font Coverage by Script

| Script | Package | Languages | Glyphs |
|--------|---------|-----------|--------|
| Latin Extended | noto-fonts | 200+ | 3000+ |
| CJK | noto-fonts-cjk | CN/JP/KR/TW | 65000+ |
| Arabic | noto-naskh-arabic | AR/FA/UR | 1500+ |
| Devanagari | noto-devanagari | HI/MR/NE | 800+ |
| Cyrillic | noto-fonts | RU/UK/BG | 500+ |
| Greek | noto-fonts | EL | 400+ |
| Hebrew | noto-hebrew | HE/YI | 350+ |
| Thai | noto-thai | TH | 300+ |
| Bengali | noto-bengali | BN/AS | 600+ |

---

## 4. Fontconfig Configuration

### 4.1 Default Font Preferences

```xml
<!-- /etc/fonts/conf.d/60-sanchala-defaults.conf -->
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>
  <!-- Default sans-serif -->
  <alias>
    <family>sans-serif</family>
    <prefer>
      <family>Inter</family>
      <family>Noto Sans</family>
      <family>Noto Sans CJK SC</family>
      <family>Noto Sans Arabic</family>
      <family>Noto Sans Hebrew</family>
      <family>Noto Sans Devanagari</family>
    </prefer>
  </alias>

  <!-- Default monospace -->
  <alias>
    <family>monospace</family>
    <prefer>
      <family>JetBrains Mono</family>
      <family>Noto Sans Mono</family>
      <family>Noto Sans Mono CJK SC</family>
    </prefer>
  </alias>
</fontconfig>
```

### 4.2 CJK Language Priority

```xml
<!-- /etc/fonts/conf.d/64-sanchala-cjk.conf -->
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>
  <!-- Japanese preference -->
  <match>
    <test name="lang" compare="contains"><string>ja</string></test>
    <edit name="family" mode="prepend">
      <string>Noto Sans CJK JP</string>
    </edit>
  </match>
  
  <!-- Korean preference -->
  <match>
    <test name="lang" compare="contains"><string>ko</string></test>
    <edit name="family" mode="prepend">
      <string>Noto Sans CJK KR</string>
    </edit>
  </match>
  
  <!-- Simplified Chinese preference -->
  <match>
    <test name="lang" compare="contains"><string>zh-CN</string></test>
    <edit name="family" mode="prepend">
      <string>Noto Sans CJK SC</string>
    </edit>
  </match>
  
  <!-- Traditional Chinese preference -->
  <match>
    <test name="lang" compare="contains"><string>zh-TW</string></test>
    <edit name="family" mode="prepend">
      <string>Noto Sans CJK TC</string>
    </edit>
  </match>
</fontconfig>
```

---

## 5. Font Rendering Settings

```xml
<!-- /etc/fonts/conf.d/10-sanchala-rendering.conf -->
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>
  <!-- Enable antialiasing -->
  <match target="font">
    <edit name="antialias" mode="assign"><bool>true</bool></edit>
    <edit name="hinting" mode="assign"><bool>true</bool></edit>
    <edit name="hintstyle" mode="assign"><const>hintslight</const></edit>
    <edit name="rgba" mode="assign"><const>rgb</const></edit>
    <edit name="lcdfilter" mode="assign"><const>lcddefault</const></edit>
  </match>
</fontconfig>
```

---

## 6. Installation Commands

```bash
# Install all font packages
sudo pacman -S noto-fonts noto-fonts-cjk noto-fonts-emoji \
    noto-fonts-extra ttf-dejavu ttf-liberation ttf-jetbrains-mono

# Rebuild font cache
fc-cache -fv

# Verify font availability
fc-list :lang=ar   # Arabic fonts
fc-list :lang=ja   # Japanese fonts
fc-list :lang=hi   # Hindi fonts
```

---

**Document Version:** 1.0 | **Last Updated:** August 2026

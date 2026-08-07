# 🌏 SANCHALA OS - Input Method (IME) Setup

## Overview

Sanchala OS uses **Fcitx5** for input method support, enabling typing in:
- 🇨🇳 Chinese (Simplified & Traditional)
- 🇯🇵 Japanese
- 🇰🇷 Korean
- 🇻🇳 Vietnamese
- And 50+ other languages

---

## Quick Start

### Installing Language Support

```bash
# Chinese (Simplified) - Pinyin
sudo pacman -S fcitx5-chinese-addons

# Chinese (Traditional) - Chewing/Zhuyin
sudo pacman -S fcitx5-chewing

# Japanese - Mozc
sudo pacman -S fcitx5-mozc

# Korean - Hangul
sudo pacman -S fcitx5-hangul

# Vietnamese - Unikey
sudo pacman -S fcitx5-unikey
```

### Activating IME

1. Log out and log back in (environment variables need reload)
2. The fcitx5 tray icon appears in system tray
3. Press `Ctrl+Space` to toggle input method

---

## Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| `Ctrl+Space` | Toggle IME on/off |
| `Shift` (left) | Quick toggle to English |
| `Ctrl+Shift` | Cycle input methods |
| `Tab` | Next candidate |
| `Shift+Tab` | Previous candidate |
| `Page Up/Down` | Candidate pages |
| `Ctrl+;` | Clipboard history |

---

## Configuration

### GUI Configuration

```bash
fcitx5-configtool
```

### Adding Input Methods

1. Open `fcitx5-configtool`
2. Click "Add Input Method"
3. Uncheck "Only Show Current Language"
4. Search and add your language (e.g., "Pinyin", "Mozc", "Hangul")
5. Drag to reorder priority

### Configuration Files

| File | Purpose |
|------|---------|
| `~/.config/fcitx5/profile` | Active input methods |
| `~/.config/fcitx5/config` | Hotkeys and behavior |
| `~/.config/fcitx5/conf/classicui.conf` | Appearance |
| `~/.config/fcitx5/conf/pinyin.conf` | Pinyin settings |

---

## Language-Specific Tips

### Chinese (Pinyin)

- Type pinyin, press Space to commit
- Use `'` to separate syllables: `xi'an` → 西安
- Press number keys to select candidates
- Cloud input enabled for rare words

**Fuzzy Pinyin:** Enabled for common confusions:
- `z/zh`, `c/ch`, `s/sh`
- `n/l`, `f/h`

### Japanese (Mozc)

- Type romaji, converts to hiragana automatically
- Press Space for kanji conversion
- `F6` = hiragana, `F7` = katakana, `F8` = half-width

### Korean (Hangul)

- Type romanized Korean
- Automatic Jamo composition
- `Shift+Space` for half-width characters

---

## Troubleshooting

### IME Not Working

1. Check environment variables:
```bash
echo $GTK_IM_MODULE   # Should be: fcitx
echo $QT_IM_MODULE    # Should be: fcitx
```

2. Restart fcitx5:
```bash
fcitx5 -r
```

3. Check if daemon is running:
```bash
pgrep fcitx5
```

### IME Not Working in Specific App

Some apps need environment variables set before launch:
```bash
GTK_IM_MODULE=fcitx QT_IM_MODULE=fcitx application-name
```

### Wayland-Specific Issues

Fcitx5 uses the Wayland input-method protocol. If issues occur:
```bash
# Check fcitx5 wayland support
fcitx5-diagnose | grep -i wayland
```

---

## CJK Fonts

For proper display, install CJK fonts:

```bash
# Noto CJK (recommended)
sudo pacman -S noto-fonts-cjk

# Source Han fonts (Adobe)
sudo pacman -S adobe-source-han-sans-otc-fonts

# Individual language fonts
sudo pacman -S noto-fonts-cjk-sc  # Simplified Chinese
sudo pacman -S noto-fonts-cjk-jp  # Japanese
sudo pacman -S noto-fonts-cjk-kr  # Korean
```

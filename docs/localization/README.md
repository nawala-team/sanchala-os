# 🌍 SANCHALA OS - Localization Documentation

## Overview

Sanchala OS is designed to be a truly global operating system, supporting 50+ languages with comprehensive internationalization (i18n) and localization (l10n) infrastructure.

---

## 📚 Documentation Index

| Document | Description |
|----------|-------------|
| [LOCALIZATION-FRAMEWORK.md](LOCALIZATION-FRAMEWORK.md) | Core i18n/l10n architecture |
| [TRANSLATION-WORKFLOW.md](TRANSLATION-WORKFLOW.md) | Guide for translators |
| [RTL-SUPPORT.md](RTL-SUPPORT.md) | Right-to-Left language support |
| [FONT-PACKAGES.md](FONT-PACKAGES.md) | Font packages for all scripts |
| [LOCALE-DEFAULTS.md](LOCALE-DEFAULTS.md) | Default locale configurations |

---

## 🎯 Localization Goals

### Phase 1: Core Languages (Launch)
- English (US, UK, AU), Indonesian
- Spanish, French, German, Italian, Portuguese
- Japanese, Korean, Chinese (Simplified/Traditional)
- Arabic (RTL), Russian, Polish, Dutch, Turkish
- Hindi, Thai, Vietnamese

### Phase 2: Extended (6 months) - 30+ additional languages
### Phase 3: Complete (12 months) - 50+ languages, 95%+ coverage

---

## 🏗️ Architecture

```
┌────────────────────────────────────────────────────────┐
│           SANCHALA LOCALIZATION ARCHITECTURE           │
├────────────────────────────────────────────────────────┤
│  Translation    │  Font Rendering  │  Input Methods   │
│  (Weblate)      │  (Fontconfig)    │  (Fcitx5/IBus)   │
├────────────────────────────────────────────────────────┤
│              LOCALE SUBSYSTEM                          │
│  • glibc locales  • Qt/KDE translations               │
│  • GTK catalogs   • App-specific i18n                 │
├────────────────────────────────────────────────────────┤
│  System UI      │  Applications    │  User Data       │
└────────────────────────────────────────────────────────┘
```

---

## 🤝 Contributing

1. **Join Weblate**: https://translate.sanchala.io
2. **Choose a Language**: Select your native language
3. **Start Translating**: Use the web interface
4. **Review Others**: Help approve translations

See [TRANSLATION-WORKFLOW.md](TRANSLATION-WORKFLOW.md) for details.

---

**Document Version:** 1.0 | **Last Updated:** August 2026

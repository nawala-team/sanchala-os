# 📝 SANCHALA OS - Translation Workflow Guide

## 1. Overview

Sanchala OS uses **Weblate** as the primary translation platform. This guide covers the complete translation workflow from string extraction to deployment.

**URL**: https://translate.sanchala.io

---

## 2. Project Structure

```
Sanchala OS (Organization)
├── sanchala-core          # System utilities
├── sanchala-welcome       # Welcome application
├── sanchala-settings      # Settings application
├── sanchala-installer     # Calamares modules
├── sanchala-desktop       # Desktop entries & metadata
└── sanchala-docs          # User documentation
```

---

## 3. Translator Workflow

### 3.1 Getting Started

1. **Create Account**: Register at https://translate.sanchala.io
2. **Join Language Team**: Request to join your language team
3. **Read Guidelines**: Review language-specific style guides
4. **Start Translating**: Begin with high-priority strings

### 3.2 Quality Checks

Weblate automatically checks for:
- ✅ Missing translations
- ✅ Placeholder mismatches (%s, %d, {0})
- ✅ Punctuation consistency
- ✅ Maximum length violations
- ✅ Glossary term usage

---

## 4. Developer Workflow

### 4.1 Marking Strings

**DO:**
```cpp
i18n("Save document")           // Translatable
i18nc("@action:button", "OK")   // With context
i18np("1 item", "%1 items", n)  // Plurals
```

**DON'T:**
```cpp
QString("Save document")        // Not translatable!
i18n("Error: " + code)          // Don't concatenate!
```

### 4.2 String Extraction

```bash
# Qt/KDE strings
lupdate src/ -ts translations/sanchala_en.ts

# Gettext strings  
xgettext -k_ -kN_ -o po/sanchala.pot src/*.cpp
```

### 4.3 Compile Translations

```bash
# Qt translations
lrelease translations/*.ts

# Gettext translations
msgfmt -o po/id/LC_MESSAGES/sanchala.mo po/id.po
```

---

## 5. Team Roles

| Role | Permissions |
|------|-------------|
| Translator | Suggest and save translations |
| Reviewer | Approve/reject translations |
| Coordinator | Manage team, set priorities |

---

## 6. Crowdin Alternative

```yaml
# crowdin.yml
project_id: "sanchala-os"
files:
  - source: /po/sanchala.pot
    translation: /po/%locale%/LC_MESSAGES/sanchala.po
```

---

## 7. Testing Translations

```bash
# Test specific locale
LANG=id_ID.UTF-8 sanchala-welcome

# Force RTL layout
QT_LAYOUT_DIRECTION=RightToLeft sanchala-settings
```

---

## 8. Release Checklist

- [ ] All priority strings translated (100%)
- [ ] No critical warnings in Weblate
- [ ] RTL languages tested
- [ ] Date/time formats validated

---

**Document Version:** 1.0 | **Last Updated:** August 2026

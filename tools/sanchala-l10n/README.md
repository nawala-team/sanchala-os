# sanchala-l10n

Localization helper tool for Sanchala OS developers and translators.

## Usage

```bash
# Extract strings from source
sanchala-l10n extract -d src/

# Compile translations
sanchala-l10n compile -d po/

# Validate PO files
sanchala-l10n validate po/*.po

# Test with specific locale
sanchala-l10n test -l id_ID sanchala-welcome

# Show translation status
sanchala-l10n status

# List available locales
sanchala-l10n list-locales

# Set system locale
sanchala-l10n set-locale de_DE.UTF-8
```

## Requirements

- bash
- gettext (xgettext, msgfmt)
- qt6-tools (lupdate, lrelease)

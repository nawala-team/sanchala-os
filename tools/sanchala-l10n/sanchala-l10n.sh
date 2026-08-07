#!/bin/bash
# ============================================================================
# SANCHALA OS - Localization Helper Tool
# ============================================================================
# Location: /usr/bin/sanchala-l10n
# Manages localization tasks: extract, compile, test, validate
# ============================================================================

set -euo pipefail
VERSION="1.0.0"
SCRIPT_NAME="$(basename "$0")"

# Colors
RED='\033[0;31m'; GREEN='\033[0;32m'; BLUE='\033[0;34m'; NC='\033[0m'

usage() {
    cat << EOF
Usage: $SCRIPT_NAME <command> [options]

Commands:
  extract       Extract translatable strings from source files
  compile       Compile translation files (.po → .mo, .ts → .qm)
  validate      Validate translation files for errors
  test          Test application with specific locale
  status        Show translation status/statistics
  list-locales  List available system locales
  set-locale    Set system locale

Options:
  -h, --help    Show this help
  -d, --dir     Source/target directory
  -l, --locale  Target locale (e.g., de_DE, ja_JP)

Examples:
  $SCRIPT_NAME extract -d src/
  $SCRIPT_NAME compile -d po/
  $SCRIPT_NAME test -l id_ID sanchala-welcome
EOF
}

cmd_extract() {
    local dir="${1:-.}"
    echo -e "${BLUE}Extracting strings from: ${dir}${NC}"
    
    # Qt/KDE sources
    if compgen -G "${dir}/*.cpp" > /dev/null; then
        lupdate "${dir}" -ts translations/messages_en.ts 2>/dev/null || true
    fi
    
    # Gettext sources
    if compgen -G "${dir}/*.py" > /dev/null; then
        xgettext -k_ -kN_ --from-code=UTF-8 -o po/messages.pot "${dir}"/*.py 2>/dev/null || true
    fi
    echo -e "${GREEN}✓ Extraction complete${NC}"
}

cmd_compile() {
    local dir="${1:-po}"
    echo -e "${BLUE}Compiling translations in: ${dir}${NC}"
    
    for po in "${dir}"/*.po; do
        [ -f "$po" ] || continue
        lang=$(basename "$po" .po)
        mkdir -p "${dir}/${lang}/LC_MESSAGES"
        msgfmt -o "${dir}/${lang}/LC_MESSAGES/sanchala.mo" "$po"
        echo "  → Compiled: $po"
    done
    
    for ts in translations/*.ts; do
        [ -f "$ts" ] || continue
        lrelease "$ts" 2>/dev/null && echo "  → Compiled: $ts"
    done
    echo -e "${GREEN}✓ Compilation complete${NC}"
}

cmd_validate() {
    local errors=0
    echo -e "${BLUE}Validating translation files...${NC}"
    for file in "$@"; do
        [ -f "$file" ] || continue
        if msgfmt --check-format -o /dev/null "$file" 2>/dev/null; then
            echo -e "  $file: ${GREEN}OK${NC}"
        else
            echo -e "  $file: ${RED}ERRORS${NC}"; ((errors++))
        fi
    done
    [ $errors -eq 0 ] && echo -e "${GREEN}✓ All valid${NC}" || exit 1
}

cmd_test() {
    local locale="$1"; shift
    LANGUAGE="${locale}" LANG="${locale}.UTF-8" LC_ALL="${locale}.UTF-8" "$@"
}

cmd_status() {
    echo -e "${BLUE}Translation Status${NC}"
    for po in po/*.po; do
        [ -f "$po" ] || continue
        lang=$(basename "$po" .po)
        total=$(grep -c '^msgid' "$po" 2>/dev/null || echo 0)
        trans=$(grep -c '^msgstr ".' "$po" 2>/dev/null || echo 0)
        printf "  %-10s %3d%% (%d/%d)\n" "$lang" $((trans*100/(total+1))) "$trans" "$total"
    done
}

cmd_list_locales() { locale -a | grep -E '\.utf8|\.UTF-8' | sort; }

cmd_set_locale() {
    local locale="$1"
    localectl set-locale LANG="${locale}"
    echo -e "${GREEN}✓ Locale set to ${locale}. Re-login to apply.${NC}"
}

case "${1:-}" in
    extract)     shift; cmd_extract "$@" ;;
    compile)     shift; cmd_compile "$@" ;;
    validate)    shift; cmd_validate "$@" ;;
    test)        shift; cmd_test "$@" ;;
    status)      cmd_status ;;
    list-locales) cmd_list_locales ;;
    set-locale)  shift; cmd_set_locale "$@" ;;
    -h|--help|"") usage ;;
    *) echo "Unknown: $1"; usage; exit 1 ;;
esac

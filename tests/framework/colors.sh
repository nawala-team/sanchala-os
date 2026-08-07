#!/usr/bin/env bash
# ══════════════════════════════════════════════════════════════════════════════
# SANCHALA OS - Color & Output Functions
# ══════════════════════════════════════════════════════════════════════════════

_supports_color() {
    [[ -z "${NO_COLOR:-}" ]] && [[ -t 1 ]] && [[ "${TERM:-dumb}" != "dumb" ]]
}

if _supports_color; then
    declare -gr C_RESET='\033[0m'
    declare -gr C_RED='\033[0;31m'
    declare -gr C_GREEN='\033[0;32m'
    declare -gr C_YELLOW='\033[0;33m'
    declare -gr C_BLUE='\033[0;34m'
    declare -gr C_CYAN='\033[0;36m'
    declare -gr C_BOLD='\033[1m'
    declare -gr C_DIM='\033[2m'
else
    declare -gr C_RESET='' C_RED='' C_GREEN='' C_YELLOW=''
    declare -gr C_BLUE='' C_CYAN='' C_BOLD='' C_DIM=''
fi

# Unicode symbols
if [[ "${LANG:-}" == *UTF-8* ]] || [[ "${LC_ALL:-}" == *UTF-8* ]]; then
    declare -gr SYM_PASS="✓" SYM_FAIL="✗" SYM_SKIP="⊘" SYM_ERROR="⚠" SYM_INFO="ℹ"
else
    declare -gr SYM_PASS="[OK]" SYM_FAIL="[FAIL]" SYM_SKIP="[SKIP]" SYM_ERROR="[ERR]" SYM_INFO="[i]"
fi

_log() {
    local color="$1" symbol="$2"
    shift 2
    printf "${color}${symbol}${C_RESET} %s\n" "$*" >&2
}

log_pass()  { _log "$C_GREEN"  "$SYM_PASS"  "$@"; }
log_fail()  { _log "$C_RED"    "$SYM_FAIL"  "$@"; }
log_skip()  { _log "$C_YELLOW" "$SYM_SKIP"  "$@"; }
log_error() { _log "$C_RED"    "$SYM_ERROR" "$@"; }
log_info()  { _log "$C_CYAN"   "$SYM_INFO"  "$@"; }
log_debug() { [[ "${DEBUG:-0}" == "1" ]] && _log "$C_DIM" "*" "$@" || true; }

log_header() {
    local title="$1"
    printf "\n${C_BOLD}${C_BLUE}"
    printf '═%.0s' {1..78}
    printf "\n  %s\n" "$title"
    printf '═%.0s' {1..78}
    printf "${C_RESET}\n\n"
}

log_subheader() {
    printf "\n${C_BOLD}${C_CYAN}── %s ──${C_RESET}\n" "$1"
}

export -f _log log_pass log_fail log_skip log_error log_info log_debug log_header log_subheader

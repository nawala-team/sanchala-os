#!/usr/bin/env bash
# ══════════════════════════════════════════════════════════════════════════════
# SANCHALA OS - Test Helper Functions
# ══════════════════════════════════════════════════════════════════════════════
# Source this file in test scripts: source "${TESTS_DIR}/helpers/common.sh"

set -euo pipefail

# Load configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../config.sh"

# ══════════════════════════════════════════════════════════════════════════════
# Test Counters
# ══════════════════════════════════════════════════════════════════════════════
declare -g TESTS_PASSED=0
declare -g TESTS_FAILED=0
declare -g TESTS_SKIPPED=0
declare -g TESTS_TOTAL=0
declare -g CURRENT_SUITE=""
declare -a TEST_FAILURES=()

# ══════════════════════════════════════════════════════════════════════════════
# Output Functions
# ══════════════════════════════════════════════════════════════════════════════

log_info() { echo -e "${COLOR_CYAN}${SYMBOL_INFO} $*${COLOR_RESET}"; }
log_success() { echo -e "${COLOR_GREEN}${SYMBOL_PASS} $*${COLOR_RESET}"; }
log_error() { echo -e "${COLOR_RED}${SYMBOL_FAIL} $*${COLOR_RESET}"; }
log_warning() { echo -e "${COLOR_YELLOW}⚠️  $*${COLOR_RESET}"; }

log_header() {
    echo ""
    echo -e "${COLOR_BOLD}${COLOR_BLUE}══════════════════════════════════════════════════════════════${COLOR_RESET}"
    echo -e "${COLOR_BOLD}${COLOR_BLUE}  $*${COLOR_RESET}"
    echo -e "${COLOR_BOLD}${COLOR_BLUE}══════════════════════════════════════════════════════════════${COLOR_RESET}"
    echo ""
}

log_subheader() { echo -e "\n${COLOR_CYAN}─── $* ───${COLOR_RESET}"; }

# ══════════════════════════════════════════════════════════════════════════════
# Test Suite Functions
# ══════════════════════════════════════════════════════════════════════════════

begin_suite() { CURRENT_SUITE="$1"; log_header "$CURRENT_SUITE"; }
end_suite() { log_subheader "Suite Complete: ${CURRENT_SUITE}"; CURRENT_SUITE=""; }

# ══════════════════════════════════════════════════════════════════════════════
# Test Result Functions
# ══════════════════════════════════════════════════════════════════════════════

pass() {
    local description="$1"
    ((TESTS_PASSED++)); ((TESTS_TOTAL++))
    log_success "PASS: ${description}"
}

fail() {
    local description="$1"
    local reason="${2:-No reason provided}"
    ((TESTS_FAILED++)); ((TESTS_TOTAL++))
    log_error "FAIL: ${description}"
    echo -e "       ${COLOR_RED}Reason: ${reason}${COLOR_RESET}"
    TEST_FAILURES+=("${CURRENT_SUITE}: ${description} - ${reason}")
}

skip() {
    local description="$1"
    local reason="${2:-}"
    ((TESTS_SKIPPED++)); ((TESTS_TOTAL++))
    echo -e "${COLOR_YELLOW}${SYMBOL_SKIP} SKIP: ${description}${COLOR_RESET}"
    [[ -n "$reason" ]] && echo -e "       ${COLOR_YELLOW}Reason: ${reason}${COLOR_RESET}"
}

# Load additional helpers
source "${SCRIPT_DIR}/assertions.sh"
source "${SCRIPT_DIR}/utils.sh"

#!/usr/bin/env bash
# ══════════════════════════════════════════════════════════════════════════════
# SANCHALA OS - ZERO BUG TEST ENGINE
# ══════════════════════════════════════════════════════════════════════════════
set -euo pipefail

readonly TEST_ENGINE_VERSION="1.0.0"
readonly TEST_ENGINE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly TESTS_ROOT="$(dirname "$TEST_ENGINE_DIR")"
readonly PROJECT_ROOT="$(dirname "$TESTS_ROOT")"

# Colors
readonly RED='\033[0;31m' GREEN='\033[0;32m' YELLOW='\033[0;33m'
readonly BLUE='\033[0;34m' CYAN='\033[0;36m' BOLD='\033[1m' RESET='\033[0m'

# Statistics
declare -g TOTAL_TESTS=0 PASSED_TESTS=0 FAILED_TESTS=0 SKIPPED_TESTS=0
declare -g TOTAL_ASSERTIONS=0 PASSED_ASSERTIONS=0 FAILED_ASSERTIONS=0
declare -g CURRENT_TEST_NAME="" CURRENT_SUITE="" TEST_START_TIME=0
declare -a FAILURE_LOG=()

# Logging
log_header() {
    echo -e "\n${BOLD}${BLUE}══════════════════════════════════════════════════════════════${RESET}"
    echo -e "${BOLD}${BLUE}  $1${RESET}"
    echo -e "${BOLD}${BLUE}══════════════════════════════════════════════════════════════${RESET}\n"
}
log_section() { echo -e "\n${BOLD}${CYAN}─── $1 ───${RESET}"; }
log_pass() { echo -e "  ${GREEN}✓${RESET} $1"; }
log_fail() { echo -e "  ${RED}✗${RESET} $1"; }
log_skip() { echo -e "  ${YELLOW}○${RESET} $1"; }
log_info() { echo -e "  ${CYAN}ℹ${RESET} $1"; }
log_error() { echo -e "  ${RED}✖${RESET} $1"; }

# Suite Management
describe() { CURRENT_SUITE="$1"; log_section "$1"; }
end_describe() { CURRENT_SUITE=""; }
it() { CURRENT_TEST_NAME="$1"; TEST_START_TIME=$(date +%s%N 2>/dev/null || date +%s); ((TOTAL_TESTS++)); }

# Source additional modules
source "${TEST_ENGINE_DIR}/assertions.sh"
source "${TEST_ENGINE_DIR}/runner.sh"
source "${TEST_ENGINE_DIR}/reporters.sh"

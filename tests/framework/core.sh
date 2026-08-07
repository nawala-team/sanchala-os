#!/usr/bin/env bash
# ══════════════════════════════════════════════════════════════════════════════
# SANCHALA OS - Zero Bug Test Framework Core
# ══════════════════════════════════════════════════════════════════════════════
# Enterprise-grade testing infrastructure for 100% code coverage
# Version: 2.0.0
# ══════════════════════════════════════════════════════════════════════════════

set -euo pipefail

declare -r FRAMEWORK_VERSION="2.0.0"
declare -r FRAMEWORK_NAME="Sanchala Zero Bug Framework"

# Test result codes
declare -ri TEST_PASS=0
declare -ri TEST_FAIL=1
declare -ri TEST_SKIP=2
declare -ri TEST_ERROR=3
declare -ri TEST_TIMEOUT=4

# Global counters
declare -gi TOTAL_TESTS=0
declare -gi PASSED_TESTS=0
declare -gi FAILED_TESTS=0
declare -gi SKIPPED_TESTS=0
declare -gi ERROR_TESTS=0

# Current test context
declare -g CURRENT_SUITE=""
declare -g CURRENT_TEST=""
declare -ga TEST_FAILURES=()
declare -ga TEST_ERRORS=()

# Timing
declare -g SUITE_START_TIME=""
declare -g TEST_START_TIME=""
declare -g FRAMEWORK_START_TIME=""

# JUnit XML accumulator
declare -ga JUNIT_TESTCASES=()

# Load framework modules
FRAMEWORK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${FRAMEWORK_DIR}/colors.sh"
source "${FRAMEWORK_DIR}/assertions.sh"
source "${FRAMEWORK_DIR}/mocks.sh"
source "${FRAMEWORK_DIR}/fixtures.sh"
source "${FRAMEWORK_DIR}/reporting.sh"

# ══════════════════════════════════════════════════════════════════════════════
# Timing Functions
# ══════════════════════════════════════════════════════════════════════════════
_get_timestamp_ms() {
    if date +%s%3N &>/dev/null 2>&1; then
        date +%s%3N
    else
        echo $(( $(date +%s) * 1000 ))
    fi
}

_format_duration() {
    local ms="$1"
    if (( ms < 1000 )); then
        echo "${ms}ms"
    elif (( ms < 60000 )); then
        echo "$((ms/1000)).$((ms%1000/100))s"
    else
        echo "$((ms/60000))m $((ms%60000/1000))s"
    fi
}

# ══════════════════════════════════════════════════════════════════════════════
# Framework Core Functions
# ══════════════════════════════════════════════════════════════════════════════
framework_init() {
    FRAMEWORK_START_TIME=$(_get_timestamp_ms)
    TOTAL_TESTS=0
    PASSED_TESTS=0
    FAILED_TESTS=0
    SKIPPED_TESTS=0
    ERROR_TESTS=0
    TEST_FAILURES=()
    TEST_ERRORS=()
    JUNIT_TESTCASES=()
    
    log_header "$FRAMEWORK_NAME v$FRAMEWORK_VERSION"
    log_info "Starting test execution at $(date '+%Y-%m-%d %H:%M:%S')"
    log_info "Host: $(uname -n) | OS: $(uname -s) | Arch: $(uname -m)"
}

begin_suite() {
    local suite_name="$1"
    CURRENT_SUITE="$suite_name"
    SUITE_START_TIME=$(_get_timestamp_ms)
    log_subheader "Suite: $suite_name"
}

end_suite() {
    local duration=$(( $(_get_timestamp_ms) - SUITE_START_TIME ))
    log_info "Suite '$CURRENT_SUITE' completed in $(_format_duration $duration)"
    CURRENT_SUITE=""
}

run_test() {
    local test_name="$1"
    local test_func="$2"
    local timeout="${3:-30}"
    
    CURRENT_TEST="$test_name"
    TEST_START_TIME=$(_get_timestamp_ms)
    ((TOTAL_TESTS++))
    
    local result=0
    local output=""
    
    if command -v timeout &>/dev/null; then
        output=$(timeout "$timeout" bash -c "$test_func" 2>&1) || result=$?
    else
        output=$(bash -c "$test_func" 2>&1) || result=$?
    fi
    
    local duration=$(( $(_get_timestamp_ms) - TEST_START_TIME ))
    
    case $result in
        0)
            ((PASSED_TESTS++))
            log_pass "$test_name ($(_format_duration $duration))"
            _add_junit_testcase "$CURRENT_SUITE" "$test_name" "$duration" "passed"
            ;;
        124)
            ((ERROR_TESTS++))
            log_error "$test_name - TIMEOUT"
            TEST_ERRORS+=("$CURRENT_SUITE::$test_name - Timeout after ${timeout}s")
            _add_junit_testcase "$CURRENT_SUITE" "$test_name" "$duration" "error" "Timeout"
            ;;
        *)
            ((FAILED_TESTS++))
            log_fail "$test_name"
            [[ -n "$output" ]] && printf "    %s\n" "$output" | head -5
            TEST_FAILURES+=("$CURRENT_SUITE::$test_name")
            _add_junit_testcase "$CURRENT_SUITE" "$test_name" "$duration" "failure" "$output"
            ;;
    esac
    
    CURRENT_TEST=""
    return $result
}

skip_test() {
    local test_name="$1"
    local reason="${2:-No reason provided}"
    
    ((TOTAL_TESTS++))
    ((SKIPPED_TESTS++))
    log_skip "$test_name - $reason"
    _add_junit_testcase "$CURRENT_SUITE" "$test_name" "0" "skipped" "$reason"
}

get_exit_code() {
    (( FAILED_TESTS > 0 || ERROR_TESTS > 0 )) && echo 1 || echo 0
}

export -f framework_init begin_suite end_suite run_test skip_test get_exit_code
export -f _get_timestamp_ms _format_duration

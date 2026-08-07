#!/usr/bin/env bash
# ══════════════════════════════════════════════════════════════════════════════
# SANCHALA OS - Main Test Runner
# ══════════════════════════════════════════════════════════════════════════════
# Usage: ./run-tests.sh [OPTIONS] [CATEGORY...]
#
# Options:
#   --unit          Run unit tests only
#   --integration   Run integration tests only
#   --security      Run security tests only
#   --installation  Run installation tests only
#   --all           Run all tests (default)
#   --verbose       Verbose output
#   --junit FILE    Generate JUnit XML report
#   --help          Show this help
# ══════════════════════════════════════════════════════════════════════════════

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/config.sh"
source "${SCRIPT_DIR}/helpers/common.sh"

# ══════════════════════════════════════════════════════════════════════════════
# Variables
# ══════════════════════════════════════════════════════════════════════════════
RUN_UNIT=false
RUN_INTEGRATION=false
RUN_SECURITY=false
RUN_INSTALLATION=false
RUN_ALL=true
VERBOSE=false
JUNIT_OUTPUT=""

# ══════════════════════════════════════════════════════════════════════════════
# Parse Arguments
# ══════════════════════════════════════════════════════════════════════════════
parse_args() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --unit) RUN_UNIT=true; RUN_ALL=false ;;
            --integration) RUN_INTEGRATION=true; RUN_ALL=false ;;
            --security) RUN_SECURITY=true; RUN_ALL=false ;;
            --installation) RUN_INSTALLATION=true; RUN_ALL=false ;;
            --all) RUN_ALL=true ;;
            --verbose|-v) VERBOSE=true ;;
            --junit) JUNIT_OUTPUT="$2"; shift ;;
            --help|-h) show_help; exit 0 ;;
            *) log_error "Unknown option: $1"; exit 1 ;;
        esac
        shift
    done
}

show_help() {
    cat <<EOF
SANCHALA OS Test Runner

Usage: $(basename "$0") [OPTIONS]

Options:
  --unit          Run unit tests only
  --integration   Run integration tests only  
  --security      Run security tests only
  --installation  Run installation tests only (requires QEMU)
  --all           Run all tests (default)
  --verbose, -v   Verbose output
  --junit FILE    Generate JUnit XML report
  --help, -h      Show this help

Examples:
  ./run-tests.sh                    # Run all tests
  ./run-tests.sh --unit --security  # Run unit and security tests
  ./run-tests.sh --junit report.xml # Generate JUnit report
EOF
}

# ══════════════════════════════════════════════════════════════════════════════
# Test Runners
# ══════════════════════════════════════════════════════════════════════════════
run_unit_tests() {
    begin_suite "Unit Tests"
    for test_file in "${TESTS_DIR}/unit"/test-*.sh; do
        [[ -f "$test_file" ]] || continue
        log_info "Running: $(basename "$test_file")"
        source "$test_file"
    done
    end_suite
}

run_integration_tests() {
    begin_suite "Integration Tests"
    for test_file in "${TESTS_DIR}/integration"/test-*.sh; do
        [[ -f "$test_file" ]] || continue
        log_info "Running: $(basename "$test_file")"
        source "$test_file"
    done
    end_suite
}

run_security_tests() {
    begin_suite "Security Tests"
    for test_file in "${TESTS_DIR}/security"/test-*.sh; do
        [[ -f "$test_file" ]] || continue
        log_info "Running: $(basename "$test_file")"
        source "$test_file"
    done
    end_suite
}

run_installation_tests() {
    begin_suite "Installation Tests"
    if ! command -v qemu-system-x86_64 &>/dev/null; then
        skip "Installation tests" "QEMU not available"
        end_suite
        return
    fi
    for test_file in "${TESTS_DIR}/installation"/test-*.sh; do
        [[ -f "$test_file" ]] || continue
        log_info "Running: $(basename "$test_file")"
        source "$test_file"
    done
    end_suite
}

# ══════════════════════════════════════════════════════════════════════════════
# Main
# ══════════════════════════════════════════════════════════════════════════════
main() {
    parse_args "$@"
    
    # Setup output directory
    mkdir -p "${TEST_OUTPUT_DIR}"
    
    log_header "SANCHALA OS Test Framework"
    log_info "Project root: ${SANCHALA_ROOT}"
    log_info "Test directory: ${TESTS_DIR}"
    
    # Run selected test categories
    if $RUN_ALL || $RUN_UNIT; then run_unit_tests; fi
    if $RUN_ALL || $RUN_INTEGRATION; then run_integration_tests; fi
    if $RUN_ALL || $RUN_SECURITY; then run_security_tests; fi
    if $RUN_ALL || $RUN_INSTALLATION; then run_installation_tests; fi
    
    # Generate reports
    print_summary
    [[ -n "$JUNIT_OUTPUT" ]] && generate_junit_report "$JUNIT_OUTPUT"
    
    exit "$(get_exit_code)"
}

main "$@"

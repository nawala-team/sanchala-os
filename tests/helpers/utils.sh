#!/usr/bin/env bash
# ══════════════════════════════════════════════════════════════════════════════
# SANCHALA OS - Test Utility Functions
# ══════════════════════════════════════════════════════════════════════════════

# Check if running in CI environment
is_ci() { [[ -n "${CI:-}" ]] || [[ -n "${GITHUB_ACTIONS:-}" ]]; }

# Check if running as root
is_root() { [[ "$(id -u)" -eq 0 ]]; }

# Require root for a test
require_root() {
    if ! is_root; then skip "$1" "Requires root privileges"; return 1; fi
    return 0
}

# Check required tools
check_required_tools() {
    local -a tools=("$@") missing=()
    for tool in "${tools[@]}"; do
        command -v "$tool" &>/dev/null || missing+=("$tool")
    done
    if [[ ${#missing[@]} -gt 0 ]]; then
        log_warning "Missing required tools: ${missing[*]}"; return 1
    fi
    return 0
}

# Create temporary test directory
create_temp_dir() { mktemp -d "${TEST_OUTPUT_DIR}/test.XXXXXX"; }

# Clean up temporary files
cleanup_temp() { local temp_dir="$1"; [[ -d "$temp_dir" ]] && rm -rf "$temp_dir"; }

# ══════════════════════════════════════════════════════════════════════════════
# Report Functions
# ══════════════════════════════════════════════════════════════════════════════

print_summary() {
    echo ""; log_header "Test Summary"
    local pass_rate=0
    [[ $TESTS_TOTAL -gt 0 ]] && pass_rate=$((TESTS_PASSED * 100 / TESTS_TOTAL))
    
    echo -e "  ${COLOR_GREEN}Passed:${COLOR_RESET}  ${TESTS_PASSED}"
    echo -e "  ${COLOR_RED}Failed:${COLOR_RESET}  ${TESTS_FAILED}"
    echo -e "  ${COLOR_YELLOW}Skipped:${COLOR_RESET} ${TESTS_SKIPPED}"
    echo -e "  ${COLOR_BOLD}Total:${COLOR_RESET}   ${TESTS_TOTAL}"
    echo -e "\n  Pass Rate: ${pass_rate}%"
    
    if [[ ${#TEST_FAILURES[@]} -gt 0 ]]; then
        log_subheader "Failures"
        for failure in "${TEST_FAILURES[@]}"; do
            echo -e "  ${COLOR_RED}• ${failure}${COLOR_RESET}"
        done
    fi
    echo ""
    [[ $TESTS_FAILED -eq 0 ]] && log_success "All tests passed!" || log_error "${TESTS_FAILED} test(s) failed"
}

# Generate JUnit XML report
generate_junit_report() {
    local output_file="${1:-$TEST_JUNIT_FILE}"
    local timestamp; timestamp=$(date -Iseconds)
    mkdir -p "$(dirname "$output_file")"
    
    cat > "$output_file" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<testsuites name="Sanchala OS Tests" tests="${TESTS_TOTAL}" failures="${TESTS_FAILED}" skipped="${TESTS_SKIPPED}">
  <testsuite name="${CURRENT_SUITE:-all}" tests="${TESTS_TOTAL}" failures="${TESTS_FAILED}" skipped="${TESTS_SKIPPED}">
EOF
    for failure in "${TEST_FAILURES[@]}"; do
        local test_name="${failure%%:*}" message="${failure#*: }"
        echo "    <testcase name=\"${test_name}\"><failure message=\"${message}\"/></testcase>" >> "$output_file"
    done
    echo "  </testsuite></testsuites>" >> "$output_file"
    log_info "JUnit report written to: ${output_file}"
}

# Return exit code based on test results
get_exit_code() { [[ $TESTS_FAILED -eq 0 ]] && echo 0 || echo 1; }

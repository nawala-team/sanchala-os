#!/usr/bin/env bash
# ══════════════════════════════════════════════════════════════════════════════
# SANCHALA OS - Reporting Functions
# ══════════════════════════════════════════════════════════════════════════════

_add_junit_testcase() {
    local suite="$1" name="$2" time_ms="$3" status="$4" message="${5:-}"
    local time_sec=$((time_ms / 1000)).$((time_ms % 1000))
    local escaped_msg
    escaped_msg=$(echo "$message" | sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g' | head -c 500)
    
    local testcase="    <testcase classname=\"$suite\" name=\"$name\" time=\"$time_sec\">"
    case "$status" in
        passed)  testcase+="</testcase>" ;;
        failure) testcase+="<failure><![CDATA[$escaped_msg]]></failure></testcase>" ;;
        error)   testcase+="<error message=\"Error\"/></testcase>" ;;
        skipped) testcase+="<skipped/></testcase>" ;;
    esac
    JUNIT_TESTCASES+=("$testcase")
}

generate_junit_report() {
    local output_file="$1"
    local total_time=$(( $(_get_timestamp_ms) - FRAMEWORK_START_TIME ))
    cat > "$output_file" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<testsuites name="Sanchala OS" tests="$TOTAL_TESTS" failures="$FAILED_TESTS" errors="$ERROR_TESTS" skipped="$SKIPPED_TESTS">
  <testsuite name="All Tests" tests="$TOTAL_TESTS" failures="$FAILED_TESTS" errors="$ERROR_TESTS">
$(printf '%s\n' "${JUNIT_TESTCASES[@]}")
  </testsuite>
</testsuites>
EOF
    log_info "JUnit report: $output_file"
}

generate_html_report() {
    local output_file="$1"
    local pass_rate=0
    (( TOTAL_TESTS > 0 )) && pass_rate=$(( (PASSED_TESTS * 100) / TOTAL_TESTS ))
    
    cat > "$output_file" << EOF
<!DOCTYPE html><html><head><meta charset="UTF-8"><title>Test Report</title>
<style>body{font-family:sans-serif;margin:40px}h1{color:#333}.pass{color:green}.fail{color:red}</style></head>
<body><h1>Sanchala OS Test Report</h1>
<p>Pass: $PASSED_TESTS | Fail: $FAILED_TESTS | Skip: $SKIPPED_TESTS | Rate: ${pass_rate}%</p>
</body></html>
EOF
    log_info "HTML report: $output_file"
}

print_summary() {
    local total_time=$(( $(_get_timestamp_ms) - FRAMEWORK_START_TIME ))
    local pass_rate=0
    (( TOTAL_TESTS > 0 )) && pass_rate=$(( (PASSED_TESTS * 100) / TOTAL_TESTS ))
    
    log_header "Test Summary"
    printf "${C_BOLD}Results:${C_RESET}\n"
    printf "  ${C_GREEN}Passed:${C_RESET}  %d\n" "$PASSED_TESTS"
    printf "  ${C_RED}Failed:${C_RESET}  %d\n" "$FAILED_TESTS"
    printf "  ${C_YELLOW}Skipped:${C_RESET} %d\n" "$SKIPPED_TESTS"
    printf "  ${C_RED}Errors:${C_RESET}  %d\n" "$ERROR_TESTS"
    printf "  ${C_BOLD}Total:${C_RESET}   %d\n\n" "$TOTAL_TESTS"
    printf "${C_BOLD}Pass Rate:${C_RESET} %d%% | ${C_BOLD}Duration:${C_RESET} %s\n" "$pass_rate" "$(_format_duration $total_time)"
    
    if (( ${#TEST_FAILURES[@]} > 0 )); then
        printf "\n${C_RED}Failed Tests:${C_RESET}\n"
        for f in "${TEST_FAILURES[@]}"; do printf "  ✗ %s\n" "$f"; done
    fi
    printf "\n"
    if (( FAILED_TESTS == 0 && ERROR_TESTS == 0 )); then
        printf "${C_GREEN}${C_BOLD}✓ ZERO BUG TARGET MET${C_RESET}\n"
    else
        printf "${C_RED}${C_BOLD}✗ ZERO BUG TARGET NOT MET${C_RESET}\n"
    fi
}

export -f _add_junit_testcase generate_junit_report generate_html_report print_summary

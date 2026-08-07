#!/usr/bin/env bash
# SANCHALA OS - Zero Bug Framework - Reporters
set -euo pipefail

print_summary() {
    local pass_rate=0
    [[ $TOTAL_TESTS -gt 0 ]] && pass_rate=$((PASSED_TESTS * 100 / TOTAL_TESTS))
    
    log_header "TEST SUMMARY"
    echo "  Passed:     $PASSED_TESTS"
    echo "  Failed:     $FAILED_TESTS"
    echo "  Skipped:    $SKIPPED_TESTS"
    echo "  Total:      $TOTAL_TESTS"
    echo "  Pass Rate:  ${pass_rate}%"
    echo ""
    echo "  Assertions: $PASSED_ASSERTIONS/$TOTAL_ASSERTIONS passed"
    
    if [[ ${#FAILURE_LOG[@]} -gt 0 ]]; then
        log_subheader "FAILURES"
        for failure in "${FAILURE_LOG[@]}"; do
            echo "  • $failure"
        done
    fi
    echo ""
    [[ $FAILED_TESTS -eq 0 ]] && log_pass "ALL TESTS PASSED!" || log_fail "$FAILED_TESTS TEST(S) FAILED"
}

generate_junit_xml() {
    local output="$1"
    cat > "$output" << JUNIT
<?xml version="1.0" encoding="UTF-8"?>
<testsuites name="Sanchala OS Tests" tests="$TOTAL_TESTS" failures="$FAILED_TESTS" skipped="$SKIPPED_TESTS">
  <testsuite name="all" tests="$TOTAL_TESTS" failures="$FAILED_TESTS" skipped="$SKIPPED_TESTS">
JUNIT
    for failure in "${FAILURE_LOG[@]}"; do
        local name="${failure%%:*}"
        local msg="${failure#*: }"
        echo "    <testcase name=\"$name\"><failure message=\"$msg\"/></testcase>" >> "$output"
    done
    echo "  </testsuite>" >> "$output"
    echo "</testsuites>" >> "$output"
    log_info "JUnit XML: $output"
}

generate_html_report() {
    local output="$1"
    local pass_rate=0
    [[ $TOTAL_TESTS -gt 0 ]] && pass_rate=$((PASSED_TESTS * 100 / TOTAL_TESTS))
    cat > "$output" << HTML
<!DOCTYPE html>
<html><head><title>Sanchala OS Test Report</title>
<style>
body{font-family:sans-serif;margin:40px;background:#1a1a2e;color:#eee}
.pass{color:#4ade80}.fail{color:#f87171}.skip{color:#fbbf24}
.card{background:#16213e;padding:20px;border-radius:8px;margin:10px 0}
.progress{background:#333;border-radius:4px;height:20px}
.bar{background:#4ade80;height:100%;border-radius:4px}
</style></head><body>
<h1>Sanchala OS Test Report</h1>
<div class="card">
<h2>Summary</h2>
<p><span class="pass">Passed: $PASSED_TESTS</span> | <span class="fail">Failed: $FAILED_TESTS</span> | <span class="skip">Skipped: $SKIPPED_TESTS</span></p>
<div class="progress"><div class="bar" style="width:${pass_rate}%"></div></div>
<p>Pass Rate: ${pass_rate}%</p>
</div>
HTML
    if [[ ${#FAILURE_LOG[@]} -gt 0 ]]; then
        echo '<div class="card"><h2>Failures</h2><ul>' >> "$output"
        for f in "${FAILURE_LOG[@]}"; do echo "<li class=\"fail\">$f</li>" >> "$output"; done
        echo '</ul></div>' >> "$output"
    fi
    echo '</body></html>' >> "$output"
    log_info "HTML Report: $output"
}

generate_coverage_report() {
    local tools_dir="$1" output="$2"
    local total=0 tested=0
    echo "# Coverage Report" > "$output"
    echo "Generated: $(date)" >> "$output"
    echo "" >> "$output"
    for tool in "$tools_dir"/sanchala-*; do
        [[ -e "$tool" ]] || continue
        ((total++))
        local name=$(basename "$tool")
        if [[ -f "${TESTS_ROOT}/unit/tools/test-${name}.sh" ]]; then
            ((tested++)); echo "[x] $name" >> "$output"
        else
            echo "[ ] $name" >> "$output"
        fi
    done
    local coverage=0
    [[ $total -gt 0 ]] && coverage=$((tested * 100 / total))
    echo "" >> "$output"
    echo "Coverage: $tested/$total ($coverage%)" >> "$output"
    log_info "Coverage: $coverage% ($tested/$total tools)"
}

export -f print_summary generate_junit_xml generate_html_report generate_coverage_report

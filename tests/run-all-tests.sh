#!/usr/bin/env bash
# ══════════════════════════════════════════════════════════════════════════════
# SANCHALA OS - ZERO BUG MASTER TEST RUNNER
# ══════════════════════════════════════════════════════════════════════════════
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/framework/test-engine.sh"

# Config
RUN_UNIT=false RUN_INTEGRATION=false RUN_SECURITY=false
RUN_PERFORMANCE=false RUN_ACCESSIBILITY=false RUN_REGRESSION=false
RUN_ALL=true QUICK_MODE=false CI_MODE=false VERBOSE=false

show_help() {
    echo "SANCHALA OS - ZERO BUG TEST FRAMEWORK"
    echo "Usage: ./run-all-tests.sh [OPTIONS]"
    echo "  --unit/--integration/--security/--performance/--accessibility/--regression"
    echo "  --all (default) --quick --ci --verbose -h/--help"
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --unit) RUN_UNIT=true; RUN_ALL=false ;;
        --integration) RUN_INTEGRATION=true; RUN_ALL=false ;;
        --security) RUN_SECURITY=true; RUN_ALL=false ;;
        --performance) RUN_PERFORMANCE=true; RUN_ALL=false ;;
        --accessibility) RUN_ACCESSIBILITY=true; RUN_ALL=false ;;
        --regression) RUN_REGRESSION=true; RUN_ALL=false ;;
        --all) RUN_ALL=true ;; --quick) QUICK_MODE=true ;;
        --ci) CI_MODE=true ;; --verbose|-v) VERBOSE=true ;;
        --help|-h) show_help; exit 0 ;;
        *) echo "Unknown: $1"; exit 1 ;;
    esac; shift
done

run_test_category() {
    local category="$1" dir="${SCRIPT_DIR}/${category}"
    [[ -d "$dir" ]] || return 0
    log_header "Running ${category^^} Tests"
    for test_file in "$dir"/test-*.sh; do
        [[ -f "$test_file" ]] || continue
        source "$test_file" || log_error "Failed: $test_file"
    done
}

main() {
    local start_time=$(date +%s)
    log_header "SANCHALA OS - ZERO BUG TEST FRAMEWORK v${TEST_ENGINE_VERSION}"
    
    if $QUICK_MODE; then run_test_category "regression"; print_summary; exit $(get_exit_code); fi
    
    if $RUN_ALL || $RUN_UNIT; then run_test_category "unit"; fi
    if $RUN_ALL || $RUN_INTEGRATION; then run_test_category "integration"; fi
    if $RUN_ALL || $RUN_SECURITY; then run_test_category "security"; fi
    if $RUN_ALL || $RUN_PERFORMANCE; then run_test_category "performance"; fi
    if $RUN_ALL || $RUN_ACCESSIBILITY; then run_test_category "accessibility"; fi
    if $RUN_ALL || $RUN_REGRESSION; then run_test_category "regression"; fi
    
    print_summary
    echo -e "\n  Duration: $(($(date +%s) - start_time))s"
    
    if $CI_MODE; then
        mkdir -p "${SCRIPT_DIR}/reports"
        generate_junit_xml "${SCRIPT_DIR}/reports/junit.xml"
        generate_json_report "${SCRIPT_DIR}/reports/results.json"
    fi
    exit $(get_exit_code)
}
main "$@"

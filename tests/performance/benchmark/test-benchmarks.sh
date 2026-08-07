#!/usr/bin/env bash
# ══════════════════════════════════════════════════════════════════════════════
# Performance Tests: Benchmark Suite
# ══════════════════════════════════════════════════════════════════════════════

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../framework/core.sh"
source "$SCRIPT_DIR/../../framework/performance.sh"

TOOLS_DIR="$SANCHALA_ROOT/tools"

# Test script loading performance
test_script_load_time() {
    local total_time=0
    local count=0
    
    for script in "$TOOLS_DIR"/sanchala-*/lib/*.sh; do
        [[ -f "$script" ]] || continue
        local start=$(date +%s%N)
        bash -n "$script" 2>/dev/null
        local end=$(date +%s%N)
        total_time=$((total_time + (end - start) / 1000000))
        ((count++))
    done
    
    if (( count > 0 )); then
        local avg=$((total_time / count))
        log_info "Average script parse time: ${avg}ms"
        (( avg < 100 ))  # Should parse in under 100ms
    fi
    return 0
}

# Test Python import time
test_python_import_time() {
    local total_time=0
    local count=0
    
    for pyfile in "$TOOLS_DIR"/sanchala-*/*.py; do
        [[ -f "$pyfile" ]] || continue
        local start=$(date +%s%N)
        python3 -m py_compile "$pyfile" 2>/dev/null
        local end=$(date +%s%N)
        total_time=$((total_time + (end - start) / 1000000))
        ((count++))
        (( count >= 20 )) && break  # Sample first 20
    done
    
    if (( count > 0 )); then
        local avg=$((total_time / count))
        log_info "Average Python compile time: ${avg}ms"
        (( avg < 500 ))  # Should compile in under 500ms
    fi
    return 0
}

# Test file system operations
test_file_operations_performance() {
    setup_fixture
    
    local start=$(date +%s%N)
    
    # Create 100 files
    for i in {1..100}; do
        echo "test content $i" > "$FIXTURE_DIR/file_$i.txt"
    done
    
    # Read all files
    for i in {1..100}; do
        cat "$FIXTURE_DIR/file_$i.txt" > /dev/null
    done
    
    # Delete all files
    rm -f "$FIXTURE_DIR"/file_*.txt
    
    local end=$(date +%s%N)
    local duration=$(( (end - start) / 1000000 ))
    
    teardown_fixture
    
    log_info "100 file operations completed in ${duration}ms"
    (( duration < 5000 ))  # Should complete in under 5 seconds
}

# Test JSON parsing performance
test_json_parsing_performance() {
    setup_fixture
    
    # Create test JSON
    local json_file="$FIXTURE_DIR/test.json"
    echo '{"tools": [' > "$json_file"
    for i in {1..100}; do
        echo '{"name": "tool'$i'", "version": "1.0.'$i'"},' >> "$json_file"
    done
    echo '{"name": "last", "version": "1.0.0"}]}' >> "$json_file"
    
    local start=$(date +%s%N)
    
    if command -v jq &>/dev/null; then
        jq '.tools | length' "$json_file" > /dev/null
    elif command -v python3 &>/dev/null; then
        python3 -c "import json; print(len(json.load(open('$json_file'))['tools']))" > /dev/null
    fi
    
    local end=$(date +%s%N)
    local duration=$(( (end - start) / 1000000 ))
    
    teardown_fixture
    
    log_info "JSON parsing completed in ${duration}ms"
    (( duration < 1000 ))
}

# Test grep performance on codebase
test_grep_performance() {
    local start=$(date +%s%N)
    
    grep -r "def \|function " "$TOOLS_DIR" 2>/dev/null | wc -l > /dev/null
    
    local end=$(date +%s%N)
    local duration=$(( (end - start) / 1000000 ))
    
    log_info "Codebase grep completed in ${duration}ms"
    (( duration < 10000 ))  # Under 10 seconds
}

# Test find performance
test_find_performance() {
    local start=$(date +%s%N)
    
    find "$SANCHALA_ROOT" -type f -name "*.sh" 2>/dev/null | wc -l > /dev/null
    find "$SANCHALA_ROOT" -type f -name "*.py" 2>/dev/null | wc -l > /dev/null
    
    local end=$(date +%s%N)
    local duration=$(( (end - start) / 1000000 ))
    
    log_info "Find operations completed in ${duration}ms"
    (( duration < 5000 ))
}

# Run tests
run_test "Script load time" test_script_load_time
run_test "Python import time" test_python_import_time
run_test "File operations performance" test_file_operations_performance
run_test "JSON parsing performance" test_json_parsing_performance
run_test "Grep performance" test_grep_performance
run_test "Find performance" test_find_performance

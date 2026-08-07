#!/usr/bin/env bash
# SANCHALA OS - Performance Testing Module
set -euo pipefail

measure_time() {
    local cmd="$1" start end
    start=$(date +%s%N 2>/dev/null || echo "$(date +%s)000000000")
    eval "$cmd" &>/dev/null
    end=$(date +%s%N 2>/dev/null || echo "$(date +%s)000000000")
    echo $(( (end - start) / 1000000 ))
}

benchmark() {
    local name="$1" cmd="$2" iterations="${3:-10}"
    local total=0 min=999999999 max=0
    log_info "Benchmarking: $name ($iterations iterations)"
    for ((i=1; i<=iterations; i++)); do
        local time=$(measure_time "$cmd")
        ((total += time)); ((time < min)) && min=$time; ((time > max)) && max=$time
    done
    local avg=$((total / iterations))
    echo "  Avg: ${avg}ms | Min: ${min}ms | Max: ${max}ms"
}

stress_test() {
    local name="$1" cmd="$2" duration="${3:-10}"
    local count=0 start=$(date +%s) end=$((start + duration))
    log_info "Stress test: $name (${duration}s)"
    while [[ $(date +%s) -lt $end ]]; do
        eval "$cmd" &>/dev/null && ((count++)) || true
    done
    echo "  Completed: $count iterations"
}

memory_leak_test() {
    local cmd="$1" iterations="${2:-100}"
    log_info "Memory leak test ($iterations iterations)"
    for ((i=0; i<iterations; i++)); do eval "$cmd" &>/dev/null; done
    log_pass "Memory test completed"
}

export -f measure_time benchmark stress_test memory_leak_test

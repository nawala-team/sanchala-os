#!/usr/bin/env bash
# ══════════════════════════════════════════════════════════════════════════════
# Unit Tests: Python Tools Validation
# ══════════════════════════════════════════════════════════════════════════════

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../framework/core.sh"

TOOLS_DIR="$SANCHALA_ROOT/tools"

test_cloud_daemon() {
    local file="$TOOLS_DIR/sanchala-cloud/lib/sanchala-cloudd.py"
    [[ -f "$file" ]] && python3 -m py_compile "$file" 2>/dev/null
}

test_cloud_providers() {
    local file="$TOOLS_DIR/sanchala-cloud/lib/cloud_providers.py"
    [[ -f "$file" ]] && python3 -m py_compile "$file" 2>/dev/null
}

test_ai_daemon() {
    local file="$TOOLS_DIR/sanchala-ai/lib/sanchala-aid.py"
    [[ -f "$file" ]] && python3 -m py_compile "$file" 2>/dev/null
}

test_cpu_governor() {
    local file="$TOOLS_DIR/sanchala-cpu-governor/sanchala-cpu-governor.py"
    [[ -f "$file" ]] && python3 -m py_compile "$file" 2>/dev/null
}

test_battery_health() {
    local file="$TOOLS_DIR/sanchala-battery-health/sanchala-battery-health.py"
    [[ -f "$file" ]] && python3 -m py_compile "$file" 2>/dev/null
}

test_containers() {
    local file="$TOOLS_DIR/sanchala-containers/containers.py"
    [[ -f "$file" ]] && python3 -m py_compile "$file" 2>/dev/null
}

test_task_manager() {
    local file="$TOOLS_DIR/sanchala-task-manager/task-manager.py"
    [[ -f "$file" ]] && python3 -m py_compile "$file" 2>/dev/null
}

test_sandbox() {
    local file="$TOOLS_DIR/sanchala-sandbox/sandbox.py"
    [[ -f "$file" ]] && python3 -m py_compile "$file" 2>/dev/null
}

test_wine() {
    local file="$TOOLS_DIR/sanchala-wine/wine.py"
    [[ -f "$file" ]] && python3 -m py_compile "$file" 2>/dev/null
}

test_virt_manager() {
    local file="$TOOLS_DIR/sanchala-virt-manager/virt-manager.py"
    [[ -f "$file" ]] && python3 -m py_compile "$file" 2>/dev/null
}

# Run tests
run_test "Cloud daemon syntax" test_cloud_daemon
run_test "Cloud providers syntax" test_cloud_providers
run_test "AI daemon syntax" test_ai_daemon
run_test "CPU governor syntax" test_cpu_governor
run_test "Battery health syntax" test_battery_health
run_test "Containers syntax" test_containers
run_test "Task manager syntax" test_task_manager
run_test "Sandbox syntax" test_sandbox
run_test "Wine integration syntax" test_wine
run_test "Virt manager syntax" test_virt_manager

#!/usr/bin/env bash
# ══════════════════════════════════════════════════════════════════════════════
# SANCHALA OS - Test Framework Configuration
# ══════════════════════════════════════════════════════════════════════════════

# Project root (auto-detected)
export SANCHALA_ROOT="${SANCHALA_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
export TESTS_DIR="${SANCHALA_ROOT}/tests"

# Test output
export TEST_OUTPUT_DIR="${TESTS_DIR}/.output"
export TEST_LOG_FILE="${TEST_OUTPUT_DIR}/test.log"
export TEST_JUNIT_FILE="${TEST_OUTPUT_DIR}/junit.xml"

# Timeouts (in seconds)
export TEST_TIMEOUT_UNIT=30
export TEST_TIMEOUT_INTEGRATION=120
export TEST_TIMEOUT_INSTALLATION=1800  # 30 minutes for VM tests
export TEST_TIMEOUT_SECURITY=300

# VM Testing Configuration
export QEMU_MEMORY="4G"
export QEMU_CPUS="2"
export QEMU_DISK_SIZE="20G"
export QEMU_TIMEOUT=600

# Test ISO path (for installation tests)
export TEST_ISO_PATH="${TEST_ISO_PATH:-${SANCHALA_ROOT}/iso/out/sanchala-latest-x86_64.iso}"

# Colors (disabled if NO_COLOR is set or not a terminal)
if [[ -z "${NO_COLOR:-}" ]] && [[ -t 1 ]]; then
    export COLOR_RESET="\033[0m"
    export COLOR_RED="\033[0;31m"
    export COLOR_GREEN="\033[0;32m"
    export COLOR_YELLOW="\033[0;33m"
    export COLOR_BLUE="\033[0;34m"
    export COLOR_CYAN="\033[0;36m"
    export COLOR_BOLD="\033[1m"
else
    export COLOR_RESET=""
    export COLOR_RED=""
    export COLOR_GREEN=""
    export COLOR_YELLOW=""
    export COLOR_BLUE=""
    export COLOR_CYAN=""
    export COLOR_BOLD=""
fi

# Test result symbols
export SYMBOL_PASS="✅"
export SYMBOL_FAIL="❌"
export SYMBOL_SKIP="⏭️"
export SYMBOL_INFO="ℹ️"

# Required tools for different test categories
declare -a REQUIRED_TOOLS_UNIT=(bash shellcheck)
declare -a REQUIRED_TOOLS_INTEGRATION=(bash python3)
declare -a REQUIRED_TOOLS_INSTALLATION=(qemu-system-x86_64 expect)
declare -a REQUIRED_TOOLS_SECURITY=(bash)

export REQUIRED_TOOLS_UNIT
export REQUIRED_TOOLS_INTEGRATION
export REQUIRED_TOOLS_INSTALLATION
export REQUIRED_TOOLS_SECURITY

# Quality gate thresholds
export QUALITY_GATE_UNIT_PASS_RATE=100
export QUALITY_GATE_INTEGRATION_PASS_RATE=100
export QUALITY_GATE_SECURITY_PASS_RATE=100
export QUALITY_GATE_INSTALLATION_PASS_RATE=100

#!/usr/bin/env bash
# ══════════════════════════════════════════════════════════════════════════════
# SANCHALA OS - Static Analysis Runner
# ══════════════════════════════════════════════════════════════════════════════
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
REPORT_DIR="${SCRIPT_DIR}/reports"

mkdir -p "$REPORT_DIR"

echo "═══════════════════════════════════════════════════════════════"
echo "  SANCHALA OS - Static Analysis"
echo "═══════════════════════════════════════════════════════════════"

# ShellCheck for shell scripts
run_shellcheck() {
    echo -e "\n─── ShellCheck Analysis ───"
    if command -v shellcheck &>/dev/null; then
        local errors=0
        while IFS= read -r script; do
            if ! shellcheck -S warning "$script" 2>/dev/null; then
                ((errors++))
            fi
        done < <(find "$PROJECT_ROOT" -name "*.sh" -type f 2>/dev/null | head -50)
        echo "ShellCheck: $errors files with warnings"
    else
        echo "ShellCheck not installed - skipping"
    fi
}

# Python linting
run_pylint() {
    echo -e "\n─── Python Linting ───"
    if command -v python3 &>/dev/null; then
        local errors=0
        while IFS= read -r pyfile; do
            if ! python3 -m py_compile "$pyfile" 2>/dev/null; then
                ((errors++))
            fi
        done < <(find "$PROJECT_ROOT" -name "*.py" -type f 2>/dev/null | head -50)
        echo "Python syntax check: $errors errors"
    fi
}

# JSON validation
run_json_check() {
    echo -e "\n─── JSON Validation ───"
    local errors=0
    while IFS= read -r json; do
        if ! python3 -c "import json; json.load(open('$json'))" 2>/dev/null; then
            echo "Invalid: $json"
            ((errors++))
        fi
    done < <(find "$PROJECT_ROOT" -name "*.json" -type f 2>/dev/null | head -100)
    echo "JSON validation: $errors errors"
}

# YAML validation
run_yaml_check() {
    echo -e "\n─── YAML Validation ───"
    if python3 -c "import yaml" 2>/dev/null; then
        local errors=0
        while IFS= read -r yaml; do
            if ! python3 -c "import yaml; yaml.safe_load(open('$yaml'))" 2>/dev/null; then
                echo "Invalid: $yaml"
                ((errors++))
            fi
        done < <(find "$PROJECT_ROOT" \( -name "*.yml" -o -name "*.yaml" \) -type f 2>/dev/null | head -50)
        echo "YAML validation: $errors errors"
    else
        echo "PyYAML not installed - skipping"
    fi
}

run_shellcheck
run_pylint
run_json_check
run_yaml_check

echo -e "\n═══════════════════════════════════════════════════════════════"
echo "  Static Analysis Complete"
echo "═══════════════════════════════════════════════════════════════"

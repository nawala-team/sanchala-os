#!/usr/bin/env bash
# ══════════════════════════════════════════════════════════════════════════════
# SANCHALA OS - Static Analysis Module
# ══════════════════════════════════════════════════════════════════════════════

run_shellcheck_analysis() {
    local path="$1"
    local severity="${2:-warning}"
    local issues=0
    
    if ! command -v shellcheck &>/dev/null; then
        log_skip "shellcheck not installed"
        return 0
    fi
    
    log_info "Running shellcheck analysis on $path"
    
    while IFS= read -r -d '' file; do
        if ! shellcheck -S "$severity" "$file" 2>&1; then
            ((issues++))
        fi
    done < <(find "$path" -name "*.sh" -type f -print0 2>/dev/null)
    
    log_info "Shellcheck: $issues files with issues"
    return $((issues > 0 ? 1 : 0))
}

run_pylint_analysis() {
    local path="$1"
    local min_score="${2:-8.0}"
    
    if ! command -v pylint &>/dev/null; then
        log_skip "pylint not installed"
        return 0
    fi
    
    log_info "Running pylint analysis on $path"
    
    local score
    score=$(pylint "$path" --output-format=text 2>/dev/null | grep "Your code" | grep -oE '[0-9]+\.[0-9]+' | head -1)
    
    if [[ -n "$score" ]]; then
        log_info "Pylint score: $score (minimum: $min_score)"
        if (( $(echo "$score >= $min_score" | bc -l) )); then
            return 0
        fi
    fi
    return 1
}

run_mypy_analysis() {
    local path="$1"
    
    if ! command -v mypy &>/dev/null; then
        log_skip "mypy not installed"
        return 0
    fi
    
    log_info "Running mypy type checking on $path"
    mypy "$path" --ignore-missing-imports 2>&1
}

check_bash_syntax() {
    local file="$1"
    bash -n "$file" 2>&1
}

check_python_syntax() {
    local file="$1"
    python3 -m py_compile "$file" 2>&1
}

check_json_syntax() {
    local file="$1"
    if command -v jq &>/dev/null; then
        jq . "$file" >/dev/null 2>&1
    else
        python3 -m json.tool "$file" >/dev/null 2>&1
    fi
}

check_yaml_syntax() {
    local file="$1"
    if command -v yamllint &>/dev/null; then
        yamllint "$file" 2>&1
    elif command -v python3 &>/dev/null; then
        python3 -c "import yaml; yaml.safe_load(open('$file'))" 2>&1
    fi
}

check_xml_syntax() {
    local file="$1"
    if command -v xmllint &>/dev/null; then
        xmllint --noout "$file" 2>&1
    fi
}

run_syntax_check_all() {
    local path="$1"
    local errors=0
    
    log_subheader "Syntax Validation"
    
    # Check shell scripts
    while IFS= read -r -d '' file; do
        if ! check_bash_syntax "$file"; then
            log_fail "Syntax error: $file"
            ((errors++))
        fi
    done < <(find "$path" -name "*.sh" -type f -print0 2>/dev/null)
    
    # Check Python files
    while IFS= read -r -d '' file; do
        if ! check_python_syntax "$file"; then
            log_fail "Syntax error: $file"
            ((errors++))
        fi
    done < <(find "$path" -name "*.py" -type f -print0 2>/dev/null)
    
    # Check JSON files
    while IFS= read -r -d '' file; do
        if ! check_json_syntax "$file"; then
            log_fail "Syntax error: $file"
            ((errors++))
        fi
    done < <(find "$path" -name "*.json" -type f -print0 2>/dev/null)
    
    log_info "Syntax check complete: $errors errors"
    return $((errors > 0 ? 1 : 0))
}

analyze_code_complexity() {
    local file="$1"
    local max_complexity="${2:-10}"
    
    if [[ "$file" == *.py ]] && command -v radon &>/dev/null; then
        radon cc "$file" -a -s 2>/dev/null
    fi
}

check_code_duplication() {
    local path="$1"
    
    if command -v jscpd &>/dev/null; then
        jscpd "$path" --min-lines 5 --min-tokens 50 2>/dev/null
    fi
}

export -f run_shellcheck_analysis run_pylint_analysis run_mypy_analysis
export -f check_bash_syntax check_python_syntax check_json_syntax
export -f check_yaml_syntax check_xml_syntax run_syntax_check_all
export -f analyze_code_complexity check_code_duplication

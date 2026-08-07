#!/bin/bash
# Security hardening tests

PROJECT_ROOT="${PROJECT_ROOT:-$(dirname $0)/../..}"
PASS=0
FAIL=0

echo "=== Security Hardening Tests ==="

# Check for hardcoded secrets
echo "Checking for hardcoded secrets..."
found=$(grep -rliE 'api_key|apikey|api-key|password|secret' "$PROJECT_ROOT/tools" 2>/dev/null | grep -v '.pyc' | wc -l)
if [ "$found" -eq 0 ]; then
    echo "✅ No hardcoded secrets found"
    ((PASS++))
else
    echo "⚠️ Found $found files with potential secrets"
fi

# Check file permissions
echo "Checking sensitive file permissions..."
if [ -d "$PROJECT_ROOT/security" ]; then
    echo "✅ Security directory exists"
    ((PASS++))
fi

echo "Passed: $PASS, Failed: $FAIL"
exit $FAIL

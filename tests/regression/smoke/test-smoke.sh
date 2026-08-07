#!/bin/bash
# Smoke tests

PROJECT_ROOT="${PROJECT_ROOT:-$(dirname $0)/../../..}"
PASS=0
FAIL=0

echo "=== Smoke Tests ==="

# Test Python tools
echo "Testing Python tools..."
for tool in calculator tips worldclock; do
    toolpath="$PROJECT_ROOT/tools/sanchala-$tool/main.py"
    if [ -f "$toolpath" ]; then
        if python3 -m py_compile "$toolpath" 2>/dev/null; then
            echo "✅ sanchala-$tool OK"
            ((PASS++))
        else
            echo "❌ sanchala-$tool FAILED"
            ((FAIL++))
        fi
    fi
done

# Test shell scripts
echo "Testing shell scripts..."
if [ -d "$PROJECT_ROOT/scripts" ]; then
    for script in "$PROJECT_ROOT/scripts"/*.sh; do
        [ -f "$script" ] || continue
        if bash -n "$script" 2>/dev/null; then
            echo "✅ $(basename $script) OK"
            ((PASS++))
        else
            echo "❌ $(basename $script) FAILED"
            ((FAIL++))
        fi
    done
fi

echo "Passed: $PASS, Failed: $FAIL"
exit $FAIL

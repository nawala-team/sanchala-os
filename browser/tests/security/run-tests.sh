#!/bin/bash
# Security test suite for Sanchala Browser
# Copyright 2024 Sanchala OS Project

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BROWSER_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

PASS=0
FAIL=0

test_pass() { echo -e "${GREEN}✓ PASS${NC}: $1"; ((PASS++)); }
test_fail() { echo -e "${RED}✗ FAIL${NC}: $1"; ((FAIL++)); }

echo "========================================"
echo "Sanchala Browser Security Test Suite"
echo "========================================"
echo ""

# Test 1: DoH enabled by default
echo "Testing DNS over HTTPS..."
if grep -q "doh_enabled = true" "$BROWSER_DIR/config/sanchala.conf"; then
    test_pass "DoH enabled by default"
else
    test_fail "DoH not enabled by default"
fi

# Test 2: HTTPS-only mode
echo "Testing HTTPS-only mode..."
if grep -q "HTTPSOnlyMode=true" "$BROWSER_DIR/config/sanchala.conf"; then
    test_pass "HTTPS-only mode enabled"
else
    test_fail "HTTPS-only mode not enabled"
fi

# Test 3: Fingerprint protection
echo "Testing fingerprint protection..."
if grep -q "FingerprintProtection=true" "$BROWSER_DIR/config/sanchala.conf"; then
    test_pass "Fingerprint protection enabled"
else
    test_fail "Fingerprint protection not enabled"
fi

# Test 4: WebRTC IP leak protection
echo "Testing WebRTC protection..."
if grep -q "WebRTCIPHandlingPolicy=disable_non_proxied_udp" "$BROWSER_DIR/config/sanchala.conf"; then
    test_pass "WebRTC IP leak protection enabled"
else
    test_fail "WebRTC IP leak protection not enabled"
fi

# Test 5: Third-party cookie blocking
echo "Testing cookie blocking..."
if grep -q "ThirdPartyCookiesBlocked=true" "$BROWSER_DIR/config/sanchala.conf"; then
    test_pass "Third-party cookies blocked"
else
    test_fail "Third-party cookies not blocked"
fi

# Test 6: Site isolation
echo "Testing site isolation..."
if grep -q "StrictSiteIsolation=true" "$BROWSER_DIR/config/sanchala.conf"; then
    test_pass "Strict site isolation enabled"
else
    test_fail "Strict site isolation not enabled"
fi

# Test 7: Shield enabled
echo "Testing Shield..."
if grep -q "Enabled=true" "$BROWSER_DIR/config/sanchala.conf" | head -1; then
    test_pass "Shield enabled by default"
else
    test_fail "Shield not enabled"
fi

echo ""
echo "========================================"
echo "Results: ${GREEN}$PASS passed${NC}, ${RED}$FAIL failed${NC}"
echo "========================================"

exit $FAIL

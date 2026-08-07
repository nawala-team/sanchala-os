# 🔄 SANCHALA OS - CI Test Integration Specification

## Overview

This document specifies how the test framework integrates with GitHub Actions CI/CD pipeline.

## Workflow Integration

### Test Workflow: `.github/workflows/test.yml`

The test workflow uses the test framework with JUnit reporting:

```yaml
name: Tests
on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]
  schedule:
    - cron: '0 6 * * *'  # Daily at 6 AM UTC

jobs:
  unit-tests:
    name: Unit Tests
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Setup
        run: |
          sudo apt-get update
          sudo apt-get install -y shellcheck python3-yaml
      - name: Run Unit Tests
        run: ./tests/run-tests.sh --unit --junit unit-results.xml
      - uses: actions/upload-artifact@v4
        if: always()
        with:
          name: unit-test-results
          path: unit-results.xml

  integration-tests:
    name: Integration Tests
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Run Integration Tests
        run: ./tests/run-tests.sh --integration --junit integration-results.xml
      - uses: actions/upload-artifact@v4
        if: always()
        with:
          name: integration-test-results
          path: integration-results.xml

  security-tests:
    name: Security Tests
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Run Security Tests
        run: ./tests/run-tests.sh --security --junit security-results.xml
      - uses: actions/upload-artifact@v4
        if: always()
        with:
          name: security-test-results
          path: security-results.xml

  quality-gate:
    name: Quality Gate
    needs: [unit-tests, integration-tests, security-tests]
    runs-on: ubuntu-latest
    if: always()
    steps:
      - name: Check Results
        run: |
          [[ "${{ needs.unit-tests.result }}" == "success" ]] || exit 1
          [[ "${{ needs.integration-tests.result }}" == "success" ]] || exit 1
          [[ "${{ needs.security-tests.result }}" == "success" ]] || exit 1
          echo "✅ All quality gates passed"
```

## Test Artifacts

| Report | Purpose |
|--------|---------|
| unit-results.xml | Unit test JUnit report |
| integration-results.xml | Integration test report |
| security-results.xml | Security test report |

## Branch Protection

**Main Branch:**
- Required: unit-tests, integration-tests, security-tests, quality-gate
- Required reviews: 1

## Scheduled Tests

| Schedule | Tests |
|----------|-------|
| Daily 6 AM | Full suite |
| Weekly | Deep security scan |
| On tag | All + installation |

## Status Badge

```markdown
![Tests](https://github.com/user/sanchala-os/actions/workflows/test.yml/badge.svg)
```

---
_Maintainer: qa-lead + infra-architect_

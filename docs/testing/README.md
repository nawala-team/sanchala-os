# 🧪 SANCHALA OS - Testing Documentation

## Overview

This directory contains all testing documentation for Sanchala OS, including test procedures, quality gates, and hardware compatibility information.

## Documents

| Document | Description |
|----------|-------------|
| [TEST-STRATEGY.md](./TEST-STRATEGY.md) | Overall testing strategy and philosophy |
| [QUALITY-GATES.md](./QUALITY-GATES.md) | Release quality gate definitions |
| [HARDWARE-COMPATIBILITY.md](./HARDWARE-COMPATIBILITY.md) | Hardware compatibility matrix |
| [CI-TEST-INTEGRATION.md](./CI-TEST-INTEGRATION.md) | CI/CD test integration spec |

## Test Framework

The test framework is located at `/tests/` in the project root:

```
tests/
├── run-tests.sh        # Main test runner
├── config.sh           # Configuration
├── unit/               # Unit tests
├── integration/        # Integration tests
├── installation/       # Installation tests (VM)
├── security/           # Security validation
├── helpers/            # Test utilities
└── fixtures/           # Test data
```

## Quick Commands

```bash
# Run all tests
./tests/run-tests.sh

# Run specific category
./tests/run-tests.sh --unit
./tests/run-tests.sh --security

# Generate CI report
./tests/run-tests.sh --junit report.xml
```

## Quality Standards

Sanchala OS maintains high quality standards:

- **Unit Tests**: 100% pass required
- **Integration Tests**: 100% pass required  
- **Security Tests**: 100% pass required
- **Installation Tests**: Boot success required

## Contributing

See [CONTRIBUTING.md](/CONTRIBUTING.md) for guidelines on adding tests.

---

**Part of SANCHALA OS** | "Set Your System in Motion"

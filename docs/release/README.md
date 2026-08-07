# Sanchala OS Release Engineering

> Professional release process documentation for Sanchala OS

## Overview

This directory contains all documentation related to the Sanchala OS release process, including:

| Document | Description |
|----------|-------------|
| [RELEASE-CHECKLIST.md](RELEASE-CHECKLIST.md) | Pre-release checklist and sign-off procedures |
| [ISO-VERIFICATION.md](ISO-VERIFICATION.md) | Final ISO build verification steps |
| [VERSION-SCHEME.md](VERSION-SCHEME.md) | Semantic versioning and naming conventions |
| [RELEASE-CHANNELS.md](RELEASE-CHANNELS.md) | Stable, beta, and nightly channel specifications |
| [DISTRIBUTION-MIRRORS.md](DISTRIBUTION-MIRRORS.md) | Mirror infrastructure and CDN setup |
| [RELEASE-WORKFLOW.md](RELEASE-WORKFLOW.md) | End-to-end release automation workflow |

## Quick Reference

### Current Release Information

| Property | Value |
|----------|-------|
| **Codename** | Gati (गति) |
| **Version Format** | `MAJOR.MINOR.PATCH` |
| **Release Cycle** | 6 months (stable) |
| **Support Period** | 12 months per release |

### Release Channels

```
┌─────────────────────────────────────────────────────────────┐
│                    RELEASE CHANNELS                         │
├─────────────────────────────────────────────────────────────┤
│  NIGHTLY ──► BETA ──► RELEASE CANDIDATE ──► STABLE         │
│    │          │              │                 │            │
│  Daily    2-4 weeks      1-2 weeks         6 months        │
│  builds   testing        final QA          supported       │
└─────────────────────────────────────────────────────────────┘
```

### Key Contacts

| Role | Responsibility |
|------|----------------|
| Release Manager | Coordinates release timeline and sign-offs |
| QA Lead | Approves test results and quality gates |
| Security Lead | Signs off on security audit results |
| Infrastructure | Manages mirrors and distribution |

## Release Process Summary

1. **Feature Freeze** - No new features, only bug fixes
2. **Code Freeze** - Only critical fixes allowed
3. **Release Candidate** - Final testing period
4. **Release** - Public distribution
5. **Post-Release** - Monitoring and hotfix preparation

## Related Resources

- [Build Infrastructure](../infrastructure/)
- [Security Documentation](../security/)
- [Testing Framework](../testing/)

---

*संञ्चल - Set Your System in Motion*

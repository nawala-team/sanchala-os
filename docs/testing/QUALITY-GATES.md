# 🚦 SANCHALA OS - Quality Gates

## Overview

Quality gates define the minimum requirements that must be met before code can progress through the development pipeline. These gates ensure consistent quality and security.

---

## Gate 1: Pull Request (Pre-Merge)

### Automated Checks (Required)
| Check | Requirement | Blocking |
|-------|-------------|----------|
| Unit Tests | 100% pass | ✅ Yes |
| Integration Tests | 100% pass | ✅ Yes |
| Security Tests | 100% pass | ✅ Yes |
| Shell Syntax | No errors | ✅ Yes |
| YAML/JSON Valid | No parse errors | ✅ Yes |
| ShellCheck | No errors (warnings OK) | ⚠️ Advisory |

### Manual Checks (Required for security changes)
- [ ] Code review by maintainer
- [ ] Security review for auth/crypto changes
- [ ] Documentation updated

---

## Gate 2: Main Branch Integration

### Automated Checks
| Check | Requirement | Blocking |
|-------|-------------|----------|
| All PR Gate 1 checks | Pass | ✅ Yes |
| Package List Validation | All packages exist | ⚠️ Advisory |
| PKGBUILD Validation | namcap passes | ⚠️ Advisory |
| Secret Scanning | No secrets detected | ✅ Yes |

### ISO Build (Nightly)
- [ ] ISO builds successfully
- [ ] ISO size within limits (<4GB)
- [ ] Checksums generated

---

## Gate 3: Release Candidate

### Automated Checks
| Check | Requirement | Blocking |
|-------|-------------|----------|
| All Gate 2 checks | Pass | ✅ Yes |
| ISO Boot Test (QEMU BIOS) | Boots to desktop | ✅ Yes |
| ISO Boot Test (QEMU UEFI) | Boots to desktop | ✅ Yes |
| Security Scan | No critical issues | ✅ Yes |
| SBOM Generated | Valid SBOM | ✅ Yes |

### Manual Checks
- [ ] Installation test on physical hardware
- [ ] All critical features functional
- [ ] No regression from previous release
- [ ] Release notes prepared

---

## Gate 4: Production Release

### Requirements
| Check | Requirement |
|-------|-------------|
| RC Testing Period | Minimum 48 hours |
| Community Testing | No critical bugs reported |
| Security Audit | Completed for major releases |
| Documentation | User guide updated |

### Sign-off Required From
- [ ] QA Lead (qa-lead)
- [ ] Security Architect (security-architect)
- [ ] PM Lead (pm-lead)

---

## Quality Metrics

### Test Pass Rates
| Category | Minimum | Target |
|----------|---------|--------|
| Unit Tests | 100% | 100% |
| Integration Tests | 100% | 100% |
| Security Tests | 100% | 100% |
| Installation Tests | 95% | 100% |

### Response Times
| Issue Type | Response SLA | Resolution Target |
|------------|--------------|-------------------|
| Critical Security | 4 hours | 24 hours |
| High Severity Bug | 24 hours | 72 hours |
| Medium Bug | 48 hours | 1 week |
| Low Bug | 1 week | 2 weeks |

---

## Exceptions Process

Quality gate exceptions require:
1. Written justification
2. Risk assessment
3. Mitigation plan
4. Approval from 2+ maintainers
5. Documented in release notes

---

## Gate Bypass (Emergency Only)

For critical security fixes:
1. Document the emergency
2. Get PM Lead approval
3. Deploy fix
4. Complete full testing within 24 hours
5. Post-mortem required

---

_Maintainer: qa-lead_  
_Last Updated: Phase 1_

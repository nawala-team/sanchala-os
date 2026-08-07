# Sanchala OS Version Numbering Scheme

> Semantic versioning and release naming conventions

## Overview

Sanchala OS follows [Semantic Versioning 2.0.0](https://semver.org/) with additional conventions for codenames and build metadata.

---

## Version Format

```
MAJOR.MINOR.PATCH[-PRERELEASE][+BUILD]

Examples:
  1.0.0                    # Stable release
  1.1.0-beta.1             # Beta pre-release
  1.1.0-rc.2               # Release candidate
  1.0.1+20240815           # Patch with build date
  2024.08.15               # Rolling/nightly format
```

---

## Version Components

### MAJOR Version

Increment when:
- Incompatible changes to system architecture
- Major desktop environment changes
- Breaking changes to default configurations
- Significant base system updates (new Arch snapshot)

Examples: `1.0.0` → `2.0.0`

### MINOR Version

Increment when:
- New features added (backward-compatible)
- New bundled applications
- Desktop environment updates
- Kernel version updates
- Security hardening improvements

Examples: `1.0.0` → `1.1.0`

### PATCH Version

Increment when:
- Bug fixes only
- Security patches
- Documentation updates
- Translation updates
- Minor configuration tweaks

Examples: `1.0.0` → `1.0.1`

---

## Pre-release Identifiers

### Alpha (`-alpha.N`)

- Early development builds
- Features incomplete
- Not for general use
- Internal testing only

```
1.1.0-alpha.1
1.1.0-alpha.2
```

### Beta (`-beta.N`)

- Feature complete
- Known bugs exist
- Community testing welcome
- Not production ready

```
1.1.0-beta.1
1.1.0-beta.2
```

### Release Candidate (`-rc.N`)

- Production ready candidate
- Final testing phase
- Bug fixes only
- No new features

```
1.1.0-rc.1
1.1.0-rc.2
```

---

## Build Metadata

Build metadata is appended with `+` and does not affect version precedence:

```
1.0.0+20240815           # Build date
1.0.0+build.1234         # CI build number
1.0.0+git.abc1234        # Git commit
1.0.0-beta.1+20240815    # Pre-release with date
```

---

## Codenames

Each major release has a Sanskrit-derived codename following the theme of "motion/movement":

| Version | Codename | Sanskrit | Meaning |
|---------|----------|----------|---------|
| 1.x | Gati | गति | Movement, motion |
| 2.x | Vega | वेग | Speed, velocity |
| 3.x | Chala | चल | Moving, dynamic |
| 4.x | Pravaha | प्रवाह | Flow, current |
| 5.x | Gaman | गमन | Journey, progress |

Codename appears in:
- ISO filename: `sanchala-1.0.0-gati-x86_64.iso`
- Boot screen branding
- `/etc/sanchala-release`
- Welcome application

---

## Rolling vs Point Release

### Rolling Releases (Nightly/Beta)

Use date-based versioning:

```
2024.08.15              # Date format
2024.08.15-nightly      # Explicit nightly
2024.08.15-beta         # Beta channel
```

### Point Releases (Stable)

Use semantic versioning:

```
1.0.0                   # Initial stable
1.0.1                   # Patch release
1.1.0                   # Feature release
2.0.0                   # Major release
```

---

## Version Precedence

Versions are compared according to SemVer rules:

```
1.0.0-alpha.1 < 1.0.0-alpha.2 < 1.0.0-beta.1 < 1.0.0-rc.1 < 1.0.0
```

Pre-release versions have lower precedence than normal versions:

```
1.0.0-alpha < 1.0.0-beta < 1.0.0-rc < 1.0.0 < 1.0.1
```

---

## Version Files

### /etc/sanchala-release

```bash
SANCHALA_VERSION="1.0.0"
SANCHALA_CODENAME="gati"
SANCHALA_BUILD_DATE="2024-08-15"
SANCHALA_CHANNEL="stable"
```

### /etc/os-release

```ini
NAME="Sanchala OS"
VERSION="1.0.0 (Gati)"
ID=sanchala
ID_LIKE=arch
VERSION_ID=1.0.0
VERSION_CODENAME=gati
PRETTY_NAME="Sanchala OS 1.0.0 (Gati)"
HOME_URL="https://sanchala.id"
SUPPORT_URL="https://sanchala.id/support"
BUG_REPORT_URL="https://github.com/sanchala-os/sanchala-os/issues"
```

---

## Version Automation

### Git Tags

```bash
# Stable release
git tag -s v1.0.0 -m "Release 1.0.0 (Gati)"

# Pre-release
git tag -s v1.1.0-beta.1 -m "Beta 1.1.0-beta.1"

# Push tags
git push origin v1.0.0
```

### CI Version Detection

```yaml
# .github/workflows/build-iso.yml
- name: Determine version
  run: |
    if [[ "$GITHUB_REF" == refs/tags/v* ]]; then
      VERSION="${GITHUB_REF#refs/tags/v}"
    else
      VERSION="$(date +%Y.%m.%d)-$(git rev-parse --short HEAD)"
    fi
    echo "VERSION=$VERSION" >> $GITHUB_ENV
```

---

## Summary

| Channel | Format | Example |
|---------|--------|---------|
| Stable | `MAJOR.MINOR.PATCH` | `1.0.0` |
| Beta | `MAJOR.MINOR.PATCH-beta.N` | `1.1.0-beta.2` |
| RC | `MAJOR.MINOR.PATCH-rc.N` | `1.1.0-rc.1` |
| Nightly | `YYYY.MM.DD-nightly` | `2024.08.15-nightly` |

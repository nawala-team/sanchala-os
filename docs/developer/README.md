# Developer Documentation

Welcome to the Sanchala OS Developer Documentation. This section is for contributors and developers.

---

## Getting Started

1. **[Development Setup](SETUP.md)** — Set up your development environment
2. **[Contributing Guide](../../CONTRIBUTING.md)** — Contribution guidelines
3. **[Architecture](../ARCHITECTURE.md)** — System architecture overview

---

## Development Areas

### Core System

- [ISO Building](../building/ISO-BUILD.md)
- [Package Building](../building/PKGBUILD-GUIDE.md)
- [Kernel Configuration](../kernel/README.md)

### Custom Tools

- [Sanchala Guardian](../tools/sanchala-guardian.md)
- [Sanchala Store](../tools/sanchala-store.md)
- [Sanchala Welcome](../tools/sanchala-welcome.md)
- [Sanchala Permissions](../tools/sanchala-permissions.md)

### Desktop

- [KDE Configuration](../settings/DEFAULT-SETTINGS.md)
- [Control Center](../settings/CONTROL-CENTER-SPEC.md)
- [Theming](../../branding/BRANDING.md)

### Security

- [Security Architecture](../security/SECURITY.md)
- [AppArmor Profiles](../security/SECURITY.md#layer-7-application-security)
- [Threat Model](../security/THREAT-MODEL.md)

### Infrastructure

- [CI/CD Pipeline](../infrastructure/CI-CD.md)
- [Repository Management](../infrastructure/REPOSITORY-SERVER.md)
- [Mirror Network](../infrastructure/MIRRORS.md)

---

## Quick Reference

### Build Commands

```bash
# Build ISO
./scripts/build-iso.sh

# Build single package
cd packages/<name> && makepkg -s

# Build all packages
./scripts/build-packages.sh

# Run tests
./scripts/test.sh
```

### Code Quality

```bash
# Lint shell scripts
shellcheck scripts/*.sh

# Lint Python
ruff check tools/
black --check tools/

# Check PKGBUILD
namcap packages/*/PKGBUILD
```

---

## Resources

- [Arch Wiki](https://wiki.archlinux.org)
- [KDE Developer Documentation](https://develop.kde.org)
- [Flatpak Documentation](https://docs.flatpak.org)

---

**Last Updated:** August 2026

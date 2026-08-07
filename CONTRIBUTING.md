# Contributing to Sanchala OS

Thank you for your interest in contributing to Sanchala OS! This guide will help you get started.

---

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Ways to Contribute](#ways-to-contribute)
- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Commit Guidelines](#commit-guidelines)
- [Pull Request Process](#pull-request-process)
- [Coding Standards](#coding-standards)
- [Security Issues](#security-issues)

---

## Code of Conduct

By participating in this project, you agree to abide by our [Code of Conduct](CODE_OF_CONDUCT.md). Please read it before contributing.

---

## Ways to Contribute

### 🐛 Report Bugs

Found a bug? Open an issue with:
- Clear, descriptive title
- Steps to reproduce
- Expected vs actual behavior
- System information (run `sanchala-info` or provide manually)
- Screenshots if applicable

### 💡 Suggest Features

Have an idea? We would love to hear it:
- Check existing issues first to avoid duplicates
- Describe the problem your feature solves
- Explain your proposed solution
- Consider alternatives you have thought about

### 📖 Improve Documentation

Documentation improvements are always welcome:
- Fix typos and grammar
- Clarify confusing sections
- Add missing information
- Translate documentation

### 🔧 Contribute Code

Ready to code? See [Getting Started](#getting-started) below.

### 🧪 Test & QA

Help us ensure quality:
- Test new releases on different hardware
- Report hardware compatibility issues
- Verify bug fixes

### 🎨 Design

Contribute to our visual identity:
- UI/UX improvements
- Icon design
- Wallpapers and themes

---

## Getting Started

### Prerequisites

- Git
- Arch Linux or Sanchala OS (for building/testing)
- Basic familiarity with shell scripting, pacman, and KDE Plasma

### Fork & Clone

```bash
# Fork the repository on GitHub, then:
git clone https://github.com/YOUR_USERNAME/sanchala-os.git
cd sanchala-os

# Add upstream remote
git remote add upstream https://github.com/nicholaslourdes/sanchala-os.git

# Verify remotes
git remote -v
```

### Project Structure

```
sanchala-os/
├── branding/          # Logos, wallpapers, visual assets
├── configs/           # System configuration files
├── docs/              # Documentation
├── installer/         # Calamares installer customization
├── iso/               # ISO build scripts (archiso)
├── packages/          # Custom package definitions
├── scripts/           # Build and utility scripts
└── tools/             # Sanchala custom applications
```

### Development Environment Setup

```bash
# Install development dependencies
sudo pacman -S base-devel git archiso devtools namcap

# For KDE/Qt development
sudo pacman -S qt6-base qt6-tools extra-cmake-modules

# Set up pre-commit hooks (recommended)
./scripts/setup-dev.sh
```

---

## Development Workflow

### Branch Naming

Use descriptive branch names with prefixes:

| Prefix | Purpose | Example |
|--------|---------|--------|
| `feature/` | New features | `feature/dark-mode-schedule` |
| `fix/` | Bug fixes | `fix/wifi-reconnect-issue` |
| `docs/` | Documentation | `docs/installation-guide` |
| `refactor/` | Code refactoring | `refactor/guardian-config` |

### Keep Your Fork Updated

```bash
git fetch upstream
git checkout main
git merge upstream/main
```

---

## Commit Guidelines

We follow [Conventional Commits](https://www.conventionalcommits.org/) specification.

### Format

```
<type>(<scope>): <description>

[optional body]

[optional footer(s)]
```

### Types

| Type | Description |
|------|-------------|
| `feat` | New feature |
| `fix` | Bug fix |
| `docs` | Documentation changes |
| `style` | Formatting, no code change |
| `refactor` | Code restructuring |
| `perf` | Performance improvement |
| `test` | Adding tests |
| `chore` | Build process, tools |
| `security` | Security improvements |

### Examples

```bash
git commit -m "feat(guardian): add real-time threat detection"
git commit -m "fix(installer): resolve LUKS password prompt loop"
git commit -m "docs(readme): update installation requirements"
```

---

## Pull Request Process

### Before Submitting

1. **Update your branch** with the latest upstream changes
2. **Test your changes** thoroughly
3. **Run linters** if applicable
4. **Update documentation** if needed
5. **Add tests** for new functionality

### PR Checklist

- [ ] Branch is up-to-date with `main`
- [ ] Commits follow our guidelines
- [ ] Code follows project style
- [ ] Tests pass locally
- [ ] Documentation updated (if applicable)
- [ ] No merge conflicts

### Review Process

1. Maintainers will review within 1-2 weeks
2. Address feedback promptly
3. Keep discussions constructive
4. Squash commits if requested before merge

---

## Coding Standards

### Shell Scripts (Bash)

```bash
#!/usr/bin/env bash
set -euo pipefail

readonly CONFIG_DIR="/etc/sanchala"
local user_input=""

echo "${variable}"

if [[ -f "${file}" ]]; then
    # ...
fi
```

Run `shellcheck` on all shell scripts.

### Python

- Follow PEP 8
- Use type hints (Python 3.9+)
- Format with `black`
- Lint with `ruff` or `flake8`

### PKGBUILD

- Follow [Arch packaging standards](https://wiki.archlinux.org/title/Arch_package_guidelines)
- Run `namcap` to check for issues
- Include `.SRCINFO`

---

## Security Issues

**Do not open public issues for security vulnerabilities.**

Instead, please email: **security@sanchala.id**

Include:
- Description of the vulnerability
- Steps to reproduce
- Potential impact
- Suggested fix (if any)

We will respond within 48 hours.

---

## Getting Help

| Channel | Purpose |
|---------|--------|
| [GitHub Discussions](https://github.com/nicholaslourdes/sanchala-os/discussions) | Questions, ideas |
| [Forum](https://forum.sanchala.id) | Community support |
| Email: contribute@sanchala.id | Direct questions |

---

## License

By contributing, you agree that your contributions will be licensed under the [GPL v3.0](LICENSE) license.

---

<div align="center">

**Thank you for helping make Sanchala OS better!** 🙏

</div>

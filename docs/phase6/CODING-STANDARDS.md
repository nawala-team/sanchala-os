# Sanchala OS - Coding Standards

**Version:** 6.0.0  
**Authority:** Chief Architect  

---

## 1. General Principles

- **Zero Bugs Policy**: All code must be production-ready
- **No TODOs or Placeholders**: Complete implementation only
- **Security First**: Assume all input is hostile
- **Consistent Naming**: `sanchala-*` prefix for all tools

---

## 2. Python Standards (GUI Tools)

### 2.1 Version & Header

```python
#!/usr/bin/env python3
# SPDX-License-Identifier: GPL-3.0-or-later
# Copyright (c) 2025 Sanchala OS Project

"""Module docstring describing purpose."""

from __future__ import annotations
import sys
from typing import Optional, List, Dict, Any
```

- Minimum: Python 3.11
- Type hints: MANDATORY for all functions

### 2.2 Naming Conventions

```python
# Classes: PascalCase
class SanchalaSettingsWindow:
    pass

# Functions/methods: snake_case
def get_system_config() -> dict:
    pass

# Constants: UPPER_SNAKE_CASE
DEFAULT_CONFIG_PATH = "/etc/sanchala/sanchala.conf"

# Private: leading underscore
def _internal_helper() -> None:
    pass
```

### 2.3 Import Order

```python
# 1. Standard library
import os
import sys
from pathlib import Path

# 2. Third-party packages
from PyQt6.QtWidgets import QMainWindow, QApplication
from PyQt6.QtCore import Qt, QTimer

# 3. Sanchala libraries
from sanchala.core import config, logging
from sanchala.ui import widgets
```

### 2.4 PyQt6 Standards

```python
from PyQt6.QtWidgets import QMainWindow, QWidget, QVBoxLayout
from PyQt6.QtCore import Qt, pyqtSignal, pyqtSlot


class SanchalaMainWindow(QMainWindow):
    """Main application window."""
    
    config_changed = pyqtSignal(str, object)
    
    def __init__(self, parent: Optional[QWidget] = None) -> None:
        super().__init__(parent)
        self._setup_ui()
        self._connect_signals()
    
    def _setup_ui(self) -> None:
        """Initialize UI components."""
        self.setWindowTitle("Sanchala Settings")

### 2.5 Error Handling

```python
from sanchala.core.exceptions import SanchalaError, SanchalaConfigError


def load_config(path: Path) -> dict:
    """Load configuration from file."""
    try:
        with open(path, 'r', encoding='utf-8') as f:
            return toml.load(f)
    except FileNotFoundError:
        raise SanchalaConfigError(
            f"Configuration file not found: {path}",
            error_code=10
        )
```

---

## 3. Bash Standards (CLI Tools)

### 3.1 Script Header

```bash
#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-3.0-or-later
# Copyright (c) 2025 Sanchala OS Project
#
# sanchala-update - System update utility

set -euo pipefail
IFS=$'\n\t'

readonly SCRIPT_NAME="${0##*/}"
readonly SCRIPT_VERSION="6.0.0"
readonly CONFIG_DIR="/etc/sanchala"
readonly LOG_FILE="/var/log/sanchala/${SCRIPT_NAME}.log"
```

### 3.2 Function Standards

```bash
# Install a package
# Arguments: $1 - package_name
# Returns: 0 on success, 30 on failure
install_package() {
    local package_name="${1:?Package name required}"
    
    log_info "Installing package: ${package_name}"
    
    if ! pacman -S --noconfirm "${package_name}"; then
        log_error "Failed to install: ${package_name}"
        return 30
    fi
    return 0
}
```

### 3.3 Logging Functions

```bash
log_info()  { printf '[%s] [INFO] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*" | tee -a "${LOG_FILE}"; }
log_warn()  { printf '[%s] [WARN] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*" | tee -a "${LOG_FILE}" >&2; }
log_error() { printf '[%s] [ERROR] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*" | tee -a "${LOG_FILE}" >&2; }
```

### 3.4 Error Handling

```bash
readonly ERR_GENERAL=1
readonly ERR_INVALID_ARG=2
readonly ERR_CONFIG=10
readonly ERR_NETWORK=20
readonly ERR_PACKAGE=30
readonly ERR_SECURITY=40
readonly ERR_IO=50

die() {
    log_error "${2:-Unknown error}"
    exit "${1:-1}"
}

cleanup() {
    local exit_code=$?
    [[ -n "${TEMP_DIR:-}" ]] && rm -rf "${TEMP_DIR}"
    exit "${exit_code}"
}
trap cleanup EXIT INT TERM
```

### 3.5 Input Validation

```bash
validate_package_name() {
    local name="$1"
    [[ "${name}" =~ ^[a-zA-Z0-9@._+-]+$ ]] || \
        die "${ERR_INVALID_ARG}" "Invalid package name: ${name}"
}

validate_path() {
    local path="$1"
    [[ "${path}" != *".."* ]] || \
        die "${ERR_SECURITY}" "Path traversal detected: ${path}"
}
```

---

## 4. Logging Standards

| Level | Usage |
|-------|-------|
| DEBUG | Detailed debugging information |
| INFO | Normal operational messages |
| WARN | Warning conditions |
| ERROR | Error conditions |

Log location: `/var/log/sanchala/`

---

## 5. Security Requirements

1. **Input Validation**: ALL external input must be validated
2. **Path Sanitization**: Prevent path traversal attacks
3. **Privilege Separation**: Minimize root operations
4. **No Shell Injection**: Never pass unsanitized input to shell

### Forbidden Patterns

```python
# FORBIDDEN
os.system(f"pacman -S {user_input}")

# CORRECT
subprocess.run(["pacman", "-S", validated_package], check=True)
```

```bash
# FORBIDDEN
rm -rf $user_path

# CORRECT
validate_path "${user_path}"
rm -rf "${user_path}"
```

---

*All code MUST comply with these standards. Non-compliant code will be rejected.*

        self.setMinimumSize(800, 600)
        
        central = QWidget()
        self.setCentralWidget(central)
        layout = QVBoxLayout(central)
        layout.setContentsMargins(16, 16, 16, 16)
    
    def _connect_signals(self) -> None:
        """Connect all signal/slot connections."""
        self.config_changed.connect(self._on_config_changed)
    
    @pyqtSlot(str, object)
    def _on_config_changed(self, key: str, value: object) -> None:
        """Handle configuration changes."""
        pass
```


# Sanchala OS - API Conventions

**Version:** 6.0.0  
**Authority:** Chief Architect  

---

## 1. D-Bus API Design

### 1.1 Bus Naming

```
System Bus:  org.sanchala.<Component>
Object Paths: /org/sanchala/<Component>/<Resource>
Interfaces:   org.sanchala.<Component>.<Interface>
```

### 1.2 Standard Interface

Every Sanchala D-Bus service MUST implement:

```xml
<interface name="org.sanchala.Common">
    <method name="GetVersion">
        <arg type="s" direction="out" name="version"/>
    </method>
    <property name="Version" type="s" access="read"/>
    <signal name="StatusChanged">
        <arg type="s" name="status"/>
    </signal>
</interface>
```

### 1.3 Method Conventions

- Use verbs for actions: `Install`, `Remove`, `Update`
- Use `Get*` for queries: `GetInfo`, `GetStatus`
- Use `List*` for collections: `ListInstalled`

### 1.4 D-Bus Errors

```
org.sanchala.Error.NotFound
org.sanchala.Error.PermissionDenied
org.sanchala.Error.InvalidArgument
org.sanchala.Error.NetworkError
```

---

## 2. Python API Design

### 2.1 Exception Hierarchy

```python
class SanchalaError(Exception):
    """Base exception for all Sanchala errors."""
    def __init__(self, message: str, error_code: int = 1) -> None:
        super().__init__(message)
        self.error_code = error_code

class SanchalaConfigError(SanchalaError): pass   # 10-19
class SanchalaNetworkError(SanchalaError): pass  # 20-29
class SanchalaPackageError(SanchalaError): pass  # 30-39
class SanchalaSecurityError(SanchalaError): pass # 40-49
class SanchalaIOError(SanchalaError): pass       # 50-59
```

### 2.2 Configuration API

```python
from sanchala.core.config import ConfigManager

config = ConfigManager.get_instance()
theme = config.get("appearance.theme", default="breeze")
config.set("appearance.theme", "breeze-dark")
config.save()
```

---

## 3. CLI API Design

### 3.1 Command Structure

```
sanchala-<tool> [GLOBAL_OPTIONS] <command> [ARGS]

Examples:
  sanchala-update check
  sanchala-backup create --encrypt /home
  sanchala-store search firefox
```

### 3.2 Standard Global Options

```
-h, --help          Show help message
-v, --version       Show version
-c, --config FILE   Alternate config file
-q, --quiet         Suppress non-error output
--json              Output in JSON format
```

### 3.3 Exit Codes

| Code | Meaning |
|------|---------|
| 0 | Success |
| 1 | General error |
| 2 | Invalid arguments |
| 10-19 | Configuration errors |
| 20-29 | Network errors |
| 30-39 | Package errors |
| 40-49 | Security errors |
| 50-59 | I/O errors |

### 3.4 JSON Output Format

```json
{
    "success": true,
    "data": { },
    "error": null
}
```

---

## 4. Signal Patterns

### 4.1 PyQt6 Signals

```python
from PyQt6.QtCore import pyqtSignal, QObject

class PackageManager(QObject):
    install_started = pyqtSignal(str)
    install_progress = pyqtSignal(str, int)
    install_finished = pyqtSignal(str, bool)
```

### 4.2 Async Workers

```python
from PyQt6.QtCore import QThread, pyqtSignal

class UpdateWorker(QThread):
    progress = pyqtSignal(int, str)
    finished = pyqtSignal(bool, str)
    
    def run(self) -> None:
        self.progress.emit(0, "Starting...")
        # ... work
        self.finished.emit(True, "Complete")
```

---

*All APIs MUST follow these conventions for consistency.*


### 2.3 Logging API

```python
from sanchala.core.logging import get_logger

log = get_logger("sanchala-settings")
log.info("Operation completed")
log.error("Error occurred", exc_info=True)
```


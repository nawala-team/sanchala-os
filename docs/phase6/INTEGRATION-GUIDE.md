# Sanchala OS - Integration Guide

**Version:** 6.0.0  
**Authority:** Chief Architect  

---

## 1. Tool Integration Overview

```
┌─────────────┐     D-Bus      ┌─────────────┐
│ GUI Tools   │◀──────────────▶│  Daemon     │
└─────────────┘                └─────────────┘
       │                              │
       │ Config API                   │ System API
       ▼                              ▼
┌─────────────┐                ┌─────────────┐
│ libsanchala │                │   pacman    │
└─────────────┘                └─────────────┘
```

---

## 2. D-Bus Integration

### 2.1 Connecting to Daemon

```python
import dbus

system_bus = dbus.SystemBus()
daemon = system_bus.get_object(
    'org.sanchala.Daemon',
    '/org/sanchala/Daemon'
)
daemon_iface = dbus.Interface(daemon, 'org.sanchala.Daemon.System')
status = daemon_iface.GetStatus()
```

### 2.2 PolicyKit Authentication

```python
from gi.repository import Polkit

def check_authorization(action_id: str) -> bool:
    authority = Polkit.Authority.get_sync()
    subject = Polkit.UnixProcess.new_for_owner(os.getpid(), 0, -1)
    result = authority.check_authorization_sync(
        subject, action_id, None,
        Polkit.CheckAuthorizationFlags.ALLOW_USER_INTERACTION, None
    )
    return result.get_is_authorized()
```

---

## 3. Shared Library Usage

```python
from sanchala.core import config, logging, validation
from sanchala.ui.base import SanchalaMainWindow

# Configuration
cfg = config.ConfigManager.get_instance()
theme = cfg.get("appearance.theme", "breeze")

# Logging  
log = logging.get_logger("my-tool")

# Validation
validation.validate_package_name(user_input)
```

---

## 4. KDE Plasma Integration

### 4.1 Notifications

```python
from PyQt6.QtDBus import QDBusConnection, QDBusMessage

---

## 5. Arch Linux Packaging

### 5.1 PKGBUILD Template

```bash
# Maintainer: Sanchala OS Team
pkgname=sanchala-welcome
pkgver=6.0.0
pkgrel=1
pkgdesc="Sanchala OS Welcome Application"
arch=('x86_64' 'aarch64')
license=('GPL3')
depends=('python>=3.11' 'python-pyqt6' 'libsanchala-core')
makedepends=('python-build' 'python-installer')
source=("${pkgname}-${pkgver}.tar.gz")
sha256sums=('SKIP')

build() {
    cd "${pkgname}-${pkgver}"
    python -m build --wheel --no-isolation
}

package() {
    cd "${pkgname}-${pkgver}"
    python -m installer --destdir="${pkgdir}" dist/*.whl
    install -Dm644 "data/${pkgname}.desktop" \
        "${pkgdir}/usr/share/applications/${pkgname}.desktop"
}
```

### 5.2 Desktop Entry Template

```ini
[Desktop Entry]
Version=1.0
Type=Application
Name=Sanchala Welcome
Exec=sanchala-welcome
Icon=sanchala-welcome
Terminal=false
Categories=System;Settings;
```

---

## 6. Cross-Tool Communication

### 6.1 Signals

```python
# Daemon emits
self.UpdateAvailable("linux", "6.7.0")

# Tools listen
bus.add_signal_receiver(
    self.on_update_available,
    signal_name="UpdateAvailable",
    dbus_interface="org.sanchala.Daemon.Update"
)
```

### 6.2 Shared State

```
/var/lib/sanchala/
├── state.json      # Shared state
├── locks/          # Lock files
└── cache/          # Shared cache
```

---

*Follow this guide for seamless integration across all Sanchala tools.*


def send_notification(title: str, body: str) -> None:
    bus = QDBusConnection.sessionBus()
    msg = QDBusMessage.createMethodCall(
        "org.freedesktop.Notifications",
        "/org/freedesktop/Notifications", 
        "org.freedesktop.Notifications", "Notify"
    )
    msg.setArguments(["Sanchala", 0, "sanchala", title, body, [], {}, 5000])
    bus.call(msg)
```

### 4.2 Theme Compliance

```python
from PyQt6.QtWidgets import QApplication
from PyQt6.QtGui import QPalette, QIcon

# Respect system colors
palette = QApplication.palette()
bg_color = palette.color(QPalette.ColorRole.Window)

# Use standard icons
icon = QIcon.fromTheme("package-install")
```


# Plasmoid Development Guidelines

## Overview

Plasmoids (Plasma widgets) are the primary way to extend the SANCHALA desktop. This guide covers best practices for creating high-quality, secure widgets.

## Quick Start

### 1. Create Project Structure

```bash
mkdir -p org.sanchala.mywidget/contents/{ui,config,code}
cd org.sanchala.mywidget
```

### 2. Create metadata.json

```json
{
    "KPlugin": {
        "Id": "org.sanchala.mywidget",
        "Name": "My Widget",
        "Description": "A sample widget",
        "Icon": "preferences-system",
        "Authors": [{"Name": "Your Name", "Email": "you@example.com"}],
        "Category": "Utilities",
        "License": "GPL-3.0",
        "Version": "1.0.0"
    },
    "X-Plasma-API": "declarativeappletscript",
    "X-Plasma-MainScript": "ui/main.qml",
    "KPackageStructure": "Plasma/Applet",
    "X-Sanchala-Permissions": ["notifications"]
}
```

### 3. Create main.qml

```qml
import QtQuick 2.15
import QtQuick.Layouts 1.15
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.kirigami 2.20 as Kirigami

PlasmoidItem {
    id: root
    
    compactRepresentation: Kirigami.Icon {
        source: "preferences-system"
        MouseArea {
            anchors.fill: parent
            onClicked: root.expanded = !root.expanded
        }
    }
    
    fullRepresentation: ColumnLayout {
        Layout.preferredWidth: 300
        Layout.preferredHeight: 200
        
        PlasmaComponents.Label {
            text: "Hello from My Widget!"
            Layout.alignment: Qt.AlignCenter
        }
    }
    
    preferredRepresentation: compactRepresentation
}
```

### 4. Test & Package

```bash
# Test in plasmoidviewer
plasmoidviewer -a ./org.sanchala.mywidget

# Package for distribution
sanchala-extensions pack ./org.sanchala.mywidget
```

## Design Guidelines

### Visual Consistency

- Use `Kirigami.Theme` colors, not hardcoded values
- Follow 8px grid spacing (`Kirigami.Units.smallSpacing`)
- Use standard Plasma components for controls
- Support both light and dark themes

### Sizing

```qml
// Compact: icon-sized for panel
compactRepresentation: Item {
    implicitWidth: Kirigami.Units.iconSizes.medium
    implicitHeight: Kirigami.Units.iconSizes.medium
}

// Full: reasonable popup size
fullRepresentation: Item {
    Layout.preferredWidth: Kirigami.Units.gridUnit * 20
    Layout.preferredHeight: Kirigami.Units.gridUnit * 15
    Layout.minimumWidth: Kirigami.Units.gridUnit * 12
}
```

### Configuration

Create `contents/config/main.xml`:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<kcfg xmlns="http://www.kde.org/standards/kcfg/1.0">
    <kcfgfile name=""/>
    <group name="General">
        <entry name="refreshInterval" type="Int">
            <default>30</default>
        </entry>
        <entry name="showLabel" type="Bool">
            <default>true</default>
        </entry>
    </group>
</kcfg>
```

Access in QML:
```qml
Plasmoid.configuration.refreshInterval
Plasmoid.configuration.showLabel
```

## Best Practices

### Performance

```qml
// ✓ Use Loader for conditional content
Loader {
    active: someCondition
    sourceComponent: HeavyComponent {}
}

// ✓ Use shader effects sparingly
// ✓ Avoid binding loops
// ✓ Use NumberAnimation for smooth transitions
```

### Security

```qml
// ✓ Validate external data
function parseData(json) {
    try {
        return JSON.parse(json)
    } catch (e) {
        console.warn("Invalid data")
        return null
    }
}

// ✗ Never use eval() or Qt.createQmlObject with untrusted input
```

### Accessibility

```qml
PlasmaComponents.Button {
    text: "Settings"
    Accessible.name: "Open widget settings"
    Accessible.description: "Opens configuration dialog"
}
```

## Common Patterns

### Data Sources

```qml
PlasmaCore.DataSource {
    id: dataSource
    engine: "executable"
    connectedSources: ["sensors"]
    interval: 1000
    onNewData: (sourceName, data) => {
        // Handle data
    }
}
```

### Timer Updates

```qml
Timer {
    interval: 30000
    running: true
    repeat: true
    onTriggered: refreshData()
}
```

## Testing Checklist

- [ ] Works in panel (horizontal/vertical)
- [ ] Works on desktop
- [ ] Light and dark theme support
- [ ] Handles missing data gracefully
- [ ] No console errors/warnings
- [ ] Accessible with keyboard
- [ ] Reasonable resource usage

---
**Version:** 1.0 | **Last Updated:** August 2026

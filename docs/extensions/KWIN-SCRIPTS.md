# KWin Script Development Guide

## Overview

KWin scripts extend SANCHALA's window management capabilities. They can automate window placement, create custom tiling layouts, and respond to window events.

## Quick Start

### 1. Create Project Structure

```bash
mkdir -p sanchala-myscript/contents/{code,config}
cd sanchala-myscript
```

### 2. Create metadata.json

```json
{
    "KPlugin": {
        "Id": "sanchala-myscript",
        "Name": "My KWin Script",
        "Description": "Custom window management script",
        "Icon": "preferences-system-windows",
        "Authors": [{"Name": "Your Name", "Email": "you@example.com"}],
        "License": "GPL-3.0",
        "Version": "1.0.0"
    },
    "X-Plasma-API": "javascript",
    "X-Plasma-MainScript": "code/main.js",
    "X-KDE-PluginInfo-EnabledByDefault": false,
    "KPackageStructure": "KWin/Script"
}
```

### 3. Create main.js

```javascript
/*
 * My KWin Script
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

// Log script activation
console.log("My KWin Script loaded");

// React to new windows
workspace.clientAdded.connect(function(client) {
    if (client.normalWindow) {
        console.log("New window: " + client.caption);
        // Custom logic here
    }
});

// React to active window changes
workspace.clientActivated.connect(function(client) {
    if (client) {
        console.log("Activated: " + client.caption);
    }
});
```

### 4. Install & Test

```bash
# Install script
kpackagetool5 -t KWin/Script -i ./sanchala-myscript

# Enable via D-Bus
qdbus org.kde.KWin /Scripting loadScript sanchala-myscript

# View logs
journalctl --user -f | grep kwin
```

## KWin API Reference

### Workspace Object

```javascript
// Properties
workspace.activeClient          // Currently focused window
workspace.currentDesktop        // Current desktop number
workspace.desktops             // Total desktop count
workspace.clientList()         // All managed windows

// Signals
workspace.clientAdded.connect(handler)
workspace.clientRemoved.connect(handler)
workspace.clientActivated.connect(handler)
workspace.currentDesktopChanged.connect(handler)
workspace.clientMinimized.connect(handler)
workspace.clientFullScreenSet.connect(handler)
```

### Client (Window) Object

```javascript
// Read-only properties
client.caption                 // Window title
client.resourceClass           // App class (e.g., "firefox")
client.resourceName            // App name
client.windowId                // X11 window ID
client.pid                     // Process ID

// Geometry (read/write)
client.geometry                // {x, y, width, height}
client.x, client.y
client.width, client.height
client.frameGeometry           // Including decorations

// State (read/write)
client.desktop                 // Desktop number (0 = all)
client.minimized               // Boolean
client.fullScreen              // Boolean
client.keepAbove               // Boolean
client.keepBelow               // Boolean
client.noBorder                // Boolean
client.opacity                 // 0.0 - 1.0

// Type checks
client.normalWindow            // Regular window
client.dialog                  // Dialog window
client.splash                  // Splash screen
client.utility                 // Utility window
```

### Useful Helpers

```javascript
// Get screen geometry
workspace.clientArea(KWin.MaximizeArea, client)
workspace.clientArea(KWin.PlacementArea, client)

// Move/resize window
client.geometry = Qt.rect(x, y, width, height);

// Minimize/restore
client.minimized = true;

// Change desktop
client.desktop = 2;
```

## Common Patterns

### Window Filtering

```javascript
function isManageable(client) {
    return client.normalWindow &&
           !client.splash &&
           !client.specialWindow &&
           client.resizeable;
}

workspace.clientAdded.connect(function(client) {
    if (isManageable(client)) {
        // Handle window
    }
});
```

### Simple Auto-Tiler

```javascript
function tileWindows() {
    var area = workspace.clientArea(KWin.MaximizeArea, 0, workspace.currentDesktop);
    var clients = workspace.clientList().filter(function(c) {
        return c.normalWindow && 
               c.desktop === workspace.currentDesktop &&
               !c.minimized;
    });
    
    if (clients.length === 0) return;
    
    var width = area.width / clients.length;
    clients.forEach(function(client, i) {
        client.geometry = Qt.rect(
            area.x + (i * width),
            area.y,
            width,
            area.height
        );
    });
}

workspace.clientAdded.connect(tileWindows);
workspace.clientRemoved.connect(tileWindows);
```

### Configuration Support

Create `contents/config/main.xml`:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<kcfg xmlns="http://www.kde.org/standards/kcfg/1.0">
    <group name="General">
        <entry name="gap" type="Int"><default>8</default></entry>
        <entry name="enabled" type="Bool"><default>true</default></entry>
    </group>
</kcfg>
```

Access in script:
```javascript
var gap = readConfig("gap", 8);
var enabled = readConfig("enabled", true);
```

## Debugging

```javascript
// Console output
console.log("Debug message");

// Print object
console.log(JSON.stringify(client.geometry));

// View logs
// journalctl --user -f -u plasma-kwin_x11
```

## Best Practices

1. **Check window type** before manipulating
2. **Use signals** instead of polling
3. **Handle edge cases** (no windows, single window)
4. **Respect user preferences** via configuration
5. **Clean up** when script unloads

---
**Version:** 1.0 | **Last Updated:** August 2026

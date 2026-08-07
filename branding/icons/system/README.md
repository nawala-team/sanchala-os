# 🎨 SANCHALA OS - System Icon Set

## Overview

**Style:** Outlined, 2px stroke  
**Grid:** 24x24px base  
**Corners:** Rounded (2px radius)  
**Format:** SVG (scalable)

## Icon Inventory

### Core System Icons

| Icon | File | Usage |
|------|------|-------|
| Settings | `settings.svg` | System settings app |
| Guardian | `guardian.svg` | Security center |
| Store | `store.svg` | App store |
| Files | `files.svg` | File manager |
| Terminal | `terminal.svg` | Terminal app |
| Power | `power.svg` | Shutdown/power menu |
| Network | `network.svg` | Network status/settings |
| Search | `search.svg` | Spotlight/search |
| User | `user.svg` | User account |
| Lock | `lock.svg` | Lock screen, security |

## Design Guidelines

### Stroke
- Weight: 2px
- Cap: Round
- Join: Round

### Colors
- Default: `currentColor` (inherits text color)
- Active: `#3949AB` (Sanchala Indigo)
- Hover: `#536DFE` (Electric Blue)

### Sizes
| Context | Size |
|---------|------|
| Menu/List | 16px |
| Toolbar | 20px |
| Panel | 24px |
| App Launcher | 48px |
| Dock | 64px |

## Usage in CSS/QML

```css
/* CSS */
.icon {
  color: #E0E0E0;
  width: 24px;
  height: 24px;
}
.icon:hover {
  color: #536DFE;
}
```

```qml
/* QML */
Image {
  source: "icons/system/settings.svg"
  sourceSize: Qt.size(24, 24)
}
```

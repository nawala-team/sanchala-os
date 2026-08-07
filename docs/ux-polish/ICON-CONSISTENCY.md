# 🎯 Icon Consistency Guidelines

**Purpose:** Ensure visual harmony across all SANCHALA OS icons  
**Target:** Unified icon language matching macOS SF Symbols quality

---

## Icon Style Specification

### Core Parameters

| Property | Value |
|----------|-------|
| **Grid** | 24×24px base |
| **Stroke width** | 2px |
| **Stroke cap** | Round |
| **Stroke join** | Round |
| **Corner radius** | 2px (internal shapes) |
| **Color** | `currentColor` (inherits) |

### Size Scale

| Context | Size | Stroke |
|---------|------|--------|
| Menu/List | 16px | 1.5px |
| Toolbar | 20px | 2px |
| Panel/Tray | 24px | 2px |
| App Launcher | 48px | 2.5px |
| Dock | 64px | 3px |

---

## Color Usage

### Default States

| State | Color | Notes |
|-------|-------|-------|
| Default | `currentColor` | Inherits from text |
| Hover | `#536DFE` | Electric Blue |
| Active | `#3949AB` | Sanchala Indigo |
| Disabled | `#9E9E9E` | Medium Gray |

### Semantic Colors

| Meaning | Color |
|---------|-------|
| Success/Confirm | `#00C853` |
| Warning/Caution | `#FFB300` |
| Error/Danger | `#FF1744` |
| Info | `#536DFE` |

---

## Icon Inventory Checklist

### System Icons (10 total)

| Icon | File | Stroke | Grid | Color | Status |
|------|------|--------|------|-------|--------|
| Settings | `settings.svg` | 2px | 24×24 | currentColor | ☐ |
| Guardian | `guardian.svg` | 2px | 24×24 | currentColor | ☐ |
| Store | `store.svg` | 2px | 24×24 | currentColor | ☐ |
| Files | `files.svg` | 2px | 24×24 | currentColor | ☐ |
| Terminal | `terminal.svg` | 2px | 24×24 | currentColor | ☐ |
| Power | `power.svg` | 2px | 24×24 | currentColor | ☐ |
| Network | `network.svg` | 2px | 24×24 | currentColor | ☐ |
| Search | `search.svg` | 2px | 24×24 | currentColor | ☐ |
| User | `user.svg` | 2px | 24×24 | currentColor | ☐ |
| Lock | `lock.svg` | 2px | 24×24 | currentColor | ☐ |

### Verification Checklist

For each icon, verify:

| Check | Description |
|-------|-------------|
| ☐ Stroke weight | Exactly 2px |
| ☐ Stroke caps | Round, not square |
| ☐ Stroke joins | Round, not miter |
| ☐ ViewBox | `0 0 24 24` |
| ☐ No fill | `fill="none"` |
| ☐ CurrentColor | `stroke="currentColor"` |
| ☐ Centered | Optically centered in frame |
| ☐ Consistent weight | Same visual weight as siblings |

---

## Design Guidelines

### Optical Balance

Icons should appear visually centered, not mathematically centered:
- Triangular shapes (play) shift slightly right
- Asymmetric shapes may need manual adjustment
- Test at multiple sizes

### Visual Weight

All icons should have similar visual weight:
- Dense icons: use thinner internal strokes
- Sparse icons: can use full 2px throughout
- Compare icons side-by-side at 16px

### Recognizability

Icons must be instantly recognizable:
- Test at smallest size (16px)
- Avoid excessive detail
- Use familiar metaphors

---

## SVG Template

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!-- Sanchala OS - [Icon Name] (24x24 grid, 2px stroke) -->
<svg xmlns="http://www.w3.org/2000/svg" 
     viewBox="0 0 24 24" 
     width="24" 
     height="24">
  <g fill="none" 
     stroke="currentColor" 
     stroke-width="2" 
     stroke-linecap="round" 
     stroke-linejoin="round">
    <!-- Icon paths here -->
  </g>
</svg>
```

---

## Common Issues

| Issue | Problem | Solution |
|-------|---------|----------|
| Blurry at small sizes | Too much detail | Simplify paths |
| Inconsistent weight | Mixed stroke widths | Standardize to 2px |
| Wrong color | Hardcoded hex | Use `currentColor` |
| Not centered | Math vs optical | Adjust manually |
| Pixelated | Stroke on half-pixel | Align to pixel grid |

---

## Testing Procedure

1. **Size test:** View at 16px, 24px, 48px
2. **Theme test:** Light and dark backgrounds
3. **Context test:** Alongside other icons
4. **State test:** Default, hover, active, disabled
5. **A11y test:** Sufficient contrast (3:1 minimum)

---

## Missing Icons Needed

| Icon | Priority | Usage |
|------|----------|-------|
| Bluetooth | High | System tray |
| Volume | High | System tray |
| Brightness | High | Quick settings |
| Battery | High | System tray |
| WiFi | High | System tray |
| Camera | Medium | Privacy indicator |
| Microphone | Medium | Privacy indicator |
| Location | Medium | Privacy indicator |
| Update | Medium | System updates |
| Trash | Low | File operations |

---

**Document Version:** 1.0  
**Last Updated:** August 2025

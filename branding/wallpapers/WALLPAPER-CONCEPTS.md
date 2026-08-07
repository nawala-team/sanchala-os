# 🖼️ SANCHALA OS - Wallpaper Collection

## Overview

**Collection Name:** Gati (गति - Speed/Motion)  
**Resolution:** 4K (3840x2160) minimum, 5K (5120x2880) preferred  
**Formats:** PNG (lossless), WebP (lossy for smaller downloads)  
**Style:** Abstract gradients, subtle geometric patterns, dynamic time-of-day variants

---

## Default Wallpapers

### 1. Gati Default (Light)
**File:** `default-light.png`

**Design:**
- Base: Soft gradient from `#E8EAF6` (Indigo 50) to `#C5CAE9` (Indigo 100)
- Accent: Subtle diagonal light rays from top-right
- Geometry: Very faint concentric circles (motion ripples) at 5% opacity
- Focal point: Slight bright spot at golden ratio position
- Mood: Fresh, clean, productive morning

**Colors:**
- Primary: `#E8EAF6`
- Secondary: `#C5CAE9`  
- Accent: `#FFFFFF` at 10% for light rays

---

### 2. Gati Default (Dark)
**File:** `default-dark.png`

**Design:**
- Base: Deep gradient from `#121212` to `#1A237E` (Deep Navy)
- Accent: Subtle aurora-like waves of `#536DFE` at 15% opacity
- Geometry: Abstract flowing curves suggesting motion
- Stars: Very subtle, sparse star field (barely visible)
- Mood: Focused, calm, professional night work

**Colors:**
- Primary: `#121212`
- Secondary: `#1A237E`
- Accent: `#536DFE` at 15%

---

### 3. Gati OLED (Pure Black)
**File:** `default-oled.png`

**Design:**
- Base: Pure black `#000000` (battery saving for OLED)
- Accent: Single elegant curve of brand gradient
- Minimal: ~90% pure black, ~10% subtle accent
- Mood: Ultimate minimalism, power efficiency

**Colors:**
- Primary: `#000000`
- Accent: `#3949AB` → `#536DFE` gradient curve

---

## Time-of-Day Collection

### 4. Gati Dawn
**File:** `gati-dawn.png`

**Design:**
- Warm gradient: `#1A237E` (horizon) → `#FF6F00` → `#FFB300` (sky)
- Soft horizontal bands suggesting sunrise
- Subtle mountain silhouette at bottom (abstract)
- Mood: New beginnings, energy, optimism

---

### 5. Gati Day
**File:** `gati-day.png`

**Design:**
- Bright gradient: `#536DFE` → `#3949AB` → `#E8EAF6`
- Abstract cloud-like soft shapes
- Vibrant but not distracting
- Mood: Productivity, clarity, action

---

### 6. Gati Dusk
**File:** `gati-dusk.png`

**Design:**
- Warm to cool: `#FF6F00` → `#E91E63` → `#3949AB` → `#1A237E`
- Gradient bands suggesting sunset layers
- Subtle geometric patterns fading into dark
- Mood: Winding down, reflection, transition

---

### 7. Gati Night
**File:** `gati-night.png`

**Design:**
- Deep cool tones: `#0D0D0D` → `#1A237E`
- Subtle star field with occasional brighter stars
- Faint nebula-like clouds of `#3949AB` at 5%
- Mood: Focus, calm, late-night work

---

## Abstract Collection

### 8. Gati Flow
**File:** `gati-flow.png`

**Design:**
- Abstract fluid dynamics visualization
- Brand colors in flowing, organic curves
- Suggests motion and energy (Sanchala meaning)
- Mood: Creative, dynamic, modern

---

### 9. Gati Mesh
**File:** `gati-mesh.png`

**Design:**
- Subtle gradient mesh with brand colors
- Soft blobs of color blending naturally
- macOS Sonoma-inspired but unique
- Mood: Modern, tech-forward, clean

---

### 10. Gati Grid
**File:** `gati-grid.png`

**Design:**
- Subtle perspective grid (tron-like but minimal)
- Grid fades into darkness at edges
- Brand color highlights on grid lines
- Mood: Technical, precise, structured

---

## Technical Specifications

### File Naming Convention
```
sanchala-{name}-{variant}.{ext}
Examples:
- sanchala-default-dark.png
- sanchala-gati-dawn.png
- sanchala-gati-flow-light.png
```

### Required Resolutions
| Resolution | Aspect | Target |
|------------|--------|--------|
| 3840x2160 | 16:9 | Standard 4K |
| 5120x2880 | 16:9 | 5K Retina |
| 3840x2400 | 16:10 | Laptop 4K |
| 2560x1440 | 16:9 | 2K fallback |

### Color Profile
- sRGB for maximum compatibility
- Embedded ICC profile

### Compression
- PNG: Maximum quality, ~5-15MB per file
- WebP: Quality 90, ~1-3MB per file

---

## Dynamic Wallpaper Support

Sanchala OS will support time-based dynamic wallpapers:

```xml
<!-- sanchala-dynamic.xml -->
<background>
  <starttime>
    <hour>6</hour><minute>0</minute>
  </starttime>
  
  <static>
    <duration>21600</duration> <!-- 6 hours -->
    <file>gati-dawn.png</file>
  </static>
  
  <transition>
    <duration>3600</duration>
    <from>gati-dawn.png</from>
    <to>gati-day.png</to>
  </transition>
  
  <!-- Continue for full 24-hour cycle -->
</background>
```

---

## Installation Location

```
/usr/share/sanchala/wallpapers/
├── default-light.png
├── default-dark.png
├── default-oled.png
├── collection/
│   ├── gati-dawn.png
│   ├── gati-day.png
│   ├── gati-dusk.png
│   ├── gati-night.png
│   ├── gati-flow.png
│   ├── gati-mesh.png
│   └── gati-grid.png
└── dynamic/
    └── sanchala-dynamic.xml
```

---

**Document Version:** 1.0  
**Author:** Design Lead  
**Last Updated:** Phase 1 Sprint

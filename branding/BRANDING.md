# 🎨 SANCHALA OS - Branding Guidelines

## Logo

### Primary Logo

```
        ╭─────────╮
       ╱    ◉     ╲
      │  ╱─────╲  │
      │ │ ░░░░░ │ │
      │  ╲─────╱  │
       ╲    ▼    ╱
        ╮─────────╯

   S A N C H A L A
```

**Concept:** A gear/wheel in motion representing "sanchala" (to set in motion)

### Logo Variations

| Variant | Usage |
|---------|-------|
| Full color | Primary usage, light backgrounds |
| Monochrome | Single color applications |
| White | Dark backgrounds |
| Icon only | App icons, favicons |
| Wordmark | Text-only contexts |

---

## Color Palette

### Primary Colors

| Color | Hex | RGB | Usage |
|-------|-----|-----|-------|
| **Sanchala Indigo** | `#3949AB` | `57, 73, 171` | Primary brand color |
| **Deep Navy** | `#1A237E` | `26, 35, 126` | Headers, dark accents |
| **Electric Blue** | `#536DFE` | `83, 109, 254` | Links, interactive elements |

### Secondary Colors

| Color | Hex | RGB | Usage |
|-------|-----|-----|-------|
| **Golden Amber** | `#FFB300` | `255, 179, 0` | Highlights, warnings |
| **Success Green** | `#00C853` | `0, 200, 83` | Success states |
| **Alert Red** | `#FF1744` | `255, 23, 68` | Errors, critical alerts |

### Neutral Colors

| Color | Hex | RGB | Usage |
|-------|-----|-----|-------|
| **White** | `#FFFFFF` | `255, 255, 255` | Light backgrounds |
| **Light Gray** | `#F5F5F5` | `245, 245, 245` | Secondary backgrounds |
| **Medium Gray** | `#9E9E9E` | `158, 158, 158` | Disabled, placeholders |
| **Dark Gray** | `#424242` | `66, 66, 66` | Secondary text |
| **Charcoal** | `#212121` | `33, 33, 33` | Dark mode background |
| **Deep Black** | `#121212` | `18, 18, 18` | OLED dark mode |

---

## Typography

### Font Stack

| Category | Font | Fallback |
|----------|------|----------|
| **UI/System** | Inter | Noto Sans, sans-serif |
| **Monospace** | JetBrains Mono | Fira Code, monospace |
| **Sanskrit** | Noto Sans Devanagari | - |
| **Display** | Inter (600 weight) | - |

### Font Sizes

| Element | Size | Weight |
|---------|------|--------|
| H1 | 32px | 600 |
| H2 | 24px | 600 |
| H3 | 20px | 600 |
| Body | 14px | 400 |
| Small | 12px | 400 |
| Caption | 11px | 400 |

---

## Visual Elements

### Border Radius

| Element | Radius |
|---------|--------|
| Buttons | 8px |
| Cards | 12px |
| Windows | 12px |
| Modals | 16px |
| Pills/Tags | 9999px |

### Shadows

```css
/* Elevation 1 - Cards */
box-shadow: 0 1px 3px rgba(0,0,0,0.12), 0 1px 2px rgba(0,0,0,0.24);

/* Elevation 2 - Dropdowns */
box-shadow: 0 3px 6px rgba(0,0,0,0.16), 0 3px 6px rgba(0,0,0,0.23);

/* Elevation 3 - Modals */
box-shadow: 0 10px 20px rgba(0,0,0,0.19), 0 6px 6px rgba(0,0,0,0.23);

/* Elevation 4 - Floating elements */
box-shadow: 0 14px 28px rgba(0,0,0,0.25), 0 10px 10px rgba(0,0,0,0.22);
```

### Blur Effects

| Element | Blur |
|---------|------|
| Panel background | 20px |
| Window titlebar | 10px |
| Dock | 30px |
| Overlay | 40px |

---

## Iconography

### Style Guidelines

- **Style:** Outlined, 2px stroke
- **Grid:** 24x24px base
- **Corners:** Rounded (2px)
- **Color:** Single color, matches text or accent

### System Icons

| Icon | Usage |
|------|-------|
| `sanchala-logo` | App menu, about |
| `sanchala-guardian` | Security center |
| `sanchala-store` | App store |
| `sanchala-settings` | System settings |

---

## Wallpapers

### Default Wallpaper

- **Style:** Abstract gradient with subtle geometric shapes
- **Colors:** Sanchala Indigo to Deep Navy gradient
- **Resolution:** 4K (3840x2160) minimum
- **Variants:** Light, Dark, OLED

### Wallpaper Collection

| Name | Style | Time |
|------|-------|------|
| Gati Dawn | Warm gradient | Morning |
| Gati Day | Bright, vibrant | Day |
| Gati Dusk | Purple/orange | Evening |
| Gati Night | Dark blue/indigo | Night |
| Gati Abstract | Geometric | Any |
| Gati Nature | Photography | Any |

---

## Release Codenames

| Version | Codename | Sanskrit | Meaning |
|---------|----------|----------|----------|
| 1.0 | **Gati** | गति | Speed, motion |
| 2.0 | **Vega** | वेग | Momentum, velocity |
| 3.0 | **Dhruva** | ध्रुव | Steadfast, stable |
| 4.0 | **Ananta** | अनंत | Infinite, endless |
| 5.0 | **Tejasa** | तेजस | Radiant, brilliant |

---

## Voice & Tone

### Principles

1. **Knowledgeable** - Expert but not condescending
2. **Supportive** - Helpful and understanding
3. **Warm** - Friendly, approachable
4. **Concise** - Clear, no fluff
5. **Honest** - Transparent about limitations

### Examples

| ❌ Don't | ✅ Do |
|---------|-------|
| "Error occurred" | "We couldn't save your file. Check disk space?" |
| "Invalid input" | "That password needs at least 8 characters" |
| "Feature unavailable" | "This feature is coming in the next update" |

---

## Assets Location

```
branding/
├── logos/
│   ├── sanchala-logo.svg
│   ├── sanchala-logo-white.svg
│   ├── sanchala-icon.svg
│   ├── sanchala-wordmark.svg
│   └── sanchala-banner.png
├── wallpapers/
│   ├── default-dark.png
│   ├── default-light.png
│   └── collection/
├── icons/
│   ├── apps/
│   └── system/
├── fonts/
│   ├── Inter/
│   └── JetBrainsMono/
└── mockups/
    ├── desktop.png
    ├── launcher.png
    └── settings.png
```

---

**Document Version:** 1.0  
**Last Updated:** August 2026

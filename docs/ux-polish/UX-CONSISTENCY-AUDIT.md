# 🔍 UX Consistency Audit Checklist

**Purpose:** Systematic verification of UI consistency across SANCHALA OS  
**Target:** macOS-level polish and coherence

---

## 1. Color System Audit

### Brand Colors Verification

| Element | Expected | Status | Notes |
|---------|----------|--------|-------|
| Primary buttons | `#3949AB` | ☐ | Sanchala Indigo |
| Active selections | `#3949AB` | ☐ | Background highlight |
| Links/interactive | `#536DFE` | ☐ | Electric Blue |
| Headers/titlebars | `#1A237E` (dark) / `#3949AB` (light) | ☐ | Theme-appropriate |
| Success states | `#00C853` | ☐ | Green |
| Warning states | `#FFB300` | ☐ | Golden Amber |
| Error states | `#FF1744` | ☐ | Alert Red |
| Disabled text | `#9E9E9E` | ☐ | Medium Gray |

### Light Theme Colors

| Element | Expected | Status |
|---------|----------|--------|
| Window background | `#F5F5F5` | ☐ |
| Card/panel background | `#FFFFFF` | ☐ |
| Primary text | `#212121` | ☐ |
| Secondary text | `#424242` | ☐ |
| Borders | `#E0E0E0` | ☐ |

### Dark Theme Colors

| Element | Expected | Status |
|---------|----------|--------|
| Window background | `#212121` | ☐ |
| Card/panel background | `#1E1E1E` | ☐ |
| Elevated surfaces | `#2A2A2A` | ☐ |
| Primary text | `#FFFFFF` | ☐ |
| Secondary text | `#B0B0B0` | ☐ |
| Borders | `#424242` | ☐ |

### Contrast Verification (WCAG AA)

| Combination | Required Ratio | Status |
|-------------|----------------|--------|
| Primary text on background | 4.5:1 | ☐ |
| Secondary text on background | 4.5:1 | ☐ |
| Link color on background | 4.5:1 | ☐ |
| Button text on button bg | 4.5:1 | ☐ |
| Icon on background | 3:1 | ☐ |
| Focus indicator | 3:1 | ☐ |

---

## 2. Typography Audit

### Font Family Verification

| Context | Expected Font | Fallback | Status |
|---------|---------------|----------|--------|
| UI/System | Inter | Noto Sans, sans-serif | ☐ |
| Monospace | JetBrains Mono | Fira Code, monospace | ☐ |
| Sanskrit text | Noto Sans Devanagari | - | ☐ |

### Font Size Scale

| Element | Size | Weight | Status |
|---------|------|--------|--------|
| H1 (Page title) | 32px | 600 | ☐ |
| H2 (Section) | 24px | 600 | ☐ |
| H3 (Subsection) | 20px | 600 | ☐ |
| Body | 14px | 400 | ☐ |
| Caption | 12px | 400 | ☐ |
| Overline | 11px | 500 | ☐ |

---

## 3. Spacing Audit

### Spacing Scale (4px base)

| Token | Value | Usage | Status |
|-------|-------|-------|--------|
| `xs` | 4px | Tight spacing | ☐ |
| `sm` | 8px | Compact elements | ☐ |
| `md` | 12px | Default padding | ☐ |
| `lg` | 16px | Comfortable | ☐ |
| `xl` | 24px | Section gaps | ☐ |
| `2xl` | 32px | Major sections | ☐ |

### Component Spacing

| Component | Padding | Status |
|-----------|---------|--------|
| Buttons | 6px 16px | ☐ |
| Input fields | 8px 12px | ☐ |
| Cards | 16px | ☐ |
| List items | 8px 12px | ☐ |
| Menu items | 8px 12px | ☐ |
| Dialog content | 24px | ☐ |

---

## 4. Border Radius Audit

| Element | Radius | Status |
|---------|--------|--------|
| Buttons | 8px | ☐ |
| Input fields | 8px | ☐ |
| Cards | 12px | ☐ |
| Windows (CSD) | 12px | ☐ |
| Modals/Dialogs | 16px | ☐ |
| Menus/Popovers | 12px | ☐ |
| Tooltips | 8px | ☐ |
| Pills/Tags | 9999px | ☐ |
| Progress bars | 9999px | ☐ |

---

## 5. Shadow & Elevation Audit

| Level | Usage | Status |
|-------|-------|--------|
| Elevation 1 | Cards, buttons | ☐ |
| Elevation 2 | Dropdowns, popovers | ☐ |
| Elevation 3 | Modals, dialogs | ☐ |
| Elevation 4 | Floating elements | ☐ |

### Blur Effects

| Element | Blur | Status |
|---------|------|--------|
| Panel background | 20px | ☐ |
| Titlebar | 10px | ☐ |
| Dock | 30px | ☐ |
| Overlay | 40px | ☐ |

---

## 6. Interactive States

### Button States

| State | Visual Change | Status |
|-------|---------------|--------|
| Hover | Lighter bg | ☐ |
| Active | Darker bg | ☐ |
| Focus | 2px accent ring | ☐ |
| Disabled | 50% opacity | ☐ |

### Input States

| State | Visual Change | Status |
|-------|---------------|--------|
| Focus | Accent border + ring | ☐ |
| Error | Red border + icon | ☐ |
| Disabled | Muted bg | ☐ |

---

## 7. Cross-Toolkit Consistency

| Element | GTK = Qt | Status |
|---------|----------|--------|
| Buttons | ☐ | |
| Inputs | ☐ | |
| Scrollbars | ☐ | |
| Menus | ☐ | |
| Colors | ☐ | |
| Fonts | ☐ | |

---

## 8. Accessibility Visual

| Check | Status |
|-------|--------|
| All elements have visible focus | ☐ |
| Focus indicator 3:1 contrast | ☐ |
| Info not by color alone | ☐ |
| Respects reduced-motion | ☐ |

---

**Document Version:** 1.0  
**Last Updated:** August 2025

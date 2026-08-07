# 📐 Spacing & Typography System

**Purpose:** Consistent spatial rhythm and typographic hierarchy  
**Target:** Pixel-perfect alignment matching macOS standards

---

## Spacing System

### Base Unit
**4px** is the atomic unit. All spacing derives from this.

### Spacing Scale

| Token | Value | CSS Variable | Usage |
|-------|-------|--------------|-------|
| `xs` | 4px | `--space-xs` | Icon gaps, tight margins |
| `sm` | 8px | `--space-sm` | Compact internal padding |
| `md` | 12px | `--space-md` | Default component padding |
| `lg` | 16px | `--space-lg` | Comfortable spacing |
| `xl` | 24px | `--space-xl` | Section separation |
| `2xl` | 32px | `--space-2xl` | Major section gaps |
| `3xl` | 48px | `--space-3xl` | Page-level spacing |
| `4xl` | 64px | `--space-4xl` | Hero sections |

### Component Spacing Reference

| Component | Padding | Gap |
|-----------|---------|-----|
| Button (sm) | 4px 12px | - |
| Button (md) | 6px 16px | - |
| Button (lg) | 8px 24px | - |
| Input field | 8px 12px | - |
| Card | 16px | 12px |
| List item | 8px 12px | 0 |
| Menu item | 8px 12px | 0 |
| Toolbar | 8px 12px | 8px |
| Dialog header | 16px 24px | - |
| Dialog content | 24px | 16px |
| Dialog footer | 16px 24px | 12px |
| Sidebar | 8px | 2px |
| Tab bar | 0 | 4px |

### Layout Spacing

| Context | Value |
|---------|-------|
| Window content margin | 16px |
| Window tile gap | 8px |
| Dock item gap | 4px |
| Panel padding | 8px |
| Notification gap | 8px |
| Widget grid gap | 16px |
| Form field gap | 16px |
| Form section gap | 32px |

---

## Typography System

### Font Stack

```css
/* System UI */
--font-system: 'Inter', 'Noto Sans', -apple-system, sans-serif;

/* Monospace */
--font-mono: 'JetBrains Mono', 'Fira Code', monospace;

/* Sanskrit/Devanagari */
--font-devanagari: 'Noto Sans Devanagari', sans-serif;
```

### Type Scale

| Level | Size | Weight | Line Height | Letter Spacing |
|-------|------|--------|-------------|----------------|
| Display | 48px | 600 | 1.1 | -0.02em |
| H1 | 32px | 600 | 1.2 | -0.01em |
| H2 | 24px | 600 | 1.25 | -0.01em |
| H3 | 20px | 600 | 1.3 | 0 |
| H4 | 16px | 600 | 1.4 | 0 |
| Body Large | 16px | 400 | 1.5 | 0 |
| Body | 14px | 400 | 1.5 | 0 |
| Body Small | 13px | 400 | 1.5 | 0 |
| Caption | 12px | 400 | 1.4 | 0.01em |
| Overline | 11px | 500 | 1.4 | 0.05em |

### Font Weights

| Weight | Value | Usage |
|--------|-------|-------|
| Regular | 400 | Body text, descriptions |
| Medium | 500 | Emphasis, labels |
| Semibold | 600 | Headings, buttons |

### CSS Implementation

```css
:root {
  /* Type scale */
  --text-display: 600 48px/1.1 var(--font-system);
  --text-h1: 600 32px/1.2 var(--font-system);
  --text-h2: 600 24px/1.25 var(--font-system);
  --text-h3: 600 20px/1.3 var(--font-system);
  --text-h4: 600 16px/1.4 var(--font-system);
  --text-body: 400 14px/1.5 var(--font-system);
  --text-body-sm: 400 13px/1.5 var(--font-system);
  --text-caption: 400 12px/1.4 var(--font-system);
  --text-overline: 500 11px/1.4 var(--font-system);
}
```

---

## Alignment Guidelines

### Baseline Grid
Text should align to a **4px baseline grid** where practical.

### Text Alignment

| Context | Alignment |
|---------|-----------|
| Body text | Left |
| Headings | Left |
| Centered layouts | Center |
| Numbers in tables | Right |
| Button labels | Center |
| Form labels | Left |

### Icon + Text Alignment

```
┌─────────────────────┐
│  [icon]  Label Text │  ← Icon vertically centered with text
└─────────────────────┘
    ↑
    4px gap between icon and text
```

---

## Responsive Typography

### Scale Adjustments

| Breakpoint | Base Size | Scale Factor |
|------------|-----------|--------------|
| Mobile (<600px) | 14px | 0.9× headings |
| Tablet (600-1024px) | 14px | 1× (default) |
| Desktop (>1024px) | 14px | 1× |
| Large (>1440px) | 15px | 1.05× |

### Minimum Sizes

| Element | Minimum |
|---------|---------|
| Body text | 12px |
| Interactive labels | 12px |
| Legal/footnotes | 10px |
| Touch targets | 44px × 44px |

---

## Audit Checklist

### Spacing Verification

| Check | Status |
|-------|--------|
| All spacing uses 4px multiples | ☐ |
| Consistent padding within component types | ☐ |
| No magic numbers in CSS | ☐ |
| Responsive spacing adjusts appropriately | ☐ |

### Typography Verification

| Check | Status |
|-------|--------|
| Font stack renders correctly | ☐ |
| Heading hierarchy is logical | ☐ |
| Body text is 14px | ☐ |
| Line heights provide readability | ☐ |
| No text smaller than 10px | ☐ |
| Monospace used for code | ☐ |

---

**Document Version:** 1.0  
**Last Updated:** August 2025

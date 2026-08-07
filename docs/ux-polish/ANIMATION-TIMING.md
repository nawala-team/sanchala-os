# ⏱️ Animation Timing Guidelines

**Purpose:** Consistent, delightful animations across SANCHALA OS  
**Target:** 60fps fluid motion with macOS-quality easing

---

## Core Principles

1. **Animation Serves Function** - Guide attention, provide feedback, show relationships
2. **Fast by Default** - Users should never wait for animations
3. **Respect Preferences** - Honor `prefers-reduced-motion: reduce`

---

## Duration Scale

| Token | Duration | Use Case |
|-------|----------|----------|
| `instant` | 0ms | Immediate feedback |
| `fast` | 100ms | Micro-interactions (hover, toggle) |
| `normal` | 200ms | Standard transitions |
| `moderate` | 300ms | Emphasis (modal open) |
| `slow` | 400ms | Major state changes |

### Duration by Context

| Context | Duration |
|---------|----------|
| Hover states | 100ms |
| Button press | 100ms |
| Toggle/Switch | 150ms |
| Dropdown open | 200ms |
| Modal appear | 250ms |
| Modal dismiss | 200ms |
| Page transition | 300ms |
| Toast notification | 300ms in, 200ms out |

---

## Easing Functions

```css
/* Standard - most common, natural deceleration */
--ease-standard: cubic-bezier(0.4, 0.0, 0.2, 1);

/* Decelerate - elements entering screen */
--ease-decelerate: cubic-bezier(0.0, 0.0, 0.2, 1);

/* Accelerate - elements leaving screen */
--ease-accelerate: cubic-bezier(0.4, 0.0, 1, 1);

/* Sharp - quick, snappy feel */
--ease-sharp: cubic-bezier(0.4, 0.0, 0.6, 1);
```

| Easing | Use For |
|--------|---------|
| Standard | Default for most transitions |
| Decelerate | Elements appearing, sliding in |
| Accelerate | Elements disappearing, sliding out |
| Sharp | Quick toggles, micro-interactions |

---

## Animation Patterns

### Fade
```css
@keyframes fade-in {
  from { opacity: 0; }
  to { opacity: 1; }
}
/* Duration: 150-200ms, Easing: standard */
```

### Scale + Fade (Modals)
```css
@keyframes scale-fade-in {
  from { opacity: 0; transform: scale(0.95); }
  to { opacity: 1; transform: scale(1); }
}
/* Duration: 200-250ms, Easing: decelerate */
```

### Slide (Sidebars)
```css
@keyframes slide-in-right {
  from { transform: translateX(100%); }
  to { transform: translateX(0); }
}
/* Duration: 250ms */
```

### Stagger (Lists)
```css
.list-item:nth-child(1) { animation-delay: 0ms; }
.list-item:nth-child(2) { animation-delay: 50ms; }
.list-item:nth-child(3) { animation-delay: 100ms; }
/* Max stagger: 300ms total */
```

---

## Component Timing

### Buttons
```css
button {
  transition: background 100ms ease, transform 100ms ease;
}
button:active {
  transition-duration: 50ms; /* Faster press */
}
```

### Menus/Dropdowns
```css
.menu {
  animation: menu-open 200ms var(--ease-decelerate);
}
```

### Tooltips
- Delay before show: 500ms
- Fade duration: 150ms

---

## KWin Window Animations

```ini
[Compositing]
AnimationSpeed=3  # 1=Instant, 2=Fast, 3=Normal, 4=Slow
```

| Animation | Duration |
|-----------|----------|
| Window open | 200ms |
| Window close | 150ms |
| Desktop switch | 300ms |

---

## Reduced Motion

```css
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after {
    animation-duration: 0.01ms !important;
    transition-duration: 0.01ms !important;
  }
}
```

**Preserve:** Opacity fades, color changes  
**Remove:** Parallax, bouncing, decorative motion

---

## Performance

**GPU-Accelerated (prefer):** `transform`, `opacity`  
**Avoid animating:** `width`, `height`, `margin`, `box-shadow`

| Target | Value |
|--------|-------|
| Frame rate | 60fps |
| Forced reflows | 0 |

---

**Document Version:** 1.0  
**Last Updated:** August 2025

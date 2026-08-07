# ✨ Final UI Polish List

**Purpose:** Prioritized list of polish tasks for SANCHALA OS 1.0 release  
**Target:** macOS Sonoma-level visual refinement

---

## Priority Levels

| Priority | Meaning | Timeline |
|----------|---------|----------|
| 🔴 P0 | Critical - blocks release | Immediate |
| 🟠 P1 | High - visible issues | This week |
| 🟡 P2 | Medium - quality improvements | Before release |
| 🟢 P3 | Low - nice to have | Post-release |

---

## 🔴 P0 - Critical Polish

### Color Consistency
- [ ] Verify GTK theme colors match brand spec exactly
- [ ] Ensure dark theme uses correct elevated surface colors
- [ ] Fix any hardcoded colors in Qt/Plasma components
- [ ] Validate accent color propagation across toolkits

### Typography
- [ ] Confirm Inter font loads as primary system font
- [ ] Verify JetBrains Mono for terminal/code
- [ ] Check font rendering (hinting, antialiasing)
- [ ] Ensure Devanagari text renders correctly

### Accessibility
- [ ] All interactive elements have visible focus states
- [ ] Focus indicators meet 3:1 contrast ratio
- [ ] No keyboard traps in dialogs/modals
- [ ] Screen reader announces all UI elements

---

## 🟠 P1 - High Priority

### GTK/Qt Consistency
- [ ] Button appearance matches between GTK and Qt apps
- [ ] Scrollbar styling consistent across toolkits
- [ ] Context menu styling unified
- [ ] Input field focus rings match

### Animation Polish
- [ ] Window open/close animations smooth (60fps)
- [ ] Modal entrance uses scale+fade (250ms, decelerate)
- [ ] Menu open animation (200ms, decelerate)
- [ ] Tooltip fade-in (150ms, 500ms delay)

### Component States
- [ ] All buttons have hover/active/disabled states
- [ ] Form inputs show focus/error/disabled properly
- [ ] List selections have correct highlight colors
- [ ] Toggle switches animate smoothly (150ms)

---

## 🟡 P2 - Medium Priority

### Visual Refinement
- [ ] Window shadows match elevation spec
- [ ] Blur effects render at correct radius
- [ ] Border colors consistent (#E0E0E0 light, #424242 dark)
- [ ] Card/panel backgrounds use correct colors

### Spacing Fixes
- [ ] Dialog content padding is 24px
- [ ] Button padding is 6px 16px
- [ ] List item spacing is 8px 12px
- [ ] Consistent 4px grid alignment

### Icons
- [ ] All 10 system icons pass style check
- [ ] Icons use currentColor (no hardcoded)
- [ ] Icon sizes consistent in context
- [ ] Add missing status icons (WiFi, Battery, etc.)

### Micro-interactions
- [ ] Button press has subtle scale (0.98)
- [ ] Checkbox/radio have check animation
- [ ] Progress bars animate smoothly
- [ ] Loading spinners at 1s rotation

---

## 🟢 P3 - Nice to Have

### Delight Details
- [ ] Staggered list animations (50ms increment)
- [ ] Parallax in overview mode
- [ ] Subtle hover lift on cards
- [ ] Spring easing on drag-drop success

### Theme Extras
- [ ] Wallpaper-based accent color extraction
- [ ] Smooth light/dark transition animation
- [ ] Time-based auto theme switching
- [ ] Per-app theme overrides

### Polish Touches
- [ ] Window resize handles cursor feedback
- [ ] Drag ghost images styled
- [ ] Empty state illustrations
- [ ] Skeleton loading screens

---

## Known Issues Tracker

| ID | Description | Component | Priority | Status |
|----|-------------|-----------|----------|--------|
| UX-001 | GTK headerbar gradient differs from Qt | GTK Theme | P1 | Open |
| UX-002 | Focus ring not visible on dark toggle | Switches | P0 | Open |
| UX-003 | Menu shadow too harsh in light mode | Menus | P2 | Open |
| UX-004 | Tooltip delay inconsistent | Various | P2 | Open |
| UX-005 | Scrollbar thumb too thin | GTK | P2 | Open |

---

## Verification Matrix

### Theme Testing

| App | Light Theme | Dark Theme | Accent Color |
|-----|-------------|------------|--------------|
| Dolphin | ☐ | ☐ | ☐ |
| Konsole | ☐ | ☐ | ☐ |
| System Settings | ☐ | ☐ | ☐ |
| Firefox | ☐ | ☐ | ☐ |
| Nautilus (GTK) | ☐ | ☐ | ☐ |
| gedit (GTK) | ☐ | ☐ | ☐ |

### Animation Testing

| Animation | 60fps | Correct Duration | Correct Easing |
|-----------|-------|------------------|----------------|
| Window open | ☐ | ☐ | ☐ |
| Window close | ☐ | ☐ | ☐ |
| Modal open | ☐ | ☐ | ☐ |
| Menu open | ☐ | ☐ | ☐ |
| Desktop switch | ☐ | ☐ | ☐ |

---

## Sign-Off Checklist

Before release, all must pass:

- [ ] Color audit complete - all colors match spec
- [ ] Typography audit complete - correct fonts/sizes
- [ ] Spacing audit complete - 4px grid alignment
- [ ] Animation audit complete - timing correct
- [ ] Icon audit complete - all pass style check
- [ ] Accessibility audit complete - WCAG AA
- [ ] Cross-toolkit audit complete - GTK/Qt match
- [ ] Performance audit complete - 60fps animations

---

**Document Version:** 1.0  
**Last Updated:** August 2025  
**Owner:** UX Polish Team

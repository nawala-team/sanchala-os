# Sanchala Theming - File Structure

```
/usr/share/
├── plasma/desktoptheme/
│   ├── sanchala/
│   │   ├── metadata.json      # Theme metadata
│   │   ├── plasmarc           # Blur/transparency settings
│   │   └── colors             # Color definitions
│   └── sanchala-dark/
│       ├── metadata.json
│       ├── plasmarc
│       └── colors
│
├── themes/
│   ├── Sanchala/
│   │   ├── gtk-3.0/gtk.css    # GTK3 light theme
│   │   └── gtk-4.0/gtk.css    # GTK4 light theme
│   └── Sanchala-Dark/
│       ├── gtk-3.0/gtk.css    # GTK3 dark theme
│       └── gtk-4.0/gtk.css    # GTK4 dark theme
│
├── Kvantum/Sanchala/
│   ├── Sanchala.kvconfig      # Light Qt theme config
│   ├── SanchalaDark.kvconfig  # Dark Qt theme config
│   └── Sanchala.svg           # Widget graphics
│
└── color-schemes/
    ├── SanchalaLight.colors   # KDE color scheme (light)
    └── SanchalaDark.colors    # KDE color scheme (dark)

/usr/bin/
├── sanchala-theme-switch      # Theme switcher
├── sanchala-theme-auto        # Auto-switch daemon
└── sanchala-accent            # Accent color manager

/etc/sanchala/theming/
└── theming.conf               # System configuration

/usr/lib/systemd/user/
├── sanchala-theme.service     # Theme init service
└── sanchala-theme-auto.service # Auto-switch service

~/.config/sanchala/
└── theming.conf               # User configuration (override)

~/.cache/sanchala/theming/
├── current_mode               # Cached current mode
└── accent_color               # Cached accent color
```

## Theme Features

### Plasma Theme
- Adaptive blur (20-25px radius)
- Contrast enhancement
- OLED-optimized dark mode

### GTK Theme
- 8-12px rounded corners
- 150ms smooth transitions
- LibAdwaita color variables

### Kvantum Theme
- Native Qt5/Qt6 styling
- Animated widget states
- Translucent windows with blur

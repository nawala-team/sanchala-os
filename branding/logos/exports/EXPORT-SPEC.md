# 🖼️ Logo Export Specifications

## Required PNG Exports

Generate these from SVG source files:

### Full Logo (sanchala-logo.svg)
```bash
# Standard exports
rsvg-convert -w 1024 sanchala-logo.svg > exports/logo-1024.png
rsvg-convert -w 512 sanchala-logo.svg > exports/logo-512.png
rsvg-convert -w 256 sanchala-logo.svg > exports/logo-256.png
rsvg-convert -w 128 sanchala-logo.svg > exports/logo-128.png

# White variant
rsvg-convert -w 512 sanchala-logo-white.svg > exports/logo-white-512.png
rsvg-convert -w 256 sanchala-logo-white.svg > exports/logo-white-256.png
```

### Icon Only (sanchala-icon.svg)
```bash
# App icons
rsvg-convert -w 1024 sanchala-icon.svg > exports/icon-1024.png
rsvg-convert -w 512 sanchala-icon.svg > exports/icon-512.png
rsvg-convert -w 256 sanchala-icon.svg > exports/icon-256.png
rsvg-convert -w 128 sanchala-icon.svg > exports/icon-128.png
rsvg-convert -w 64 sanchala-icon.svg > exports/icon-64.png
rsvg-convert -w 48 sanchala-icon.svg > exports/icon-48.png
rsvg-convert -w 32 sanchala-icon.svg > exports/icon-32.png
rsvg-convert -w 16 sanchala-icon.svg > exports/icon-16.png
```

### Favicon Package
```bash
# Generate favicon sizes
rsvg-convert -w 32 sanchala-icon.svg > favicon/favicon-32.png
rsvg-convert -w 16 sanchala-icon.svg > favicon/favicon-16.png
rsvg-convert -w 180 sanchala-icon.svg > favicon/apple-touch-icon.png
rsvg-convert -w 192 sanchala-icon.svg > favicon/android-chrome-192.png
rsvg-convert -w 512 sanchala-icon.svg > favicon/android-chrome-512.png

# Create ICO (requires imagemagick)
convert favicon-16.png favicon-32.png favicon-48.png favicon.ico
```

### Social Media
```bash
# GitHub
rsvg-convert -w 500 sanchala-icon.svg > ../social-media/profiles/icon-github-500.png

# Twitter/X
rsvg-convert -w 400 sanchala-icon.svg > ../social-media/profiles/icon-twitter-400.png

# Banner
rsvg-convert -w 1280 -h 640 sanchala-banner.svg > ../social-media/banners/github-social-1280x640.png
```

## Alternative: Using Inkscape

```bash
inkscape sanchala-logo.svg --export-width=512 --export-filename=exports/logo-512.png
```

## Verification Checklist

- [ ] All PNG files are optimized (pngquant/optipng)
- [ ] No transparency issues on colored backgrounds
- [ ] Text remains legible at minimum sizes
- [ ] Colors match brand palette

---

*Run from branding/logos/ directory*

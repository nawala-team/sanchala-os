#!/usr/bin/env python3
"""Sanchala High Contrast - Accessibility Theme"""
import sys, os, subprocess

class HighContrast:
    def enable(self): subprocess.run(['gsettings', 'set', 'org.gnome.desktop.interface', 'gtk-theme', 'HighContrast'])
    def disable(self): subprocess.run(['gsettings', 'set', 'org.gnome.desktop.interface', 'gtk-theme', 'Breeze'])

if __name__ == "__main__":
    hc = HighContrast()
    if len(sys.argv) < 2: print("Usage: sanchala-high-contrast [on|off]")
    elif sys.argv[1] == "on": hc.enable()
    elif sys.argv[1] == "off": hc.disable()

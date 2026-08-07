#!/usr/bin/env python3
"""Sanchala Keyboard Shortcuts Help"""
import sys

SHORTCUTS = {
    'Super': 'Open App Launcher',
    'Super+A': 'Show Applications',
    'Super+E': 'File Manager',
    'Super+T': 'Terminal',
    'Super+L': 'Lock Screen',
    'Alt+Tab': 'Switch Windows',
    'Ctrl+Alt+T': 'New Terminal',
    'Print': 'Screenshot',
    'Super+Shift+S': 'Area Screenshot',
    'Ctrl+Q': 'Close App'
}

def show(): [print(f"  {k}: {v}") for k,v in SHORTCUTS.items()]

if __name__ == "__main__": show()

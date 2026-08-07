#!/usr/bin/env python3
"""Sanchala Tips & Tricks"""
import random

TIPS = [
    "Press Super to open the app launcher",
    "Use Super+E to open File Manager",
    "Super+L locks your screen",
    "Drag windows to edges to snap them",
    "Use workspaces to organize your windows",
    "Right-click the desktop for quick options",
    "Use Ctrl+Alt+T to open terminal",
    "Press Print Screen for screenshots",
    "Super+Tab switches between apps",
    "Use the search bar to find anything"
]

if __name__ == "__main__":
    print(f"💡 Tip: {random.choice(TIPS)}")

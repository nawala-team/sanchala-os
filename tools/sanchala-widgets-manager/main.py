#!/usr/bin/env python3
"""Sanchala Widgets Manager"""
import sys, os, subprocess

class WidgetsManager:
    def list_widgets(self):
        path = os.path.expanduser('~/.local/share/plasma/plasmoids')
        return os.listdir(path) if os.path.exists(path) else []
    def install(self, widget): subprocess.run(['kpackagetool5', '-i', widget])
    def remove(self, widget): subprocess.run(['kpackagetool5', '-r', widget])

if __name__ == "__main__":
    wm = WidgetsManager()
    if len(sys.argv) < 2: print(wm.list_widgets())
    elif sys.argv[1] == "install" and len(sys.argv) >= 3: wm.install(sys.argv[2])
    elif sys.argv[1] == "remove" and len(sys.argv) >= 3: wm.remove(sys.argv[2])

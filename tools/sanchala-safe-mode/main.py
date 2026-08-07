#!/usr/bin/env python3
"""Sanchala Safe Mode"""
import sys, os, subprocess

class SafeMode:
    def boot_safe(self): print("Reboot and select 'Sanchala Safe Mode' from GRUB menu")
    def disable_extensions(self):
        subprocess.run(['mv', os.path.expanduser('~/.local/share/gnome-shell/extensions'), os.path.expanduser('~/.local/share/gnome-shell/extensions.bak')])
    def reset_desktop(self):
        subprocess.run(['dconf', 'reset', '-f', '/org/gnome/'])

if __name__ == "__main__":
    sm = SafeMode()
    if len(sys.argv) < 2: sm.boot_safe()
    elif sys.argv[1] == "disable-ext": sm.disable_extensions()
    elif sys.argv[1] == "reset": sm.reset_desktop()

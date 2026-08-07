#!/usr/bin/env python3
"""Sanchala Sound Themes"""
import sys, os, subprocess

class SoundThemes:
    def list_themes(self):
        path = '/usr/share/sounds'
        return os.listdir(path) if os.path.exists(path) else []
    def set_theme(self, theme):
        subprocess.run(['gsettings', 'set', 'org.gnome.desktop.sound', 'theme-name', theme])
    def play_test(self):
        subprocess.run(['paplay', '/usr/share/sounds/freedesktop/stereo/bell.oga'])

if __name__ == "__main__":
    st = SoundThemes()
    if len(sys.argv) < 2: print(st.list_themes())
    elif sys.argv[1] == "set" and len(sys.argv) >= 3: st.set_theme(sys.argv[2])
    elif sys.argv[1] == "test": st.play_test()

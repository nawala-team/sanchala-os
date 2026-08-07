#!/usr/bin/env python3
"""Sanchala GRUB Customizer"""
import sys, os, subprocess

class GrubCustomizer:
    def open_gui(self):
        subprocess.Popen(['grub-customizer'])
    
    def set_timeout(self, seconds):
        subprocess.run(['sudo', 'sed', '-i', f's/GRUB_TIMEOUT=.*/GRUB_TIMEOUT={seconds}/', '/etc/default/grub'])
        self.update()
    
    def update(self):
        subprocess.run(['sudo', 'grub-mkconfig', '-o', '/boot/grub/grub.cfg'])
    
    def list_themes(self):
        theme_dir = '/usr/share/grub/themes'
        if os.path.exists(theme_dir): return os.listdir(theme_dir)
        return []

if __name__ == "__main__":
    gc = GrubCustomizer()
    if len(sys.argv) < 2: gc.open_gui()
    elif sys.argv[1] == "timeout" and len(sys.argv) >= 3: gc.set_timeout(sys.argv[2])
    elif sys.argv[1] == "update": gc.update()
    elif sys.argv[1] == "themes": print(gc.list_themes())

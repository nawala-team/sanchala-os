#!/usr/bin/env python3
"""Sanchala Startup Manager"""
import sys, os

class StartupManager:
    def __init__(self): self.dir = os.path.expanduser('~/.config/autostart'); os.makedirs(self.dir, exist_ok=True)
    def list_apps(self): return [f.replace('.desktop','') for f in os.listdir(self.dir) if f.endswith('.desktop')]
    def add(self, name, cmd):
        with open(os.path.join(self.dir, f'{name}.desktop'), 'w') as f:
            f.write(f'[Desktop Entry]\nType=Application\nName={name}\nExec={cmd}\nX-GNOME-Autostart-enabled=true\n')
    def remove(self, name): os.remove(os.path.join(self.dir, f'{name}.desktop'))
    def disable(self, name):
        path = os.path.join(self.dir, f'{name}.desktop')
        with open(path) as f: content = f.read()
        with open(path, 'w') as f: f.write(content.replace('enabled=true', 'enabled=false'))

if __name__ == "__main__":
    sm = StartupManager()
    if len(sys.argv) < 2: [print(f"  {a}") for a in sm.list_apps()]
    elif sys.argv[1] == "add" and len(sys.argv) >= 4: sm.add(sys.argv[2], ' '.join(sys.argv[3:]))
    elif sys.argv[1] == "remove" and len(sys.argv) >= 3: sm.remove(sys.argv[2])
    elif sys.argv[1] == "disable" and len(sys.argv) >= 3: sm.disable(sys.argv[2])

#!/usr/bin/env python3
"""Sanchala SDK - Development Kit"""
import sys, os, subprocess

class SDK:
    def create_app(self, name):
        os.makedirs(name, exist_ok=True)
        with open(f"{name}/main.py", 'w') as f:
            f.write(f'#!/usr/bin/env python3\n"""Sanchala App: {name}"""\nprint("Hello from {name}")\n')
        with open(f"{name}/{name}.desktop", 'w') as f:
            f.write(f'[Desktop Entry]\nName={name}\nExec=python3 /opt/sanchala/{name}/main.py\nType=Application\n')
        print(f"App '{name}' created")
    def build(self, path): print(f"Building {path}...")
    def install(self, path): subprocess.run(['sudo', 'cp', '-r', path, '/opt/sanchala/'])

if __name__ == "__main__":
    sdk = SDK()
    if len(sys.argv) < 2: print("Sanchala SDK - Usage: sanchala-sdk [create NAME|build PATH|install PATH]")
    elif sys.argv[1] == "create" and len(sys.argv) >= 3: sdk.create_app(sys.argv[2])
    elif sys.argv[1] == "build" and len(sys.argv) >= 3: sdk.build(sys.argv[2])
    elif sys.argv[1] == "install" and len(sys.argv) >= 3: sdk.install(sys.argv[2])

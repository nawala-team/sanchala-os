#!/usr/bin/env python3
"""Sanchala Kernel Manager"""
import sys, os, subprocess

class KernelManager:
    def current(self):
        result = subprocess.run(['uname', '-r'], capture_output=True, text=True)
        return result.stdout.strip()
    
    def list_installed(self):
        result = subprocess.run(['pacman', '-Q'], capture_output=True, text=True)
        return [l for l in result.stdout.split('\n') if 'linux' in l.lower() and 'kernel' not in l.lower()]
    
    def install_lts(self):
        subprocess.run(['sudo', 'pacman', '-S', 'linux-lts', 'linux-lts-headers'])
    
    def install_zen(self):
        subprocess.run(['sudo', 'pacman', '-S', 'linux-zen', 'linux-zen-headers'])

if __name__ == "__main__":
    km = KernelManager()
    if len(sys.argv) < 2:
        print(f"Current: {km.current()}")
        print("Installed:"); [print(f"  {k}") for k in km.list_installed()]
    elif sys.argv[1] == "lts": km.install_lts()
    elif sys.argv[1] == "zen": km.install_zen()

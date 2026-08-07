#!/usr/bin/env python3
"""Sanchala USB Boot Creator"""
import sys, os, subprocess

class USBBootCreator:
    def list_drives(self): return subprocess.run(['lsblk', '-d', '-o', 'NAME,SIZE,TYPE'], capture_output=True, text=True).stdout
    def create(self, iso, device):
        print(f"Writing {iso} to {device}...")
        subprocess.run(['sudo', 'dd', f'if={iso}', f'of={device}', 'bs=4M', 'status=progress', 'oflag=sync'])
    def open_gui(self): subprocess.Popen(['gnome-disks'])

if __name__ == "__main__":
    ubc = USBBootCreator()
    if len(sys.argv) < 2: print(ubc.list_drives())
    elif sys.argv[1] == "create" and len(sys.argv) >= 4: ubc.create(sys.argv[2], sys.argv[3])
    elif sys.argv[1] == "gui": ubc.open_gui()

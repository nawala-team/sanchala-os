#!/usr/bin/env python3
"""Sanchala Instant Hotspot"""
import sys, os, subprocess

class InstantHotspot:
    def start(self, ssid='Sanchala', password='sanchala123'):
        subprocess.run(['nmcli', 'dev', 'wifi', 'hotspot', 'ssid', ssid, 'password', password])
        print(f"Hotspot '{ssid}' started")
    
    def stop(self):
        subprocess.run(['nmcli', 'con', 'down', 'Hotspot'])
        print("Hotspot stopped")
    
    def status(self):
        result = subprocess.run(['nmcli', 'con', 'show', '--active'], capture_output=True, text=True)
        return 'Hotspot' in result.stdout

if __name__ == "__main__":
    ih = InstantHotspot()
    if len(sys.argv) < 2: print(f"Hotspot: {'Active' if ih.status() else 'Inactive'}")
    elif sys.argv[1] == "start": ih.start(sys.argv[2] if len(sys.argv) > 2 else 'Sanchala', sys.argv[3] if len(sys.argv) > 3 else 'sanchala123')
    elif sys.argv[1] == "stop": ih.stop()

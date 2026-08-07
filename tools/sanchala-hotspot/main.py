#!/usr/bin/env python3
"""Sanchala Hotspot - WiFi Hotspot"""
import sys, os, subprocess

class Hotspot:
    def start(self, ssid='SanchalaHotspot', password='sanchala123'):
        subprocess.run(['nmcli', 'dev', 'wifi', 'hotspot', 'ssid', ssid, 'password', password])
    def stop(self): subprocess.run(['nmcli', 'con', 'down', 'Hotspot'])
    def status(self): return subprocess.run(['nmcli', 'con', 'show', '--active'], capture_output=True, text=True).stdout

if __name__ == "__main__":
    hs = Hotspot()
    if len(sys.argv) < 2: print(hs.status())
    elif sys.argv[1] == "start": hs.start(sys.argv[2] if len(sys.argv)>2 else 'SanchalaHotspot', sys.argv[3] if len(sys.argv)>3 else 'sanchala123')
    elif sys.argv[1] == "stop": hs.stop()

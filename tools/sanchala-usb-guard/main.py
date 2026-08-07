#!/usr/bin/env python3
"""Sanchala USB Guard - USB Security"""
import sys, os, subprocess

class USBGuard:
    def list_devices(self): return subprocess.run(['usbguard', 'list-devices'], capture_output=True, text=True).stdout
    def allow(self, id): subprocess.run(['usbguard', 'allow-device', id])
    def block(self, id): subprocess.run(['usbguard', 'block-device', id])
    def rules(self): return subprocess.run(['usbguard', 'list-rules'], capture_output=True, text=True).stdout

if __name__ == "__main__":
    ug = USBGuard()
    if len(sys.argv) < 2: print(ug.list_devices())
    elif sys.argv[1] == "allow" and len(sys.argv) >= 3: ug.allow(sys.argv[2])
    elif sys.argv[1] == "block" and len(sys.argv) >= 3: ug.block(sys.argv[2])
    elif sys.argv[1] == "rules": print(ug.rules())

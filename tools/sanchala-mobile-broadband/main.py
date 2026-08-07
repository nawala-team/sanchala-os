#!/usr/bin/env python3
"""Sanchala Mobile Broadband"""
import sys, os, subprocess

class MobileBroadband:
    def list_modems(self):
        result = subprocess.run(['mmcli', '-L'], capture_output=True, text=True)
        return result.stdout
    
    def connect(self, apn):
        subprocess.run(['nmcli', 'con', 'add', 'type', 'gsm', 'con-name', 'mobile', 'apn', apn])
        subprocess.run(['nmcli', 'con', 'up', 'mobile'])
    
    def disconnect(self):
        subprocess.run(['nmcli', 'con', 'down', 'mobile'])
    
    def status(self):
        result = subprocess.run(['mmcli', '-m', '0'], capture_output=True, text=True)
        return result.stdout

if __name__ == "__main__":
    mb = MobileBroadband()
    if len(sys.argv) < 2: print(mb.list_modems())
    elif sys.argv[1] == "connect" and len(sys.argv) >= 3: mb.connect(sys.argv[2])
    elif sys.argv[1] == "disconnect": mb.disconnect()
    elif sys.argv[1] == "status": print(mb.status())

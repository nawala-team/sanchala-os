#!/usr/bin/env python3
"""Sanchala Phone Link - Connect Android/iOS"""
import sys, os, subprocess

class PhoneLink:
    def start_kdeconnect(self):
        subprocess.Popen(['kdeconnect-app'])
    
    def list_devices(self):
        result = subprocess.run(['kdeconnect-cli', '-l'], capture_output=True, text=True)
        return result.stdout
    
    def send_file(self, device_id, filepath):
        subprocess.run(['kdeconnect-cli', '-d', device_id, '--share', filepath])
    
    def ping(self, device_id):
        subprocess.run(['kdeconnect-cli', '-d', device_id, '--ping'])

if __name__ == "__main__":
    pl = PhoneLink()
    if len(sys.argv) < 2: pl.start_kdeconnect()
    elif sys.argv[1] == "devices": print(pl.list_devices())
    elif sys.argv[1] == "send" and len(sys.argv) >= 4: pl.send_file(sys.argv[2], sys.argv[3])
    elif sys.argv[1] == "ping" and len(sys.argv) >= 3: pl.ping(sys.argv[2])

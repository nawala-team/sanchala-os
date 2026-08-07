#!/usr/bin/env python3
"""Sanchala Bluetooth Manager - Bluetooth Control"""
import sys, os, subprocess

class BluetoothManager:
    def power_on(self):
        subprocess.run(['bluetoothctl', 'power', 'on'])
    
    def power_off(self):
        subprocess.run(['bluetoothctl', 'power', 'off'])
    
    def scan(self, timeout=10):
        subprocess.run(['bluetoothctl', 'scan', 'on'], timeout=timeout)
    
    def list_devices(self):
        result = subprocess.run(['bluetoothctl', 'devices'], capture_output=True, text=True)
        return result.stdout
    
    def connect(self, mac):
        result = subprocess.run(['bluetoothctl', 'connect', mac], capture_output=True, text=True)
        return 'successful' in result.stdout.lower()
    
    def disconnect(self, mac):
        subprocess.run(['bluetoothctl', 'disconnect', mac])
    
    def pair(self, mac):
        subprocess.run(['bluetoothctl', 'pair', mac])
    
    def trust(self, mac):
        subprocess.run(['bluetoothctl', 'trust', mac])
    
    def status(self):
        result = subprocess.run(['bluetoothctl', 'show'], capture_output=True, text=True)
        return result.stdout

if __name__ == "__main__":
    bt = BluetoothManager()
    if len(sys.argv) < 2:
        print("Sanchala Bluetooth Manager")
        print("Usage: sanchala-bluetooth-manager [on|off|scan|list|connect MAC|disconnect MAC|status]")
    elif sys.argv[1] == "on": bt.power_on(); print("Bluetooth ON")
    elif sys.argv[1] == "off": bt.power_off(); print("Bluetooth OFF")
    elif sys.argv[1] == "scan": print("Scanning..."); bt.scan()
    elif sys.argv[1] == "list": print(bt.list_devices())
    elif sys.argv[1] == "connect" and len(sys.argv) >= 3:
        if bt.connect(sys.argv[2]): print("Connected")
        else: print("Failed to connect")
    elif sys.argv[1] == "disconnect" and len(sys.argv) >= 3:
        bt.disconnect(sys.argv[2]); print("Disconnected")
    elif sys.argv[1] == "status": print(bt.status())

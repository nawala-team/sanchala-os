#!/usr/bin/env python3
"""Sanchala Network Settings"""
import sys, os, subprocess

class NetworkSettings:
    def list_connections(self):
        result = subprocess.run(['nmcli', 'con', 'show'], capture_output=True, text=True)
        return result.stdout
    
    def connect_wifi(self, ssid, password):
        subprocess.run(['nmcli', 'dev', 'wifi', 'connect', ssid, 'password', password])
    
    def disconnect(self):
        subprocess.run(['nmcli', 'dev', 'disconnect', 'wlan0'])
    
    def list_wifi(self):
        result = subprocess.run(['nmcli', 'dev', 'wifi', 'list'], capture_output=True, text=True)
        return result.stdout
    
    def open_gui(self):
        subprocess.Popen(['nm-connection-editor'])

if __name__ == "__main__":
    ns = NetworkSettings()
    if len(sys.argv) < 2: print(ns.list_connections())
    elif sys.argv[1] == "wifi": print(ns.list_wifi())
    elif sys.argv[1] == "connect" and len(sys.argv) >= 4: ns.connect_wifi(sys.argv[2], sys.argv[3])
    elif sys.argv[1] == "gui": ns.open_gui()

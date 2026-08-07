#!/usr/bin/env python3
"""Sanchala WiFi Analyzer"""
import sys, os, subprocess

class WiFiAnalyzer:
    def scan(self): return subprocess.run(['nmcli', 'dev', 'wifi', 'list'], capture_output=True, text=True).stdout
    def signal_strength(self): return subprocess.run(['iwconfig', 'wlan0'], capture_output=True, text=True).stdout
    def open_gui(self): subprocess.Popen(['linssid'])

if __name__ == "__main__":
    wa = WiFiAnalyzer()
    if len(sys.argv) < 2: print(wa.scan())
    elif sys.argv[1] == "signal": print(wa.signal_strength())
    elif sys.argv[1] == "gui": wa.open_gui()

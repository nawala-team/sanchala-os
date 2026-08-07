#!/usr/bin/env python3
"""Sanchala Energy Settings - Power Management"""
import sys, os, subprocess

class EnergySettings:
    def get_profile(self):
        result = subprocess.run(['powerprofilesctl', 'get'], capture_output=True, text=True)
        return result.stdout.strip()
    
    def set_profile(self, profile):
        subprocess.run(['powerprofilesctl', 'set', profile])
    
    def list_profiles(self):
        result = subprocess.run(['powerprofilesctl', 'list'], capture_output=True, text=True)
        return result.stdout
    
    def get_battery(self):
        result = subprocess.run(['upower', '-i', '/org/freedesktop/UPower/devices/battery_BAT0'], capture_output=True, text=True)
        return result.stdout

if __name__ == "__main__":
    es = EnergySettings()
    if len(sys.argv) < 2:
        print(f"Current: {es.get_profile()}")
        print(es.list_profiles())
    elif sys.argv[1] == "set" and len(sys.argv) >= 3: es.set_profile(sys.argv[2])
    elif sys.argv[1] == "battery": print(es.get_battery())

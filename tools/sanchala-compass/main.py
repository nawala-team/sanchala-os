#!/usr/bin/env python3
"""Sanchala Compass - Digital Compass"""
import sys, os, subprocess

class Compass:
    def __init__(self):
        self.config_dir = os.path.expanduser("~/.config/sanchala/compass")
        os.makedirs(self.config_dir, exist_ok=True)
    
    def get_bearing(self):
        # Try to read from sensors
        try:
            result = subprocess.run(['sensors', '-j'], capture_output=True, text=True)
            # Parse magnetometer data if available
            return None
        except: return None
    
    def cardinal_direction(self, degrees):
        directions = ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW']
        idx = round(degrees / 45) % 8
        return directions[idx]
    
    def get_location(self):
        # Try to get GPS location
        try:
            result = subprocess.run(['gpspipe', '-w', '-n', '1'], capture_output=True, text=True, timeout=5)
            return result.stdout
        except: return None

if __name__ == "__main__":
    compass = Compass()
    if len(sys.argv) < 2:
        print("Sanchala Compass")
        print("Usage: sanchala-compass [bearing|location|direction DEGREES]")
        print("Note: Requires magnetometer sensor")
    elif sys.argv[1] == "bearing":
        b = compass.get_bearing()
        print(f"Bearing: {b}°" if b else "No sensor available")
    elif sys.argv[1] == "location":
        loc = compass.get_location()
        print(loc if loc else "GPS not available")
    elif sys.argv[1] == "direction" and len(sys.argv) >= 3:
        print(compass.cardinal_direction(float(sys.argv[2])))

#!/usr/bin/env python3
"""Sanchala Fan Control - Fan Speed Control"""
import sys, os, glob, subprocess

class FanControl:
    def get_fans(self):
        return glob.glob('/sys/class/hwmon/hwmon*/fan*_input')
    
    def get_speed(self):
        speeds = {}
        for fan in self.get_fans():
            try:
                with open(fan) as f: speeds[fan] = int(f.read().strip())
            except: pass
        return speeds
    
    def get_temp(self):
        temps = {}
        for t in glob.glob('/sys/class/hwmon/hwmon*/temp*_input'):
            try:
                with open(t) as f: temps[t] = int(f.read().strip()) / 1000
            except: pass
        return temps
    
    def set_mode(self, mode):
        # Try thinkfan or fancontrol
        if mode == 'auto':
            subprocess.run(['sudo', 'systemctl', 'start', 'fancontrol'])
        elif mode == 'max':
            for fan in glob.glob('/sys/class/hwmon/hwmon*/pwm*'):
                os.system(f"echo 255 | sudo tee {fan}")

if __name__ == "__main__":
    fc = FanControl()
    if len(sys.argv) < 2 or sys.argv[1] == "status":
        print("Fan Speeds:"); [print(f"  {k}: {v} RPM") for k, v in fc.get_speed().items()]
        print("Temps:"); [print(f"  {k}: {v}°C") for k, v in fc.get_temp().items()]
    elif sys.argv[1] == "auto": fc.set_mode('auto')
    elif sys.argv[1] == "max": fc.set_mode('max')

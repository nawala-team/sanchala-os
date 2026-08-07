#!/usr/bin/env python3
"""Sanchala Controller Config - Game Controller Settings"""
import sys, os, subprocess, json

class ControllerConfig:
    def __init__(self):
        self.config_dir = os.path.expanduser("~/.config/sanchala/controller")
        os.makedirs(self.config_dir, exist_ok=True)
    
    def list_controllers(self):
        result = subprocess.run(['cat', '/proc/bus/input/devices'], capture_output=True, text=True)
        return [l for l in result.stdout.split('\n') if 'Gamepad' in l or 'Joystick' in l or 'Controller' in l]
    
    def test_controller(self):
        subprocess.run(['jstest', '/dev/input/js0'])
    
    def calibrate(self):
        subprocess.run(['jscal', '-c', '/dev/input/js0'])
    
    def remap(self, config_file):
        subprocess.run(['antimicrox', '--profile', config_file])
    
    def open_gui(self):
        for app in ['antimicrox', 'jstest-gtk', 'sc-controller']:
            try: subprocess.Popen([app]); return True
            except: continue
        return False

if __name__ == "__main__":
    cc = ControllerConfig()
    if len(sys.argv) < 2:
        print("Sanchala Controller Config")
        print("Usage: sanchala-controller-config [list|test|calibrate|gui|remap FILE]")
    elif sys.argv[1] == "list":
        for c in cc.list_controllers(): print(f"  {c}")
    elif sys.argv[1] == "test": cc.test_controller()
    elif sys.argv[1] == "calibrate": cc.calibrate()
    elif sys.argv[1] == "gui": cc.open_gui()
    elif sys.argv[1] == "remap" and len(sys.argv) >= 3: cc.remap(sys.argv[2])

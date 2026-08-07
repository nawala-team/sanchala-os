#!/usr/bin/env python3
"""Sanchala KVM Switch - Input Device Switching"""
import sys, os, subprocess

class KVMSwitch:
    def list_inputs(self):
        result = subprocess.run(['xinput', 'list'], capture_output=True, text=True)
        return result.stdout
    
    def switch_to(self, device_id):
        subprocess.run(['xinput', 'enable', str(device_id)])
    
    def disable(self, device_id):
        subprocess.run(['xinput', 'disable', str(device_id)])

if __name__ == "__main__":
    kvm = KVMSwitch()
    if len(sys.argv) < 2: print(kvm.list_inputs())
    elif sys.argv[1] == "enable" and len(sys.argv) >= 3: kvm.switch_to(sys.argv[2])
    elif sys.argv[1] == "disable" and len(sys.argv) >= 3: kvm.disable(sys.argv[2])

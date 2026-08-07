#!/usr/bin/env python3
"""Sanchala Driver Manager - Hardware Driver Management"""
import sys, os, subprocess

class DriverManager:
    def list_hardware(self):
        return subprocess.run(['lspci', '-v'], capture_output=True, text=True).stdout
    
    def list_modules(self):
        return subprocess.run(['lsmod'], capture_output=True, text=True).stdout
    
    def load_module(self, module):
        subprocess.run(['sudo', 'modprobe', module])
    
    def unload_module(self, module):
        subprocess.run(['sudo', 'modprobe', '-r', module])
    
    def detect_gpu(self):
        result = subprocess.run(['lspci', '-v'], capture_output=True, text=True)
        gpus = [l for l in result.stdout.split('\n') if 'VGA' in l or '3D' in l]
        return gpus
    
    def install_nvidia(self):
        subprocess.run(['sudo', 'pacman', '-S', 'nvidia', 'nvidia-utils', 'nvidia-settings'])
    
    def install_amd(self):
        subprocess.run(['sudo', 'pacman', '-S', 'mesa', 'vulkan-radeon', 'libva-mesa-driver'])

if __name__ == "__main__":
    dm = DriverManager()
    if len(sys.argv) < 2:
        print("Sanchala Driver Manager")
        print("GPUs:", dm.detect_gpu())
    elif sys.argv[1] == "hardware": print(dm.list_hardware())
    elif sys.argv[1] == "modules": print(dm.list_modules())
    elif sys.argv[1] == "load" and len(sys.argv) >= 3: dm.load_module(sys.argv[2])
    elif sys.argv[1] == "unload" and len(sys.argv) >= 3: dm.unload_module(sys.argv[2])
    elif sys.argv[1] == "nvidia": dm.install_nvidia()
    elif sys.argv[1] == "amd": dm.install_amd()

#!/usr/bin/env python3
"""Sanchala GPU Detect"""
import sys, subprocess

class GPUDetect:
    def detect(self):
        result = subprocess.run(['lspci', '-v'], capture_output=True, text=True)
        gpus = [l for l in result.stdout.split('\n') if 'VGA' in l or '3D' in l]
        return gpus
    
    def get_driver(self):
        result = subprocess.run(['glxinfo'], capture_output=True, text=True)
        for line in result.stdout.split('\n'):
            if 'OpenGL renderer' in line: return line
        return "Unknown"
    
    def nvidia_info(self):
        result = subprocess.run(['nvidia-smi'], capture_output=True, text=True)
        return result.stdout

if __name__ == "__main__":
    gd = GPUDetect()
    if len(sys.argv) < 2:
        print("Detected GPUs:")
        for gpu in gd.detect(): print(f"  {gpu}")
        print(f"Driver: {gd.get_driver()}")
    elif sys.argv[1] == "nvidia": print(gd.nvidia_info())

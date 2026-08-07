#!/usr/bin/env python3
"""Sanchala GPU Control - GPU Management"""
import sys, os, subprocess

class GPUControl:
    def get_info(self):
        # Try nvidia-smi first
        result = subprocess.run(['nvidia-smi', '--query-gpu=name,temperature.gpu,utilization.gpu,memory.used,memory.total', '--format=csv,noheader'], capture_output=True, text=True)
        if result.returncode == 0: return result.stdout
        # Try AMD
        result = subprocess.run(['radeontop', '-d', '-'], capture_output=True, text=True)
        return result.stdout if result.returncode == 0 else "No GPU info available"
    
    def set_profile(self, profile):
        if profile == 'performance':
            subprocess.run(['nvidia-settings', '-a', 'GPUPowerMizerMode=1'])
        elif profile == 'balanced':
            subprocess.run(['nvidia-settings', '-a', 'GPUPowerMizerMode=0'])
    
    def get_temp(self):
        result = subprocess.run(['nvidia-smi', '--query-gpu=temperature.gpu', '--format=csv,noheader'], capture_output=True, text=True)
        return result.stdout.strip() + "°C" if result.returncode == 0 else "N/A"

if __name__ == "__main__":
    gpu = GPUControl()
    if len(sys.argv) < 2: print(gpu.get_info())
    elif sys.argv[1] == "temp": print(f"GPU Temp: {gpu.get_temp()}")
    elif sys.argv[1] == "profile" and len(sys.argv) >= 3: gpu.set_profile(sys.argv[2])

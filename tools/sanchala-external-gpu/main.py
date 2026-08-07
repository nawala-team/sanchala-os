#!/usr/bin/env python3
"""Sanchala External GPU - eGPU Management"""
import sys, os, subprocess

class ExternalGPU:
    def detect(self):
        result = subprocess.run(['lspci'], capture_output=True, text=True)
        return [l for l in result.stdout.split('\n') if 'VGA' in l or '3D' in l]
    
    def authorize(self):
        # Authorize Thunderbolt eGPU
        subprocess.run(['sudo', 'boltctl', 'authorize', '--all'])
    
    def status(self):
        return subprocess.run(['boltctl', 'list'], capture_output=True, text=True).stdout
    
    def set_primary(self, gpu_id):
        # Set primary GPU via switcheroo
        subprocess.run(['sudo', 'system76-power', 'graphics', 'compute'])

if __name__ == "__main__":
    egpu = ExternalGPU()
    if len(sys.argv) < 2:
        print("Sanchala External GPU")
        print("GPUs:"); [print(f"  {g}") for g in egpu.detect()]
    elif sys.argv[1] == "status": print(egpu.status())
    elif sys.argv[1] == "authorize": egpu.authorize()

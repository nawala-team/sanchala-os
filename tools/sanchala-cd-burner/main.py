#!/usr/bin/env python3
"""Sanchala CD Burner - Disc Burning Tool"""
import sys, os, subprocess

class CDBurner:
    def list_devices(self):
        result = subprocess.run(['wodim', '--devices'], capture_output=True, text=True)
        return result.stdout
    
    def burn_iso(self, iso_path, device='/dev/sr0', speed=4):
        cmd = ['wodim', f'dev={device}', f'speed={speed}', '-v', iso_path]
        return subprocess.run(cmd)
    
    def burn_audio(self, files, device='/dev/sr0'):
        cmd = ['wodim', f'dev={device}', '-audio', '-pad'] + files
        return subprocess.run(cmd)
    
    def erase_disc(self, device='/dev/sr0', fast=True):
        mode = 'fast' if fast else 'all'
        return subprocess.run(['wodim', f'dev={device}', f'blank={mode}'])
    
    def create_iso(self, source_dir, output):
        return subprocess.run(['genisoimage', '-o', output, '-J', '-r', source_dir])

if __name__ == "__main__":
    burner = CDBurner()
    if len(sys.argv) < 2:
        print("Sanchala CD Burner")
        print("Usage: sanchala-cd-burner [devices|burn ISO|audio FILE...|erase|mkiso DIR OUTPUT]")
    elif sys.argv[1] == "devices": print(burner.list_devices())
    elif sys.argv[1] == "burn" and len(sys.argv) >= 3: burner.burn_iso(sys.argv[2])
    elif sys.argv[1] == "audio" and len(sys.argv) >= 3: burner.burn_audio(sys.argv[2:])
    elif sys.argv[1] == "erase": burner.erase_disc()
    elif sys.argv[1] == "mkiso" and len(sys.argv) >= 4: burner.create_iso(sys.argv[2], sys.argv[3])

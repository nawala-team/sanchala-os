#!/usr/bin/env python3
"""Sanchala Hardware Test"""
import sys, os, subprocess

class HardwareTest:
    def test_cpu(self):
        print("Testing CPU...")
        subprocess.run(['stress', '--cpu', '4', '--timeout', '10'])
    
    def test_memory(self):
        print("Testing Memory...")
        subprocess.run(['memtester', '100M', '1'])
    
    def test_disk(self, device):
        print(f"Testing Disk {device}...")
        subprocess.run(['sudo', 'smartctl', '-t', 'short', device])
    
    def test_gpu(self):
        print("Testing GPU...")
        subprocess.run(['glmark2'])
    
    def full_report(self):
        return subprocess.run(['inxi', '-Fxz'], capture_output=True, text=True).stdout

if __name__ == "__main__":
    ht = HardwareTest()
    if len(sys.argv) < 2: print(ht.full_report())
    elif sys.argv[1] == "cpu": ht.test_cpu()
    elif sys.argv[1] == "memory": ht.test_memory()
    elif sys.argv[1] == "disk" and len(sys.argv) >= 3: ht.test_disk(sys.argv[2])
    elif sys.argv[1] == "gpu": ht.test_gpu()

#!/usr/bin/env python3
"""Sanchala Memory Test"""
import sys, os, subprocess

class MemoryTest:
    def quick_test(self):
        subprocess.run(['memtester', '100M', '1'])
    
    def full_test(self):
        print("Run memtest86+ from GRUB boot menu for full test")
    
    def get_info(self):
        result = subprocess.run(['free', '-h'], capture_output=True, text=True)
        return result.stdout

if __name__ == "__main__":
    mt = MemoryTest()
    if len(sys.argv) < 2: print(mt.get_info())
    elif sys.argv[1] == "test": mt.quick_test()
    elif sys.argv[1] == "full": mt.full_test()

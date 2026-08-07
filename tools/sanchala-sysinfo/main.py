#!/usr/bin/env python3
"""Sanchala System Info"""
import sys, os, subprocess

class SysInfo:
    def full_report(self): return subprocess.run(['neofetch', '--stdout'], capture_output=True, text=True).stdout
    def cpu(self): return subprocess.run(['lscpu'], capture_output=True, text=True).stdout
    def memory(self): return subprocess.run(['free', '-h'], capture_output=True, text=True).stdout
    def disk(self): return subprocess.run(['df', '-h'], capture_output=True, text=True).stdout
    def gpu(self): return subprocess.run(['lspci', '-v'], capture_output=True, text=True).stdout

if __name__ == "__main__":
    si = SysInfo()
    if len(sys.argv) < 2: print(si.full_report())
    elif sys.argv[1] == "cpu": print(si.cpu())
    elif sys.argv[1] == "mem": print(si.memory())
    elif sys.argv[1] == "disk": print(si.disk())

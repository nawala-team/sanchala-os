#!/usr/bin/env python3
"""Sanchala Microcode Updater"""
import sys, os, subprocess

class MicrocodeUpdater:
    def detect_cpu(self):
        result = subprocess.run(['grep', 'vendor_id', '/proc/cpuinfo'], capture_output=True, text=True)
        return 'Intel' if 'Intel' in result.stdout else 'AMD'
    
    def install(self):
        cpu = self.detect_cpu()
        pkg = 'intel-ucode' if cpu == 'Intel' else 'amd-ucode'
        subprocess.run(['sudo', 'pacman', '-S', '--noconfirm', pkg])
        subprocess.run(['sudo', 'grub-mkconfig', '-o', '/boot/grub/grub.cfg'])
    
    def check_version(self):
        result = subprocess.run(['dmesg'], capture_output=True, text=True)
        for line in result.stdout.split('\n'):
            if 'microcode' in line.lower(): return line
        return "No microcode info found"

if __name__ == "__main__":
    mu = MicrocodeUpdater()
    if len(sys.argv) < 2: print(f"CPU: {mu.detect_cpu()}\n{mu.check_version()}")
    elif sys.argv[1] == "install": mu.install()

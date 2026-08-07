#!/usr/bin/env python3
"""Sanchala Log Cleaner"""
import sys, os, subprocess

class LogCleaner:
    def clean_journal(self, days=7):
        subprocess.run(['sudo', 'journalctl', '--vacuum-time', f'{days}d'])
    
    def clean_pacman(self):
        subprocess.run(['sudo', 'pacman', '-Sc', '--noconfirm'])
    
    def get_size(self):
        result = subprocess.run(['journalctl', '--disk-usage'], capture_output=True, text=True)
        return result.stdout
    
    def clean_all(self):
        self.clean_journal()
        self.clean_pacman()
        print("Logs cleaned")

if __name__ == "__main__":
    lc = LogCleaner()
    if len(sys.argv) < 2: print(lc.get_size())
    elif sys.argv[1] == "clean": lc.clean_all()
    elif sys.argv[1] == "journal": lc.clean_journal(int(sys.argv[2]) if len(sys.argv) > 2 else 7)
    elif sys.argv[1] == "pacman": lc.clean_pacman()

#!/usr/bin/env python3
"""Sanchala Plymouth Manager - Boot Splash"""
import sys, os, subprocess

class PlymouthManager:
    def list_themes(self):
        result = subprocess.run(['plymouth-set-default-theme', '--list'], capture_output=True, text=True)
        return result.stdout
    
    def set_theme(self, theme):
        subprocess.run(['sudo', 'plymouth-set-default-theme', '-R', theme])
    
    def preview(self, theme):
        subprocess.run(['sudo', 'plymouthd'])
        subprocess.run(['sudo', 'plymouth', '--show-splash'])
    
    def get_current(self):
        result = subprocess.run(['plymouth-set-default-theme'], capture_output=True, text=True)
        return result.stdout.strip()

if __name__ == "__main__":
    pm = PlymouthManager()
    if len(sys.argv) < 2:
        print(f"Current: {pm.get_current()}")
        print(pm.list_themes())
    elif sys.argv[1] == "set" and len(sys.argv) >= 3: pm.set_theme(sys.argv[2])
    elif sys.argv[1] == "preview" and len(sys.argv) >= 3: pm.preview(sys.argv[2])

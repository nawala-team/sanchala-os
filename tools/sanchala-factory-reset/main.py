#!/usr/bin/env python3
"""Sanchala Factory Reset"""
import sys, os, subprocess

class FactoryReset:
    def reset_settings(self):
        config_dir = os.path.expanduser("~/.config")
        print(f"This will reset all settings in {config_dir}")
        if input("Type YES to confirm: ") == "YES":
            subprocess.run(['rm', '-rf', os.path.join(config_dir, 'sanchala')])
            print("Settings reset complete")
    
    def full_reset(self):
        print("WARNING: Full factory reset requires reinstallation")
        print("Boot from Sanchala OS installation media and choose 'Reset'")

if __name__ == "__main__":
    fr = FactoryReset()
    if len(sys.argv) < 2:
        print("Sanchala Factory Reset")
        print("Usage: sanchala-factory-reset [settings|full]")
    elif sys.argv[1] == "settings": fr.reset_settings()
    elif sys.argv[1] == "full": fr.full_reset()

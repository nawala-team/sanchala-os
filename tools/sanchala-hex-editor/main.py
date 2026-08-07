#!/usr/bin/env python3
"""Sanchala Hex Editor - Binary File Editor"""
import sys, os, subprocess

class HexEditor:
    def open_gui(self, filepath=None):
        cmd = ['ghex'] if not filepath else ['ghex', filepath]
        for app in ['ghex', 'bless', 'okteta']:
            try:
                subprocess.Popen([app] + ([filepath] if filepath else []))
                return
            except: continue
    
    def hexdump(self, filepath, length=256):
        result = subprocess.run(['hexdump', '-C', '-n', str(length), filepath], capture_output=True, text=True)
        return result.stdout
    
    def xxd(self, filepath):
        result = subprocess.run(['xxd', filepath], capture_output=True, text=True)
        return result.stdout
    
    def patch(self, filepath, offset, hex_bytes):
        with open(filepath, 'r+b') as f:
            f.seek(int(offset, 16))
            f.write(bytes.fromhex(hex_bytes))

if __name__ == "__main__":
    he = HexEditor()
    if len(sys.argv) < 2: he.open_gui()
    elif sys.argv[1] == "open": he.open_gui(sys.argv[2] if len(sys.argv) > 2 else None)
    elif sys.argv[1] == "dump" and len(sys.argv) >= 3: print(he.hexdump(sys.argv[2]))
    elif sys.argv[1] == "xxd" and len(sys.argv) >= 3: print(he.xxd(sys.argv[2]))
    elif sys.argv[1] == "patch" and len(sys.argv) >= 5: he.patch(sys.argv[2], sys.argv[3], sys.argv[4])

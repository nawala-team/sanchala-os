#!/usr/bin/env python3
"""Sanchala Print Manager"""
import sys, os, subprocess

class PrintManager:
    def list_printers(self):
        result = subprocess.run(['lpstat', '-p'], capture_output=True, text=True)
        return result.stdout
    
    def print_file(self, filepath, printer=None):
        cmd = ['lp', filepath]
        if printer: cmd.extend(['-d', printer])
        subprocess.run(cmd)
    
    def open_settings(self): subprocess.Popen(['system-config-printer'])
    def add_printer(self): subprocess.run(['hp-setup'])

if __name__ == "__main__":
    pm = PrintManager()
    if len(sys.argv) < 2: print(pm.list_printers())
    elif sys.argv[1] == "print" and len(sys.argv) >= 3: pm.print_file(sys.argv[2], sys.argv[3] if len(sys.argv) > 3 else None)
    elif sys.argv[1] == "settings": pm.open_settings()
    elif sys.argv[1] == "add": pm.add_printer()

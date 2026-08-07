#!/usr/bin/env python3
"""Sanchala Smart Card Manager"""
import sys, os, subprocess

class SmartCard:
    def list_readers(self): return subprocess.run(['pcsc_scan', '-r'], capture_output=True, text=True).stdout
    def status(self): return subprocess.run(['pkcs11-tool', '-L'], capture_output=True, text=True).stdout
    def start_daemon(self): subprocess.run(['sudo', 'systemctl', 'start', 'pcscd'])

if __name__ == "__main__":
    sc = SmartCard()
    if len(sys.argv) < 2: print(sc.status())
    elif sys.argv[1] == "readers": print(sc.list_readers())
    elif sys.argv[1] == "start": sc.start_daemon()

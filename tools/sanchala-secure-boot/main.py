#!/usr/bin/env python3
"""Sanchala Secure Boot Manager"""
import sys, os, subprocess

class SecureBoot:
    def status(self):
        r = subprocess.run(['mokutil', '--sb-state'], capture_output=True, text=True)
        return r.stdout.strip()
    def list_keys(self): return subprocess.run(['mokutil', '--list-enrolled'], capture_output=True, text=True).stdout
    def enroll_key(self, key): subprocess.run(['sudo', 'mokutil', '--import', key])

if __name__ == "__main__":
    sb = SecureBoot()
    if len(sys.argv) < 2: print(sb.status())
    elif sys.argv[1] == "keys": print(sb.list_keys())
    elif sys.argv[1] == "enroll" and len(sys.argv) >= 3: sb.enroll_key(sys.argv[2])

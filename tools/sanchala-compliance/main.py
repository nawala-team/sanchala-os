#!/usr/bin/env python3
"""Sanchala Compliance - Security Compliance Checker"""
import subprocess, sys, os, json
from datetime import datetime

class Compliance:
    def check_firewall(self):
        r = subprocess.run(['systemctl', 'is-active', 'ufw'], capture_output=True, text=True)
        return r.stdout.strip() == 'active'
    def check_encryption(self):
        r = subprocess.run(['lsblk', '-o', 'FSTYPE'], capture_output=True, text=True)
        return 'crypto_LUKS' in r.stdout
    def check_updates(self):
        r = subprocess.run(['pacman', '-Qu'], capture_output=True, text=True)
        return len(r.stdout.strip().split('\n')) if r.stdout.strip() else 0
    def audit(self):
        checks = [
            ('Firewall', self.check_firewall()),
            ('Disk Encryption', self.check_encryption()),
            ('Pending Updates', self.check_updates() == 0)
        ]
        for name, passed in checks:
            print(f"{'✅' if passed else '❌'} {name}")
        return checks

if __name__ == "__main__":
    c = Compliance()
    if len(sys.argv) < 2 or sys.argv[1] == "audit":
        c.audit()

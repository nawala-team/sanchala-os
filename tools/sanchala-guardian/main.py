#!/usr/bin/env python3
"""Sanchala Guardian - System Security Monitor"""
import sys, os, subprocess, json

class Guardian:
    def scan_system(self):
        print("Scanning system for security issues...")
        issues = []
        # Check firewall
        result = subprocess.run(['ufw', 'status'], capture_output=True, text=True)
        if 'inactive' in result.stdout: issues.append("Firewall is disabled")
        # Check updates
        result = subprocess.run(['pacman', '-Qu'], capture_output=True, text=True)
        if result.stdout.strip(): issues.append(f"{len(result.stdout.strip().split(chr(10)))} updates available")
        return issues
    
    def enable_protection(self):
        subprocess.run(['sudo', 'ufw', 'enable'])
        subprocess.run(['sudo', 'systemctl', 'enable', 'apparmor'])
        print("Protection enabled")

if __name__ == "__main__":
    g = Guardian()
    if len(sys.argv) < 2:
        issues = g.scan_system()
        if issues:
            print("Security Issues Found:")
            for i in issues: print(f"  - {i}")
        else: print("System is secure")
    elif sys.argv[1] == "protect": g.enable_protection()

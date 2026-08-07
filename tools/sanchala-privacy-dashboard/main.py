#!/usr/bin/env python3
"""Sanchala Privacy Dashboard"""
import sys, os, subprocess

class PrivacyDashboard:
    def show_report(self):
        print("=== Privacy Report ===")
        print(f"Firewall: {self.check_firewall()}")
        print(f"VPN: {self.check_vpn()}")
    def check_firewall(self):
        r = subprocess.run(['ufw', 'status'], capture_output=True, text=True)
        return 'active' if 'active' in r.stdout.lower() else 'inactive'
    def check_vpn(self):
        r = subprocess.run(['nmcli', 'con', 'show', '--active'], capture_output=True, text=True)
        return 'connected' if 'vpn' in r.stdout.lower() else 'disconnected'

if __name__ == "__main__": PrivacyDashboard().show_report()

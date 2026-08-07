#!/usr/bin/env python3
"""Sanchala Remote Management - Remote Admin Tools"""
import subprocess, sys, os

class RemoteManagement:
    def enable_ssh(self):
        subprocess.run(['sudo', 'systemctl', 'enable', '--now', 'sshd'])
    def disable_ssh(self):
        subprocess.run(['sudo', 'systemctl', 'disable', '--now', 'sshd'])
    def enable_vnc(self):
        subprocess.run(['sudo', 'systemctl', 'enable', '--now', 'x11vnc'])
    def status(self):
        for svc in ['sshd', 'x11vnc', 'xrdp']:
            r = subprocess.run(['systemctl', 'is-active', svc], capture_output=True, text=True)
            print(f"{svc}: {r.stdout.strip()}")

if __name__ == "__main__":
    rm = RemoteManagement()
    if len(sys.argv) < 2:
        print("Usage: sanchala-remote-management [status|enable-ssh|disable-ssh|enable-vnc]")
    elif sys.argv[1] == "status": rm.status()
    elif sys.argv[1] == "enable-ssh": rm.enable_ssh()
    elif sys.argv[1] == "disable-ssh": rm.disable_ssh()
    elif sys.argv[1] == "enable-vnc": rm.enable_vnc()

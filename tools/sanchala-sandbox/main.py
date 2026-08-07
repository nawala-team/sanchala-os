#!/usr/bin/env python3
"""Sanchala Sandbox - Run Apps Isolated"""
import sys, os, subprocess

class Sandbox:
    def run(self, cmd):
        subprocess.run(['firejail'] + cmd.split())
    def run_private(self, cmd):
        subprocess.run(['firejail', '--private'] + cmd.split())
    def list_profiles(self):
        return os.listdir('/etc/firejail') if os.path.exists('/etc/firejail') else []

if __name__ == "__main__":
    sb = Sandbox()
    if len(sys.argv) < 2: print(f"Profiles: {len(sb.list_profiles())}")
    elif sys.argv[1] == "run" and len(sys.argv) >= 3: sb.run(' '.join(sys.argv[2:]))
    elif sys.argv[1] == "private" and len(sys.argv) >= 3: sb.run_private(' '.join(sys.argv[2:]))

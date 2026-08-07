#!/usr/bin/env python3
"""Sanchala Sidecar - Use Tablet as Second Display"""
import sys, os, subprocess

class Sidecar:
    def start(self, ip):
        subprocess.Popen(['deskreen'])
        print(f"Connect tablet to: http://{ip}:3131")
    def stop(self): subprocess.run(['pkill', 'deskreen'])
    def get_ip(self):
        r = subprocess.run(['hostname', '-I'], capture_output=True, text=True)
        return r.stdout.strip().split()[0]

if __name__ == "__main__":
    s = Sidecar()
    if len(sys.argv) < 2: print(f"Your IP: {s.get_ip()}")
    elif sys.argv[1] == "start": s.start(s.get_ip())
    elif sys.argv[1] == "stop": s.stop()

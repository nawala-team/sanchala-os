#!/usr/bin/env python3
"""Sanchala Thunderbolt Manager"""
import sys, os, subprocess

class Thunderbolt:
    def list_devices(self): return subprocess.run(['boltctl', 'list'], capture_output=True, text=True).stdout
    def authorize(self, uuid): subprocess.run(['boltctl', 'authorize', uuid])
    def forget(self, uuid): subprocess.run(['boltctl', 'forget', uuid])

if __name__ == "__main__":
    tb = Thunderbolt()
    if len(sys.argv) < 2: print(tb.list_devices())
    elif sys.argv[1] == "auth" and len(sys.argv) >= 3: tb.authorize(sys.argv[2])
    elif sys.argv[1] == "forget" and len(sys.argv) >= 3: tb.forget(sys.argv[2])

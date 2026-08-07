#!/usr/bin/env python3
"""Sanchala Lock Screen"""
import sys, subprocess

class LockScreen:
    def lock(self): subprocess.run(["loginctl", "lock-session"])

if __name__ == "__main__":
    LockScreen().lock()

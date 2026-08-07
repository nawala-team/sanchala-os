#!/usr/bin/env python3
"""Sanchala Login Items"""
import sys, os

class LoginItems:
    def __init__(self): self.dir = os.path.expanduser("~/.config/autostart"); os.makedirs(self.dir, exist_ok=True)
    def list(self): return [f for f in os.listdir(self.dir) if f.endswith(".desktop")]

if __name__ == "__main__":
    li = LoginItems()
    [print(f) for f in li.list()]

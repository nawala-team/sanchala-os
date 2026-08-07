#!/usr/bin/env python3
"""Sanchala Tor Browser"""
import sys, os, subprocess

class TorBrowser:
    def launch(self): subprocess.Popen(['torbrowser-launcher'])
    def update(self): subprocess.run(['torbrowser-launcher', '--update'])

if __name__ == "__main__":
    tb = TorBrowser()
    if len(sys.argv) < 2: tb.launch()
    elif sys.argv[1] == "update": tb.update()

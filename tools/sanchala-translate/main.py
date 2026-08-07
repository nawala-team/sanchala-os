#!/usr/bin/env python3
"""Sanchala Translate"""
import sys, os, subprocess

class Translate:
    def translate(self, text, target='en'):
        r = subprocess.run(['trans', '-b', f':{target}', text], capture_output=True, text=True)
        return r.stdout.strip()
    def open_web(self): subprocess.run(['xdg-open', 'https://translate.google.com'])

if __name__ == "__main__":
    t = Translate()
    if len(sys.argv) < 2: t.open_web()
    elif len(sys.argv) >= 2: print(t.translate(' '.join(sys.argv[1:])))

#!/usr/bin/env python3
"""Sanchala Mail Client"""
import sys, os, subprocess

class Mail:
    def open_client(self):
        for app in ['thunderbird', 'evolution', 'geary', 'kmail']:
            try: subprocess.Popen([app]); return
            except: continue
    
    def compose(self, to=None, subject=None):
        url = f"mailto:{to or ''}?subject={subject or ''}"
        subprocess.run(['xdg-open', url])

if __name__ == "__main__":
    m = Mail()
    if len(sys.argv) < 2: m.open_client()
    elif sys.argv[1] == "compose": m.compose(sys.argv[2] if len(sys.argv) > 2 else None)

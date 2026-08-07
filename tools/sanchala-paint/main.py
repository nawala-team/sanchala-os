#!/usr/bin/env python3
"""Sanchala Paint - Simple Drawing App"""
import sys, os, subprocess

class Paint:
    def open_app(self):
        for app in ['kolourpaint', 'pinta', 'drawing', 'gpaint']:
            try: subprocess.Popen([app]); return
            except: continue

if __name__ == "__main__":
    Paint().open_app()

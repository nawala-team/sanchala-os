#!/usr/bin/env python3
"""Sanchala Whiteboard"""
import sys, os, subprocess

class Whiteboard:
    def open_app(self):
        for app in ['xournalpp', 'openboard', 'lorien']:
            try: subprocess.Popen([app]); return
            except: continue

if __name__ == "__main__": Whiteboard().open_app()

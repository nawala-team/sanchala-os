#!/usr/bin/env python3
"""Sanchala Text Editor"""
import sys, os, subprocess

class TextEditor:
    def open_file(self, f=None):
        for app in ['kate', 'gedit', 'xed', 'pluma', 'mousepad']:
            try:
                cmd = [app] + ([f] if f else [])
                subprocess.Popen(cmd); return
            except: continue

if __name__ == "__main__":
    te = TextEditor()
    te.open_file(sys.argv[1] if len(sys.argv) > 1 else None)

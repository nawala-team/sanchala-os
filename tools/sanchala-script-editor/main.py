#!/usr/bin/env python3
"""Sanchala Script Editor"""
import sys, os, subprocess

class ScriptEditor:
    def open_file(self, filepath=None):
        for app in ['kate', 'gedit', 'code', 'nano']:
            try:
                cmd = [app] + ([filepath] if filepath else [])
                subprocess.Popen(cmd); return
            except: continue
    def run_script(self, filepath): subprocess.run(['bash', filepath])

if __name__ == "__main__":
    se = ScriptEditor()
    if len(sys.argv) < 2: se.open_file()
    elif sys.argv[1] == "open" and len(sys.argv) >= 3: se.open_file(sys.argv[2])
    elif sys.argv[1] == "run" and len(sys.argv) >= 3: se.run_script(sys.argv[2])

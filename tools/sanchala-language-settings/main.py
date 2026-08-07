#!/usr/bin/env python3
"""Sanchala Language Settings"""
import sys, os, subprocess

class LanguageSettings:
    def get_current(self): return os.environ.get("LANG", "en_US.UTF-8")
    def list_locales(self): return subprocess.run(["locale", "-a"], capture_output=True, text=True).stdout

if __name__ == "__main__":
    ls = LanguageSettings()
    if len(sys.argv) < 2: print(f"Current: {ls.get_current()}")
    elif sys.argv[1] == "list": print(ls.list_locales())

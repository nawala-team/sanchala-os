#!/usr/bin/env python3
"""Sanchala Help Center"""
import sys, os, subprocess

class Help:
    def open_docs(self):
        subprocess.run(['xdg-open', 'https://docs.sanchala-os.org'])
    
    def open_wiki(self):
        subprocess.run(['xdg-open', 'https://wiki.sanchala-os.org'])
    
    def search(self, query):
        subprocess.run(['xdg-open', f'https://docs.sanchala-os.org/search?q={query}'])
    
    def man(self, topic):
        subprocess.run(['man', topic])
    
    def tips(self):
        tips = ["Press Super to open app launcher", "Use Ctrl+Alt+T for terminal", "Right-click desktop for options"]
        for t in tips: print(f"  💡 {t}")

if __name__ == "__main__":
    h = Help()
    if len(sys.argv) < 2: h.tips()
    elif sys.argv[1] == "docs": h.open_docs()
    elif sys.argv[1] == "wiki": h.open_wiki()
    elif sys.argv[1] == "search" and len(sys.argv) >= 3: h.search(sys.argv[2])
    elif sys.argv[1] == "man" and len(sys.argv) >= 3: h.man(sys.argv[2])

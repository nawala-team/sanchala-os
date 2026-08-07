#!/usr/bin/env python3
"""Sanchala Welcome App"""
import sys, os, subprocess

class Welcome:
    def show(self):
        print("\n\033[1;36m" + "="*50)
        print("  Welcome to Sanchala OS!")
        print("="*50 + "\033[0m\n")
        print("  Quick Tips:")
        print("  • Press Super to open App Launcher")
        print("  • Super+E opens File Manager")
        print("  • Super+T opens Terminal")
        print("  • Visit docs.sanchala-os.org for help\n")
    def open_tour(self): subprocess.Popen(['gnome-tour'])
    def open_docs(self): subprocess.run(['xdg-open', 'https://docs.sanchala-os.org'])

if __name__ == "__main__":
    w = Welcome()
    if len(sys.argv) < 2: w.show()
    elif sys.argv[1] == "tour": w.open_tour()
    elif sys.argv[1] == "docs": w.open_docs()

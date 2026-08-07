#!/usr/bin/env python3
"""Sanchala Overview - Activities View"""
import sys, os, subprocess

class Overview:
    def show(self):
        subprocess.run(['xdotool', 'key', 'super'])
    
    def show_apps(self):
        subprocess.run(['xdotool', 'key', 'super+a'])
    
    def show_workspaces(self):
        subprocess.run(['xdotool', 'key', 'super+w'])

if __name__ == "__main__":
    o = Overview()
    if len(sys.argv) < 2: o.show()
    elif sys.argv[1] == "apps": o.show_apps()
    elif sys.argv[1] == "workspaces": o.show_workspaces()

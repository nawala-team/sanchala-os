#!/usr/bin/env python3
"""Sanchala QuickLook - File Preview"""
import sys, os, subprocess

class QuickLook:
    def preview(self, filepath):
        ext = filepath.lower().split('.')[-1]
        if ext in ['jpg', 'png', 'gif']: subprocess.Popen(['feh', filepath])
        elif ext in ['mp4', 'mkv', 'avi']: subprocess.Popen(['mpv', '--pause', filepath])
        elif ext in ['pdf']: subprocess.Popen(['zathura', filepath])
        elif ext in ['txt', 'md', 'py']: subprocess.run(['bat', filepath])
        else: subprocess.run(['file', filepath])

if __name__ == "__main__":
    if len(sys.argv) >= 2: QuickLook().preview(sys.argv[1])

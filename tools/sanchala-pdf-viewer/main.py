#!/usr/bin/env python3
"""Sanchala PDF Viewer"""
import sys, os, subprocess

class PDFViewer:
    def open_file(self, filepath=None):
        for app in ['okular', 'evince', 'zathura', 'mupdf']:
            try:
                cmd = [app] + ([filepath] if filepath else [])
                subprocess.Popen(cmd)
                return
            except: continue

if __name__ == "__main__":
    pv = PDFViewer()
    pv.open_file(sys.argv[1] if len(sys.argv) > 1 else None)

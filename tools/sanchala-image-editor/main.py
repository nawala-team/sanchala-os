#!/usr/bin/env python3
"""Sanchala Image Editor - Image Editing"""
import sys, os, subprocess

class ImageEditor:
    def open_gui(self, path=None):
        for app in ['gimp', 'krita', 'pinta']:
            try: subprocess.Popen([app] + ([path] if path else [])); return
            except: continue
    def resize(self, inp, out, size): subprocess.run(['convert', inp, '-resize', size, out])
    def rotate(self, inp, out, deg): subprocess.run(['convert', inp, '-rotate', deg, out])
    def crop(self, inp, out, geom): subprocess.run(['convert', inp, '-crop', geom, out])

if __name__ == "__main__":
    ie = ImageEditor()
    if len(sys.argv) < 2: ie.open_gui()
    elif sys.argv[1] == "open": ie.open_gui(sys.argv[2] if len(sys.argv)>2 else None)
    elif sys.argv[1] == "resize" and len(sys.argv)>=5: ie.resize(sys.argv[2], sys.argv[3], sys.argv[4])
    elif sys.argv[1] == "rotate" and len(sys.argv)>=5: ie.rotate(sys.argv[2], sys.argv[3], sys.argv[4])

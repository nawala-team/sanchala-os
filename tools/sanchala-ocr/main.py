#!/usr/bin/env python3
"""Sanchala OCR - Optical Character Recognition"""
import sys, os, subprocess

class OCR:
    def extract_text(self, image_file, output=None):
        output = output or image_file.rsplit('.', 1)[0]
        subprocess.run(['tesseract', image_file, output])
        return output + '.txt'
    
    def from_clipboard(self):
        subprocess.run(['xclip', '-selection', 'clipboard', '-t', 'image/png', '-o'], stdout=open('/tmp/ocr_temp.png', 'wb'))
        return self.extract_text('/tmp/ocr_temp.png', '/tmp/ocr_result')
    
    def open_gui(self):
        for app in ['gImageReader', 'ocrfeeder']:
            try: subprocess.Popen([app]); return
            except: continue

if __name__ == "__main__":
    ocr = OCR()
    if len(sys.argv) < 2: ocr.open_gui()
    elif sys.argv[1] == "file" and len(sys.argv) >= 3: print(f"Output: {ocr.extract_text(sys.argv[2])}")
    elif sys.argv[1] == "clipboard": print(f"Output: {ocr.from_clipboard()}")

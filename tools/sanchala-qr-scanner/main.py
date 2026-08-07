#!/usr/bin/env python3
"""Sanchala QR Scanner"""
import sys, os, subprocess

class QRScanner:
    def scan_image(self, image):
        r = subprocess.run(['zbarimg', image], capture_output=True, text=True)
        return r.stdout
    def scan_webcam(self): subprocess.run(['zbarcam'])
    def generate(self, text, output):
        subprocess.run(['qrencode', '-o', output, text])

if __name__ == "__main__":
    qr = QRScanner()
    if len(sys.argv) < 2: qr.scan_webcam()
    elif sys.argv[1] == "image" and len(sys.argv) >= 3: print(qr.scan_image(sys.argv[2]))
    elif sys.argv[1] == "generate" and len(sys.argv) >= 4: qr.generate(sys.argv[2], sys.argv[3])

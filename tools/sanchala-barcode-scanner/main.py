#!/usr/bin/env python3
"""Sanchala Barcode Scanner - QR/Barcode Reader"""
import sys, os, subprocess

class BarcodeScanner:
    def __init__(self):
        self.config_dir = os.path.expanduser("~/.config/sanchala/barcode")
        os.makedirs(self.config_dir, exist_ok=True)
    
    def scan_image(self, image_path):
        try:
            result = subprocess.run(['zbarimg', '-q', image_path], capture_output=True, text=True)
            return result.stdout.strip().split(':')[-1] if result.stdout else None
        except FileNotFoundError:
            return None
    
    def scan_camera(self):
        try:
            result = subprocess.run(['zbarcam', '--raw'], capture_output=True, text=True, timeout=30)
            return result.stdout.strip()
        except: return None
    
    def generate_qr(self, data, output):
        subprocess.run(['qrencode', '-o', output, data])
        return os.path.exists(output)

if __name__ == "__main__":
    scanner = BarcodeScanner()
    if len(sys.argv) < 2:
        print("Sanchala Barcode Scanner")
        print("Usage: sanchala-barcode-scanner scan IMAGE")
        print("       sanchala-barcode-scanner camera")
        print("       sanchala-barcode-scanner generate DATA OUTPUT.png")
    elif sys.argv[1] == "scan" and len(sys.argv) >= 3:
        result = scanner.scan_image(sys.argv[2])
        print(result if result else "No barcode found")
    elif sys.argv[1] == "camera":
        print("Scanning... Press Ctrl+C to stop")
        result = scanner.scan_camera()
        print(result if result else "No barcode found")
    elif sys.argv[1] == "generate" and len(sys.argv) >= 4:
        if scanner.generate_qr(sys.argv[2], sys.argv[3]):
            print(f"QR code saved to {sys.argv[3]}")

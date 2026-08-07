#!/usr/bin/env python3
"""Sanchala Captive Portal - WiFi Login Portal Handler"""
import sys, os, subprocess, webbrowser
import urllib.request

class CaptivePortal:
    TEST_URLS = [
        'http://detectportal.firefox.com/success.txt',
        'http://www.gstatic.com/generate_204',
        'http://captive.apple.com/hotspot-detect.html'
    ]
    
    def detect(self):
        for url in self.TEST_URLS:
            try:
                response = urllib.request.urlopen(url, timeout=5)
                if response.status == 200:
                    content = response.read().decode()
                    if 'success' in content.lower() or response.status == 204:
                        return False, "No captive portal detected"
                return True, response.geturl()
            except Exception as e:
                continue
        return True, "Network may be restricted"
    
    def open_portal(self, url=None):
        if not url:
            detected, url = self.detect()
            if not detected:
                print("No captive portal detected")
                return
        webbrowser.open(url)
    
    def auto_login(self):
        # Detect and open portal automatically
        detected, url = self.detect()
        if detected:
            self.open_portal(url)
            return True
        return False

if __name__ == "__main__":
    cp = CaptivePortal()
    if len(sys.argv) < 2:
        print("Sanchala Captive Portal Handler")
        print("Usage: sanchala-captive-portal [detect|open|auto]")
    elif sys.argv[1] == "detect":
        detected, info = cp.detect()
        print(f"Portal detected: {detected}")
        print(f"Info: {info}")
    elif sys.argv[1] == "open":
        url = sys.argv[2] if len(sys.argv) > 2 else None
        cp.open_portal(url)
    elif sys.argv[1] == "auto":
        if cp.auto_login(): print("Opening captive portal...")
        else: print("No portal detected - internet working")

#!/usr/bin/env python3
"""Sanchala Privacy Indicator"""
import sys, os, subprocess

class PrivacyIndicator:
    def check_camera(self):
        r = subprocess.run(['fuser', '/dev/video0'], capture_output=True)
        return r.returncode == 0
    def check_mic(self):
        r = subprocess.run(['pactl', 'list', 'source-outputs'], capture_output=True, text=True)
        return len(r.stdout.strip()) > 0
    def status(self):
        print(f"Camera in use: {self.check_camera()}")
        print(f"Microphone in use: {self.check_mic()}")

if __name__ == "__main__": PrivacyIndicator().status()

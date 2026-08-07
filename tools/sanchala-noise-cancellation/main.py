#!/usr/bin/env python3
"""Sanchala Noise Cancellation"""
import sys, os, subprocess

class NoiseCancellation:
    def enable(self):
        subprocess.run(['pactl', 'load-module', 'module-echo-cancel', 'aec_method=webrtc'])
        print("Noise cancellation enabled")
    
    def disable(self):
        subprocess.run(['pactl', 'unload-module', 'module-echo-cancel'])
        print("Noise cancellation disabled")
    
    def status(self):
        result = subprocess.run(['pactl', 'list', 'modules'], capture_output=True, text=True)
        return "Active" if 'echo-cancel' in result.stdout else "Inactive"

if __name__ == "__main__":
    nc = NoiseCancellation()
    if len(sys.argv) < 2: print(f"Noise Cancellation: {nc.status()}")
    elif sys.argv[1] == "on": nc.enable()
    elif sys.argv[1] == "off": nc.disable()

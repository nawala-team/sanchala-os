#!/usr/bin/env python3
"""Sanchala Universal Control - Share KB/Mouse"""
import sys, os, subprocess

class UniversalControl:
    def start_server(self): subprocess.Popen(['barrier'])
    def start_client(self, server_ip): subprocess.Popen(['barrierc', server_ip])
    def stop(self): subprocess.run(['pkill', 'barrier'])

if __name__ == "__main__":
    uc = UniversalControl()
    if len(sys.argv) < 2: uc.start_server()
    elif sys.argv[1] == "client" and len(sys.argv) >= 3: uc.start_client(sys.argv[2])
    elif sys.argv[1] == "stop": uc.stop()

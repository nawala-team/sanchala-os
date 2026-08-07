#!/usr/bin/env python3
"""Sanchala Remote Desktop"""
import sys, os, subprocess

class RemoteDesktop:
    def connect_rdp(self, host): subprocess.Popen(['xfreerdp', f'/v:{host}'])
    def connect_vnc(self, host): subprocess.Popen(['vncviewer', host])
    def start_server(self): subprocess.Popen(['x11vnc', '-display', ':0'])
    def open_remmina(self): subprocess.Popen(['remmina'])

if __name__ == "__main__":
    rd = RemoteDesktop()
    if len(sys.argv) < 2: rd.open_remmina()
    elif sys.argv[1] == "rdp" and len(sys.argv) >= 3: rd.connect_rdp(sys.argv[2])
    elif sys.argv[1] == "vnc" and len(sys.argv) >= 3: rd.connect_vnc(sys.argv[2])
    elif sys.argv[1] == "server": rd.start_server()

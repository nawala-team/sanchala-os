#!/usr/bin/env python3
"""Sanchala Service Manager - Systemd Services"""
import sys, os, subprocess

class ServiceManager:
    def list_all(self): return subprocess.run(['systemctl', 'list-units', '--type=service'], capture_output=True, text=True).stdout
    def status(self, svc): return subprocess.run(['systemctl', 'status', svc], capture_output=True, text=True).stdout
    def start(self, svc): subprocess.run(['sudo', 'systemctl', 'start', svc])
    def stop(self, svc): subprocess.run(['sudo', 'systemctl', 'stop', svc])
    def enable(self, svc): subprocess.run(['sudo', 'systemctl', 'enable', svc])
    def disable(self, svc): subprocess.run(['sudo', 'systemctl', 'disable', svc])

if __name__ == "__main__":
    sm = ServiceManager()
    if len(sys.argv) < 2: print(sm.list_all())
    elif sys.argv[1] == "status" and len(sys.argv) >= 3: print(sm.status(sys.argv[2]))
    elif sys.argv[1] == "start" and len(sys.argv) >= 3: sm.start(sys.argv[2])
    elif sys.argv[1] == "stop" and len(sys.argv) >= 3: sm.stop(sys.argv[2])
    elif sys.argv[1] == "enable" and len(sys.argv) >= 3: sm.enable(sys.argv[2])
    elif sys.argv[1] == "disable" and len(sys.argv) >= 3: sm.disable(sys.argv[2])

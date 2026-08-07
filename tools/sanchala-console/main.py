#!/usr/bin/env python3
"""Sanchala Console - System Console"""
import sys, os, subprocess

class Console:
    def run_command(self, cmd):
        return subprocess.run(cmd, shell=True, capture_output=True, text=True)
    
    def get_logs(self, service=None, lines=50):
        cmd = ['journalctl', '-n', str(lines), '--no-pager']
        if service: cmd.extend(['-u', service])
        result = subprocess.run(cmd, capture_output=True, text=True)
        return result.stdout
    
    def list_services(self):
        result = subprocess.run(['systemctl', 'list-units', '--type=service', '--no-pager'], capture_output=True, text=True)
        return result.stdout
    
    def service_status(self, service):
        result = subprocess.run(['systemctl', 'status', service, '--no-pager'], capture_output=True, text=True)
        return result.stdout

if __name__ == "__main__":
    c = Console()
    if len(sys.argv) < 2:
        print("Sanchala Console")
        print("Usage: sanchala-console [logs [SERVICE]|services|status SERVICE|run CMD]")
    elif sys.argv[1] == "logs": print(c.get_logs(sys.argv[2] if len(sys.argv) > 2 else None))
    elif sys.argv[1] == "services": print(c.list_services())
    elif sys.argv[1] == "status" and len(sys.argv) >= 3: print(c.service_status(sys.argv[2]))
    elif sys.argv[1] == "run" and len(sys.argv) >= 3:
        r = c.run_command(' '.join(sys.argv[2:]))
        print(r.stdout); print(r.stderr, file=sys.stderr)

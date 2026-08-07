#!/usr/bin/env python3
"""Sanchala Console - System Console"""
import sys, os, subprocess, shlex

class Console:
    def run_command(self, cmd):
        """Run command safely - only allow specific safe commands"""
        allowed_prefixes = ['systemctl', 'journalctl', 'ls', 'cat', 'grep', 'df', 'free', 'ps', 'top', 'htop', 'neofetch', 'fastfetch']
        cmd_parts = shlex.split(cmd)
        if not cmd_parts:
            return subprocess.CompletedProcess(args=cmd, returncode=1, stdout='', stderr='Empty command')
        if cmd_parts[0] not in allowed_prefixes:
            return subprocess.CompletedProcess(args=cmd, returncode=1, stdout='', stderr=f'Command not allowed: {cmd_parts[0]}')
        return subprocess.run(cmd_parts, capture_output=True, text=True)
    
    def get_logs(self, service=None, lines=50):
        cmd = ['journalctl', '-n', str(int(lines)), '--no-pager']
        if service: 
            # Validate service name
            if not service.replace('-', '').replace('_', '').replace('.', '').isalnum():
                return "Invalid service name"
            cmd.extend(['-u', service])
        result = subprocess.run(cmd, capture_output=True, text=True)
        return result.stdout
    
    def list_services(self):
        result = subprocess.run(['systemctl', 'list-units', '--type=service', '--no-pager'], capture_output=True, text=True)
        return result.stdout
    
    def service_status(self, service):
        # Validate service name
        if not service.replace('-', '').replace('_', '').replace('.', '').isalnum():
            return "Invalid service name"
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

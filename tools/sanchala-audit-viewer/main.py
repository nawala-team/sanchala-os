#!/usr/bin/env python3
"""Sanchala Audit Viewer - Security Audit Log Viewer"""
import sys, os, subprocess

class AuditViewer:
    def __init__(self):
        self.log_files = ['/var/log/audit/audit.log', '/var/log/auth.log', '/var/log/secure']
    
    def get_recent(self, lines=50):
        for log in self.log_files:
            if os.path.exists(log):
                result = subprocess.run(['sudo', 'tail', '-n', str(lines), log], capture_output=True, text=True)
                return result.stdout
        return "No audit logs found"
    
    def search(self, pattern):
        for log in self.log_files:
            if os.path.exists(log):
                result = subprocess.run(['sudo', 'grep', '-i', pattern, log], capture_output=True, text=True)
                return result.stdout
        return ""
    
    def get_failed_logins(self):
        return self.search(r"failed|failure|invalid")
    
    def get_sudo_usage(self):
        return self.search(r"failed|failure|invalid")

if __name__ == "__main__":
    av = AuditViewer()
    if len(sys.argv) < 2:
        print("Sanchala Audit Viewer")
        print("Usage: sanchala-audit-viewer [recent|search PATTERN|failed|sudo]")
    elif sys.argv[1] == "recent":
        lines = int(sys.argv[2]) if len(sys.argv) > 2 else 50
        print(av.get_recent(lines))
    elif sys.argv[1] == "search" and len(sys.argv) >= 3:
        print(av.search(sys.argv[2]))
    elif sys.argv[1] == "failed":
        print(av.get_failed_logins())
    elif sys.argv[1] == "sudo":
        print(av.get_sudo_usage())

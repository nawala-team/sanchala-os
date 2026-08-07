#!/usr/bin/env python3
"""Sanchala Diagnostics - System Diagnostics"""
import sys, os, subprocess, platform

class Diagnostics:
    def system_info(self):
        return {"os": "Sanchala OS", "kernel": platform.release(), "arch": platform.machine(), "hostname": platform.node(), "cpu": platform.processor()}
    
    def check_disk(self):
        return subprocess.run(['df', '-h'], capture_output=True, text=True).stdout
    
    def check_memory(self):
        return subprocess.run(['free', '-h'], capture_output=True, text=True).stdout
    
    def check_services(self):
        return subprocess.run(['systemctl', '--failed'], capture_output=True, text=True).stdout
    
    def check_network(self):
        return subprocess.run(['ip', 'addr'], capture_output=True, text=True).stdout
    
    def full_report(self):
        report = ["=== SANCHALA DIAGNOSTICS ==="]
        report.append("\n--- System Info ---")
        for k, v in self.system_info().items(): report.append(f"{k}: {v}")
        report.append("\n--- Disk Usage ---")
        report.append(self.check_disk())
        report.append("--- Memory ---")
        report.append(self.check_memory())
        report.append("--- Failed Services ---")
        report.append(self.check_services())
        return '\n'.join(report)

if __name__ == "__main__":
    d = Diagnostics()
    if len(sys.argv) < 2 or sys.argv[1] == "full": print(d.full_report())
    elif sys.argv[1] == "disk": print(d.check_disk())
    elif sys.argv[1] == "memory": print(d.check_memory())
    elif sys.argv[1] == "services": print(d.check_services())
    elif sys.argv[1] == "network": print(d.check_network())

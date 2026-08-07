#!/usr/bin/env python3
"""Sanchala DNS Settings - DNS Configuration"""
import sys, os, subprocess

class DNSSettings:
    PRESETS = {'cloudflare': ['1.1.1.1', '1.0.0.1'], 'google': ['8.8.8.8', '8.8.4.4'], 'quad9': ['9.9.9.9', '149.112.112.112'], 'opendns': ['208.67.222.222', '208.67.220.220']}
    
    def get_current(self):
        return subprocess.run(['resolvectl', 'status'], capture_output=True, text=True).stdout
    
    def set_dns(self, servers, interface='*'):
        subprocess.run(['sudo', 'resolvectl', 'dns', interface] + servers)
    
    def set_preset(self, name):
        if name in self.PRESETS: self.set_dns(self.PRESETS[name])
    
    def flush_cache(self):
        subprocess.run(['sudo', 'resolvectl', 'flush-caches'])
    
    def test_dns(self, domain='google.com'):
        return subprocess.run(['dig', '+short', domain], capture_output=True, text=True).stdout

if __name__ == "__main__":
    dns = DNSSettings()
    if len(sys.argv) < 2:
        print(dns.get_current())
        print(f"Presets: {', '.join(DNSSettings.PRESETS.keys())}")
    elif sys.argv[1] == "set" and len(sys.argv) >= 3:
        if sys.argv[2] in DNSSettings.PRESETS: dns.set_preset(sys.argv[2])
        else: dns.set_dns(sys.argv[2:])
        print("DNS updated")
    elif sys.argv[1] == "flush": dns.flush_cache(); print("Cache flushed")
    elif sys.argv[1] == "test": print(dns.test_dns(sys.argv[2] if len(sys.argv) > 2 else 'google.com'))

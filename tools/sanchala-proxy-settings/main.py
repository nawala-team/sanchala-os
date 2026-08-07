#!/usr/bin/env python3
"""Sanchala Proxy Settings"""
import sys, os

class ProxySettings:
    def set_proxy(self, http, https=None):
        os.environ['http_proxy'] = http
        os.environ['https_proxy'] = https or http
        print(f"Proxy set: {http}")
    def clear_proxy(self):
        for k in ['http_proxy', 'https_proxy', 'HTTP_PROXY', 'HTTPS_PROXY']:
            os.environ.pop(k, None)
    def get_proxy(self): return os.environ.get('http_proxy', 'Not set')

if __name__ == "__main__":
    ps = ProxySettings()
    if len(sys.argv) < 2: print(f"Proxy: {ps.get_proxy()}")
    elif sys.argv[1] == "set" and len(sys.argv) >= 3: ps.set_proxy(sys.argv[2])
    elif sys.argv[1] == "clear": ps.clear_proxy()

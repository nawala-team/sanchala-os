#!/usr/bin/env python3
"""Sanchala Certificate Manager - SSL/TLS Certificate Management"""
import sys, os, subprocess

class CertificateManager:
    def __init__(self):
        self.cert_dir = os.path.expanduser("~/.config/sanchala/certs")
        os.makedirs(self.cert_dir, exist_ok=True)
    
    def generate_self_signed(self, name, days=365):
        key = os.path.join(self.cert_dir, f"{name}.key")
        cert = os.path.join(self.cert_dir, f"{name}.crt")
        subprocess.run(['openssl', 'req', '-x509', '-newkey', 'rsa:4096', '-keyout', key, '-out', cert, '-days', str(days), '-nodes', '-subj', f'/CN={name}'])
        return key, cert
    
    def view_cert(self, cert_path):
        result = subprocess.run(['openssl', 'x509', '-in', cert_path, '-text', '-noout'], capture_output=True, text=True)
        return result.stdout
    
    def verify_cert(self, cert_path):
        result = subprocess.run(['openssl', 'verify', cert_path], capture_output=True, text=True)
        return 'OK' in result.stdout
    
    def list_certs(self):
        return [f for f in os.listdir(self.cert_dir) if f.endswith('.crt')]
    
    def install_ca(self, cert_path):
        subprocess.run(['sudo', 'cp', cert_path, '/etc/ca-certificates/trust-source/anchors/'])
        subprocess.run(['sudo', 'update-ca-trust'])

if __name__ == "__main__":
    cm = CertificateManager()
    if len(sys.argv) < 2:
        print("Sanchala Certificate Manager")
        print("Usage: sanchala-certificate-manager [generate NAME|view CERT|verify CERT|list|install CERT]")
    elif sys.argv[1] == "generate" and len(sys.argv) >= 3:
        k, c = cm.generate_self_signed(sys.argv[2]); print(f"Generated: {c}")
    elif sys.argv[1] == "view" and len(sys.argv) >= 3: print(cm.view_cert(sys.argv[2]))
    elif sys.argv[1] == "verify" and len(sys.argv) >= 3: print("Valid" if cm.verify_cert(sys.argv[2]) else "Invalid")
    elif sys.argv[1] == "list": [print(f"  {c}") for c in cm.list_certs()]
    elif sys.argv[1] == "install" and len(sys.argv) >= 3: cm.install_ca(sys.argv[2])

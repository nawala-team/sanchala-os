#!/usr/bin/env python3
"""Sanchala LDAP Config - LDAP Authentication Setup"""
import subprocess, sys, os, json

class LDAPConfig:
    def __init__(self):
        self.config_dir = os.path.expanduser("~/.config/sanchala/ldap")
        os.makedirs(self.config_dir, exist_ok=True)
    
    def test(self, uri, base_dn):
        return subprocess.run(['ldapsearch', '-x', '-H', uri, '-b', base_dn, '-s', 'base'], capture_output=True, text=True)
    
    def configure(self, uri, base_dn):
        conf = f"[sssd]\ndomains = LDAP\nservices = nss, pam\n\n[domain/LDAP]\nid_provider = ldap\nldap_uri = {uri}\nldap_search_base = {base_dn}\n"
        return conf

if __name__ == "__main__":
    ldap = LDAPConfig()
    if len(sys.argv) < 2:
        print("Usage: sanchala-ldap-config [test|configure|status] [args]")
    elif sys.argv[1] == "test" and len(sys.argv) > 3:
        r = ldap.test(sys.argv[2], sys.argv[3])
        print("Success" if r.returncode == 0 else "Failed")
    elif sys.argv[1] == "configure" and len(sys.argv) > 3:
        print(ldap.configure(sys.argv[2], sys.argv[3]))

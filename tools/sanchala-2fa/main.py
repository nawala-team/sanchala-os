#!/usr/bin/env python3
"""Sanchala 2FA - Two-Factor Authentication Manager"""
import sys, os, json, time, hmac, hashlib, base64, struct

class TwoFactorAuth:
    def __init__(self):
        self.config_dir = os.path.expanduser("~/.config/sanchala/2fa")
        self.secrets_file = os.path.join(self.config_dir, "secrets.json")
        os.makedirs(self.config_dir, exist_ok=True)
    
    def generate_totp(self, secret, interval=30):
        key = base64.b32decode(secret.upper() + '=' * (-len(secret) % 8))
        counter = int(time.time() // interval)
        msg = struct.pack('>Q', counter)
        h = hmac.new(key, msg, hashlib.sha1).digest()
        offset = h[-1] & 0x0F
        code = struct.unpack('>I', h[offset:offset+4])[0] & 0x7FFFFFFF
        return str(code % 1000000).zfill(6)
    
    def add_account(self, name, secret):
        secrets = self.load_secrets()
        secrets[name] = secret
        self.save_secrets(secrets)
        return True
    
    def load_secrets(self):
        if os.path.exists(self.secrets_file):
            with open(self.secrets_file) as f: return json.load(f)
        return {}
    
    def save_secrets(self, secrets):
        with open(self.secrets_file, 'w') as f: json.dump(secrets, f)
    
    def list_accounts(self):
        return list(self.load_secrets().keys())
    
    def get_code(self, name):
        secrets = self.load_secrets()
        if name in secrets:
            return self.generate_totp(secrets[name])
        return None

if __name__ == "__main__":
    tfa = TwoFactorAuth()
    if len(sys.argv) < 2:
        print("Sanchala 2FA Manager")
        print("Usage: sanchala-2fa [list|add NAME SECRET|code NAME]")
    elif sys.argv[1] == "list":
        for acc in tfa.list_accounts(): print(f"  {acc}")
    elif sys.argv[1] == "add" and len(sys.argv) >= 4:
        tfa.add_account(sys.argv[2], sys.argv[3])
        print(f"Added: {sys.argv[2]}")
    elif sys.argv[1] == "code" and len(sys.argv) >= 3:
        code = tfa.get_code(sys.argv[2])
        print(code if code else "Account not found")

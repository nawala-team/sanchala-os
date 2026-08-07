#!/usr/bin/env python3
"""Client-side encryption wrapper for Sanchala Cloud using rclone crypt"""

import os
import subprocess
import secrets
from pathlib import Path
from typing import Optional

CONFIG_DIR = Path(os.environ.get("XDG_CONFIG_HOME", Path.home() / ".config")) / "sanchala-cloud"
RCLONE_CONFIG = CONFIG_DIR / "rclone.conf"


class CloudEncryption:
    """Manages client-side encryption for cloud storage using rclone crypt backend"""
    
    def __init__(self):
        self.config_path = RCLONE_CONFIG
    
    def enable_encryption(self, account: str, password: Optional[str] = None) -> bool:
        """Enable client-side encryption for an account"""
        if not password:
            password = secrets.token_urlsafe(32)
        
        salt = secrets.token_urlsafe(16)
        encrypted_name = f"{account}_encrypted"
        
        # Create encrypted remote wrapping the original
        result = subprocess.run([
            "rclone", "config", "create", encrypted_name, "crypt",
            f"remote={account}:encrypted",
            "filename_encryption=standard",
            "directory_name_encryption=true",
            f"password={password}",
            f"password2={salt}",
            "--config", str(self.config_path)
        ], capture_output=True, text=True)
        
        if result.returncode == 0:
            self._store_key(account, password, salt)
            return True
        return False
    
    def disable_encryption(self, account: str) -> bool:
        """Remove encryption wrapper"""
        encrypted_name = f"{account}_encrypted"
        result = subprocess.run([
            "rclone", "config", "delete", encrypted_name,
            "--config", str(self.config_path)
        ], capture_output=True, text=True)
        return result.returncode == 0
    
    def is_encrypted(self, account: str) -> bool:
        """Check if account has encryption enabled"""
        result = subprocess.run([
            "rclone", "listremotes", "--config", str(self.config_path)
        ], capture_output=True, text=True)
        return f"{account}_encrypted:" in result.stdout
    
    def _store_key(self, account: str, password: str, salt: str):
        """Store encryption key in KWallet"""
        try:
            subprocess.run([
                "kwallet-query", "-w", f"sanchala-cloud-{account}",
                "-f", "sanchala-cloud", "kdewallet"
            ], input=password.encode(), check=True)
        except subprocess.CalledProcessError:
            # Fallback: store in secure file
            key_file = CONFIG_DIR / "keys" / f"{account}.key"
            key_file.parent.mkdir(parents=True, exist_ok=True)
            key_file.write_text(f"{password}\n{salt}")
            key_file.chmod(0o600)
    
    def get_encrypted_remote(self, account: str) -> str:
        """Get the encrypted remote name if encryption is enabled"""
        if self.is_encrypted(account):
            return f"{account}_encrypted"
        return account

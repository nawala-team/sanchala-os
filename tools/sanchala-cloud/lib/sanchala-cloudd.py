#!/usr/bin/env python3
"""Sanchala Cloud Daemon - Background sync service"""

import os
import sys
import time
import signal
import logging
import sqlite3
import threading
import subprocess
from pathlib import Path
from datetime import datetime
from typing import Dict, Optional

import gi
gi.require_version('GLib', '2.0')
from gi.repository import GLib

CONFIG_DIR = Path(os.environ.get("XDG_CONFIG_HOME", Path.home() / ".config")) / "sanchala-cloud"
DATA_DIR = Path(os.environ.get("XDG_DATA_HOME", Path.home() / ".local/share")) / "sanchala-cloud"
CLOUD_ROOT = Path.home() / "Cloud"
RCLONE_CONFIG = CONFIG_DIR / "rclone.conf"

logging.basicConfig(level=logging.INFO, format='%(asctime)s [%(levelname)s] %(message)s')
logger = logging.getLogger("sanchala-cloudd")


class CloudAccount:
    def __init__(self, name: str, rtype: str, mount: Path):
        self.name = name
        self.rtype = rtype
        self.mount = mount
        self.status = "idle"
        self.last_sync: Optional[datetime] = None
        self.error: Optional[str] = None


class SanchalaCloudDaemon:
    def __init__(self):
        self.accounts: Dict[str, CloudAccount] = {}
        self.running = False
        self.sync_interval = 300
        self._init()

    def _init(self):
        for d in [CONFIG_DIR, DATA_DIR, CLOUD_ROOT]:
            d.mkdir(parents=True, exist_ok=True)
        CONFIG_DIR.chmod(0o700)
        self._init_db()
        self._load_accounts()

    def _init_db(self):
        conn = sqlite3.connect(DATA_DIR / "cloud.db")
        conn.execute("""CREATE TABLE IF NOT EXISTS sync_history (
            id INTEGER PRIMARY KEY, account TEXT, timestamp TEXT, status TEXT, error TEXT)""")
        conn.execute("""CREATE TABLE IF NOT EXISTS file_status (
            path TEXT PRIMARY KEY, account TEXT, status TEXT, pinned INTEGER DEFAULT 0)""")
        conn.commit()
        conn.close()

    def _load_accounts(self):
        if not RCLONE_CONFIG.exists():
            return
        result = subprocess.run(["rclone", "listremotes", "--config", str(RCLONE_CONFIG)],
                                capture_output=True, text=True)
        for line in result.stdout.strip().split('\n'):
            if line:
                name = line.rstrip(':')
                self.accounts[name] = CloudAccount(name, "cloud", CLOUD_ROOT / name)
                logger.info(f"Loaded: {name}")

    def sync_account(self, name: str) -> bool:
        if name not in self.accounts:
            return False
        acc = self.accounts[name]
        acc.status = "syncing"
        acc.mount.mkdir(parents=True, exist_ok=True)
        logger.info(f"Syncing {name}...")
        try:
            result = subprocess.run([
                "rclone", "bisync", f"{name}:", str(acc.mount),
                "--config", str(RCLONE_CONFIG), "--resilient"
            ], capture_output=True, text=True, timeout=3600)
            acc.status = "idle" if result.returncode == 0 else "error"
            acc.last_sync = datetime.now()
            acc.error = result.stderr[:300] if result.returncode != 0 else None
            return result.returncode == 0
        except Exception as e:
            acc.status = "error"
            acc.error = str(e)
            return False

    def sync_all(self):
        for name in self.accounts:
            self.sync_account(name)

    def run(self):
        self.running = True
        logger.info("Sanchala Cloud Daemon started")
        
        def loop():
            while self.running:
                self.sync_all()
                time.sleep(self.sync_interval)
        
        threading.Thread(target=loop, daemon=True).start()
        main = GLib.MainLoop()
        GLib.unix_signal_add(GLib.PRIORITY_DEFAULT, signal.SIGTERM, main.quit)
        GLib.unix_signal_add(GLib.PRIORITY_DEFAULT, signal.SIGINT, main.quit)
        try:
            main.run()
        finally:
            self.running = False


if __name__ == "__main__":
    SanchalaCloudDaemon().run()

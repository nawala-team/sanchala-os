#!/usr/bin/env python3
"""Sync Status Monitor - Track file sync states with Dolphin overlay support"""

import os
import sqlite3
from pathlib import Path
from enum import Enum
from typing import Optional, Dict, List
from dataclasses import dataclass

DATA_DIR = Path(os.environ.get("XDG_DATA_HOME", Path.home() / ".local/share")) / "sanchala-cloud"


class FileStatus(Enum):
    SYNCED = "synced"        # Green checkmark
    SYNCING = "syncing"      # Blue arrows
    PENDING = "pending"      # Gray clock
    OFFLINE = "offline"      # Pin icon
    ERROR = "error"          # Red warning
    IGNORED = "ignored"      # No overlay


@dataclass
class FileInfo:
    path: str
    status: FileStatus
    account: str
    pinned: bool = False
    local_mtime: Optional[float] = None
    remote_mtime: Optional[float] = None
    error: Optional[str] = None


class StatusMonitor:
    def __init__(self):
        self.db_path = DATA_DIR / "cloud.db"
        DATA_DIR.mkdir(parents=True, exist_ok=True)
        self._init_db()

    def _init_db(self):
        conn = sqlite3.connect(self.db_path)
        conn.execute("""
            CREATE TABLE IF NOT EXISTS file_status (
                path TEXT PRIMARY KEY,
                account TEXT NOT NULL,
                status TEXT DEFAULT 'synced',
                pinned INTEGER DEFAULT 0,
                local_mtime REAL,
                remote_mtime REAL,
                error TEXT
            )
        """)
        conn.commit()
        conn.close()

    def get_status(self, path: str) -> Optional[FileInfo]:
        conn = sqlite3.connect(self.db_path)
        cur = conn.execute("SELECT * FROM file_status WHERE path = ?", (path,))
        row = cur.fetchone()
        conn.close()
        if row:
            return FileInfo(row[0], FileStatus(row[2]), row[1], bool(row[3]), row[4], row[5], row[6])
        return None

    def set_status(self, path: str, account: str, status: FileStatus, pinned: bool = False):
        conn = sqlite3.connect(self.db_path)
        conn.execute("""
            INSERT OR REPLACE INTO file_status (path, account, status, pinned)
            VALUES (?, ?, ?, ?)
        """, (path, account, status.value, int(pinned)))
        conn.commit()
        conn.close()

    def get_account_files(self, account: str) -> List[FileInfo]:
        conn = sqlite3.connect(self.db_path)
        cur = conn.execute("SELECT * FROM file_status WHERE account = ?", (account,))
        files = [FileInfo(r[0], FileStatus(r[2]), r[1], bool(r[3])) for r in cur.fetchall()]
        conn.close()
        return files

    def get_pending_files(self) -> List[FileInfo]:
        conn = sqlite3.connect(self.db_path)
        cur = conn.execute("SELECT * FROM file_status WHERE status IN ('pending', 'syncing')")
        files = [FileInfo(r[0], FileStatus(r[2]), r[1], bool(r[3])) for r in cur.fetchall()]
        conn.close()
        return files

    def mark_synced(self, path: str):
        conn = sqlite3.connect(self.db_path)
        conn.execute("UPDATE file_status SET status = 'synced' WHERE path = ?", (path,))
        conn.commit()
        conn.close()

    def mark_error(self, path: str, error: str):
        conn = sqlite3.connect(self.db_path)
        conn.execute("UPDATE file_status SET status = 'error', error = ? WHERE path = ?", (error, path))
        conn.commit()
        conn.close()


# Dolphin overlay icon mapping
OVERLAY_ICONS = {
    FileStatus.SYNCED: "cloud-synced",
    FileStatus.SYNCING: "cloud-syncing",
    FileStatus.PENDING: "cloud-pending",
    FileStatus.OFFLINE: "cloud-offline",
    FileStatus.ERROR: "cloud-error",
    FileStatus.IGNORED: None
}

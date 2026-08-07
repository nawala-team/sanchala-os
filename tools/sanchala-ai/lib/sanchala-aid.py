#!/usr/bin/env python3
"""Sanchala AI Daemon - Local AI Services for Sanchala OS"""

import os
import sys
import json
import signal
import logging
import sqlite3
import subprocess
import threading
from pathlib import Path
from datetime import datetime
from typing import Optional, List, Dict, Any

# XDG directories
CONFIG_DIR = Path(os.environ.get("XDG_CONFIG_HOME", Path.home() / ".config")) / "sanchala-ai"
DATA_DIR = Path(os.environ.get("XDG_DATA_HOME", Path.home() / ".local/share")) / "sanchala-ai"
CACHE_DIR = Path(os.environ.get("XDG_CACHE_HOME", Path.home() / ".cache")) / "sanchala-ai"

logging.basicConfig(level=logging.INFO, format='%(asctime)s [%(levelname)s] %(name)s: %(message)s')
logger = logging.getLogger("sanchala-aid")


class Config:
    DEFAULT = {
        "assistant": {"model": "llama3.2:3b", "context_length": 4096, "temperature": 0.7},
        "ocr": {"default_language": "eng", "dpi": 300},
        "privacy": {"telemetry": False, "store_history": True}
    }
    
    def __init__(self):
        self.path = CONFIG_DIR / "config.json"
        self.data = self._load()
    
    def _load(self) -> dict:
        if self.path.exists():
            try:
                with open(self.path) as f:
                    return json.load(f)
            except Exception:
                pass
        return self.DEFAULT.copy()
    
    def get(self, section: str, key: str, default=None):
        return self.data.get(section, {}).get(key, default)
    
    def save(self):
        self.path.parent.mkdir(parents=True, exist_ok=True)
        with open(self.path, 'w') as f:
            json.dump(self.data, f, indent=2)


class OllamaClient:
    def __init__(self, config: Config):
        self.config = config
        self.model = config.get("assistant", "model", "llama3.2:3b")
    
    def is_available(self) -> bool:
        try:
            result = subprocess.run(["ollama", "list"], capture_output=True, timeout=5)
            return result.returncode == 0
        except Exception:
            return False
    
    def list_models(self) -> List[str]:
        try:
            result = subprocess.run(["ollama", "list"], capture_output=True, text=True, timeout=10)
            return [line.split()[0] for line in result.stdout.strip().split('\n')[1:] if line]
        except Exception:
            return []
    
    def chat(self, prompt: str) -> dict:
        try:
            result = subprocess.run(
                ["ollama", "run", self.model, prompt],
                capture_output=True, text=True, timeout=120
            )
            return {"response": result.stdout.strip(), "model": self.model}
        except subprocess.TimeoutExpired:
            return {"error": "Request timeout", "response": ""}
        except Exception as e:
            return {"error": str(e), "response": ""}


class TesseractOCR:
    def __init__(self, config: Config):
        self.config = config
        self.default_lang = config.get("ocr", "default_language", "eng")
    
    def is_available(self) -> bool:
        try:
            result = subprocess.run(["tesseract", "--version"], capture_output=True, timeout=5)
            return result.returncode == 0
        except Exception:
            return False
    
    def list_languages(self) -> List[str]:
        try:
            result = subprocess.run(["tesseract", "--list-langs"], capture_output=True, text=True)
            return result.stdout.strip().split('\n')[1:]
        except Exception:
            return []
    
    def extract_text(self, image_path: str, lang: str = None) -> dict:
        try:
            lang = lang or self.default_lang
            result = subprocess.run(
                ["tesseract", image_path, "stdout", "-l", lang],
                capture_output=True, text=True, timeout=30
            )
            return {"text": result.stdout.strip(), "success": True}
        except Exception as e:
            return {"error": str(e), "success": False}


class ChatHistory:
    def __init__(self, config: Config):
        self.db_path = DATA_DIR / "history.db"
        self._init_db()
    
    def _init_db(self):
        DATA_DIR.mkdir(parents=True, exist_ok=True)
        conn = sqlite3.connect(self.db_path)
        conn.execute('''CREATE TABLE IF NOT EXISTS conversations
            (id INTEGER PRIMARY KEY, session_id TEXT, role TEXT, content TEXT, 
             model TEXT, timestamp DATETIME DEFAULT CURRENT_TIMESTAMP)''')
        conn.commit()
        conn.close()
    
    def add_message(self, session_id: str, role: str, content: str, model: str = None):
        conn = sqlite3.connect(self.db_path)
        conn.execute("INSERT INTO conversations (session_id, role, content, model) VALUES (?, ?, ?, ?)",
                    (session_id, role, content, model))
        conn.commit()
        conn.close()
    
    def get_history(self, session_id: str) -> List[dict]:
        conn = sqlite3.connect(self.db_path)
        cursor = conn.execute("SELECT role, content FROM conversations WHERE session_id = ? ORDER BY timestamp", (session_id,))
        messages = [{"role": row[0], "content": row[1]} for row in cursor]
        conn.close()
        return messages


class SanchalaAIDaemon:
    def __init__(self):
        self.config = Config()
        self.ollama = OllamaClient(self.config)
        self.ocr = TesseractOCR(self.config)
        self.history = ChatHistory(self.config)
        self.session_id = datetime.now().strftime("%Y%m%d_%H%M%S")
        self._init_dirs()
    
    def _init_dirs(self):
        for d in [CONFIG_DIR, DATA_DIR, CACHE_DIR]:
            d.mkdir(parents=True, exist_ok=True)
    
    def chat(self, prompt: str) -> str:
        self.history.add_message(self.session_id, "user", prompt)
        result = self.ollama.chat(prompt)
        if result.get("response"):
            self.history.add_message(self.session_id, "assistant", result["response"], self.ollama.model)
        return json.dumps(result)
    
    def ocr_scan(self, image_path: str, lang: str = "") -> str:
        return json.dumps(self.ocr.extract_text(image_path, lang or None))
    
    def get_status(self) -> str:
        return json.dumps({
            "ollama_available": self.ollama.is_available(),
            "ollama_model": self.ollama.model,
            "tesseract_available": self.ocr.is_available(),
            "session_id": self.session_id
        })


def main():
    import argparse
    parser = argparse.ArgumentParser(description="Sanchala AI Daemon")
    parser.add_argument("--status", action="store_true", help="Show status")
    parser.add_argument("--chat", type=str, help="Chat prompt")
    parser.add_argument("--ocr", type=str, help="OCR image path")
    args = parser.parse_args()
    
    daemon = SanchalaAIDaemon()
    
    if args.status:
        print(daemon.get_status())
    elif args.chat:
        print(daemon.chat(args.chat))
    elif args.ocr:
        print(daemon.ocr_scan(args.ocr))
    else:
        parser.print_help()


if __name__ == "__main__":
    main()

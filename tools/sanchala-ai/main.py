#!/usr/bin/env python3
"""Sanchala AI - AI Assistant Integration"""
import sys, os, json, subprocess

class SanchalaAI:
    def __init__(self):
        self.config_dir = os.path.expanduser("~/.config/sanchala/ai")
        self.history_file = os.path.join(self.config_dir, "history.json")
        os.makedirs(self.config_dir, exist_ok=True)
    
    def query(self, prompt):
        # Try local ollama first
        try:
            result = subprocess.run(['ollama', 'run', 'llama2', prompt], capture_output=True, text=True, timeout=60)
            return result.stdout.strip()
        except:
            return "AI service not available. Install ollama: curl -fsSL https://ollama.ai/install.sh | sh"
    
    def save_history(self, prompt, response):
        history = self.load_history()
        history.append({"prompt": prompt, "response": response})
        with open(self.history_file, 'w') as f: json.dump(history[-100:], f)
    
    def load_history(self):
        if os.path.exists(self.history_file):
            with open(self.history_file) as f: return json.load(f)
        return []

if __name__ == "__main__":
    ai = SanchalaAI()
    if len(sys.argv) < 2:
        print("Sanchala AI Assistant")
        print("Usage: sanchala-ai 'your question here'")
        print("       sanchala-ai --history")
    elif sys.argv[1] == "--history":
        for h in ai.load_history()[-10:]:
            print(f"Q: {h['prompt'][:50]}...")
    else:
        prompt = ' '.join(sys.argv[1:])
        response = ai.query(prompt)
        print(response)
        ai.save_history(prompt, response)

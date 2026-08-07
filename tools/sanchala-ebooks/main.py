#!/usr/bin/env python3
"""Sanchala Ebooks - Ebook Reader & Library"""
import sys, os, subprocess, json

class Ebooks:
    FORMATS = ['.epub', '.pdf', '.mobi', '.azw3', '.fb2']
    
    def __init__(self):
        self.library_dir = os.path.expanduser("~/Books")
        self.config_dir = os.path.expanduser("~/.config/sanchala/ebooks")
        os.makedirs(self.library_dir, exist_ok=True)
        os.makedirs(self.config_dir, exist_ok=True)
    
    def scan_library(self):
        books = []
        for root, dirs, files in os.walk(self.library_dir):
            for f in files:
                if any(f.lower().endswith(fmt) for fmt in self.FORMATS):
                    books.append(os.path.join(root, f))
        return books
    
    def open_book(self, path):
        for app in ['foliate', 'calibre', 'okular', 'evince']:
            try: subprocess.Popen([app, path]); return True
            except: continue
        return False
    
    def convert(self, input_file, output_format):
        output = input_file.rsplit('.', 1)[0] + '.' + output_format
        subprocess.run(['ebook-convert', input_file, output])
        return output

if __name__ == "__main__":
    eb = Ebooks()
    if len(sys.argv) < 2:
        print("Sanchala Ebooks")
        print(f"Library: {eb.library_dir}")
        books = eb.scan_library()
        print(f"Books: {len(books)}")
    elif sys.argv[1] == "list": [print(f"  {os.path.basename(b)}") for b in eb.scan_library()[:20]]
    elif sys.argv[1] == "open" and len(sys.argv) >= 3: eb.open_book(sys.argv[2])
    elif sys.argv[1] == "convert" and len(sys.argv) >= 4: print(f"Converted: {eb.convert(sys.argv[2], sys.argv[3])}")

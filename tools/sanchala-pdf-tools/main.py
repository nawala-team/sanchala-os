#!/usr/bin/env python3
"""Sanchala PDF Tools"""
import sys, os, subprocess

class PDFTools:
    def merge(self, output, *inputs):
        subprocess.run(['pdfunite'] + list(inputs) + [output])
    
    def split(self, input_file, output_dir):
        os.makedirs(output_dir, exist_ok=True)
        subprocess.run(['pdfseparate', input_file, os.path.join(output_dir, 'page-%d.pdf')])
    
    def compress(self, input_file, output_file):
        subprocess.run(['gs', '-sDEVICE=pdfwrite', '-dCompatibilityLevel=1.4', '-dPDFSETTINGS=/ebook', '-dNOPAUSE', '-dQUIET', '-dBATCH', f'-sOutputFile={output_file}', input_file])
    
    def to_images(self, input_file, output_dir):
        os.makedirs(output_dir, exist_ok=True)
        subprocess.run(['pdftoppm', '-png', input_file, os.path.join(output_dir, 'page')])

if __name__ == "__main__":
    pt = PDFTools()
    if len(sys.argv) < 2:
        print("Usage: sanchala-pdf-tools [merge OUT IN1 IN2...|split IN DIR|compress IN OUT|images IN DIR]")
    elif sys.argv[1] == "merge" and len(sys.argv) >= 4: pt.merge(sys.argv[2], *sys.argv[3:])
    elif sys.argv[1] == "split" and len(sys.argv) >= 4: pt.split(sys.argv[2], sys.argv[3])
    elif sys.argv[1] == "compress" and len(sys.argv) >= 4: pt.compress(sys.argv[2], sys.argv[3])
    elif sys.argv[1] == "images" and len(sys.argv) >= 4: pt.to_images(sys.argv[2], sys.argv[3])

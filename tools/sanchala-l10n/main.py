#!/usr/bin/env python3
"""Sanchala Localization"""
import sys, os, subprocess

class Localization:
    def get_locale(self):
        return os.environ.get('LANG', 'en_US.UTF-8')
    
    def set_locale(self, locale):
        with open(os.path.expanduser('~/.config/locale.conf'), 'w') as f:
            f.write(f'LANG={locale}\n')
        print(f"Locale set to {locale}. Relogin to apply.")
    
    def list_locales(self):
        result = subprocess.run(['locale', '-a'], capture_output=True, text=True)
        return result.stdout
    
    def generate_locale(self, locale):
        subprocess.run(['sudo', 'locale-gen', locale])

if __name__ == "__main__":
    l10n = Localization()
    if len(sys.argv) < 2: print(f"Current: {l10n.get_locale()}")
    elif sys.argv[1] == "set" and len(sys.argv) >= 3: l10n.set_locale(sys.argv[2])
    elif sys.argv[1] == "list": print(l10n.list_locales())
    elif sys.argv[1] == "generate" and len(sys.argv) >= 3: l10n.generate_locale(sys.argv[2])

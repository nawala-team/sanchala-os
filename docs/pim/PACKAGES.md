# ============================================================================
# SANCHALA OS - PIM Package Requirements
# ============================================================================
# Required packages for full PIM functionality
# ============================================================================

# Core PIM Suite (KDE PIM)
kdepim-meta                    # Meta package for all KDE PIM
kontact                        # Unified PIM interface
korganizer                     # Calendar and scheduling
kaddressbook                   # Contact management
kmail                          # Email client
akonadi                        # PIM data server
akonadi-calendar-tools         # Calendar CLI tools
akonadi-contacts               # Contact resources
akonadi-mime                   # MIME handling
akonadi-search                 # Full-text search

# Sync Resources
kdepim-addons                  # Additional resources
akonadi-calendar               # Calendar backend
kaccounts-providers            # Online account providers
kio-gdrive                     # Google Drive (for Google Calendar)
libkgapi                       # Google API integration

# Encryption Support
kleopatra                      # Certificate manager
gnupg                          # GPG encryption
pinentry-qt                    # GPG PIN entry

# Optional Enhancements
kdepim-runtime                 # Additional runtime components
kmail-account-wizard           # Email setup wizard
grantlee-editor                # Email template editor
pim-data-exporter              # Backup/restore tool

# Notification Sounds (if using custom)
# Place in: /usr/share/sounds/sanchala/notifications/
# - calendar.ogg (event reminders)
# - email.ogg (new mail)
# - contact.ogg (contact updates)

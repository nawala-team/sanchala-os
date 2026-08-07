#!/usr/bin/env python3
"""Cloud Provider Configurations for Sanchala Cloud"""

PROVIDERS = {
    "gdrive": {
        "name": "Google Drive",
        "rclone_type": "drive",
        "icon": "google-drive",
        "oauth": True,
        "features": ["sync", "stream", "share", "team_drives"],
        "config_fields": []
    },
    "dropbox": {
        "name": "Dropbox",
        "rclone_type": "dropbox",
        "icon": "dropbox",
        "oauth": True,
        "features": ["sync", "stream", "share"],
        "config_fields": []
    },
    "onedrive": {
        "name": "Microsoft OneDrive",
        "rclone_type": "onedrive",
        "icon": "onedrive",
        "oauth": True,
        "features": ["sync", "stream", "share", "sharepoint"],
        "config_fields": []
    },
    "nextcloud": {
        "name": "Nextcloud",
        "rclone_type": "webdav",
        "icon": "nextcloud",
        "oauth": False,
        "features": ["sync", "stream", "share"],
        "config_fields": ["url", "user", "pass"]
    },
    "mega": {
        "name": "MEGA",
        "rclone_type": "mega",
        "icon": "mega",
        "oauth": False,
        "features": ["sync", "e2e_encryption"],
        "config_fields": ["user", "pass"]
    },
    "s3": {
        "name": "Amazon S3",
        "rclone_type": "s3",
        "icon": "amazon",
        "oauth": False,
        "features": ["sync", "versioning"],
        "config_fields": ["access_key_id", "secret_access_key", "region", "bucket"]
    },
    "b2": {
        "name": "Backblaze B2",
        "rclone_type": "b2",
        "icon": "backblaze",
        "oauth": False,
        "features": ["sync", "versioning"],
        "config_fields": ["account", "key", "bucket"]
    },
    "webdav": {
        "name": "WebDAV",
        "rclone_type": "webdav",
        "icon": "webdav",
        "oauth": False,
        "features": ["sync"],
        "config_fields": ["url", "user", "pass"]
    },
    "sftp": {
        "name": "SFTP",
        "rclone_type": "sftp",
        "icon": "sftp",
        "oauth": False,
        "features": ["sync"],
        "config_fields": ["host", "user", "port", "key_file"]
    },
    "pcloud": {
        "name": "pCloud",
        "rclone_type": "pcloud",
        "icon": "pcloud",
        "oauth": True,
        "features": ["sync", "crypto"],
        "config_fields": []
    }
}


def get_provider(provider_id: str) -> dict:
    return PROVIDERS.get(provider_id, {})


def list_providers() -> list:
    return [{"id": k, **v} for k, v in PROVIDERS.items()]


def get_oauth_providers() -> list:
    return [k for k, v in PROVIDERS.items() if v.get("oauth")]

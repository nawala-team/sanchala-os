//! Permission Management Module for Sanchala Guardian
//!
//! Implements TCC-like (Transparency, Consent, and Control) permission
//! management for Sanchala OS applications.

use std::collections::HashMap;
use std::fs;
use std::path::PathBuf;
use serde::{Deserialize, Serialize};

/// Permission types that applications can request
#[derive(Debug, Clone, PartialEq, Eq, Hash, Serialize, Deserialize)]
pub enum Permission {
    Camera,
    Microphone,
    Location,
    Contacts,
    Calendar,
    Photos,
    Documents,
    Downloads,
    RemovableMedia,
    ScreenRecording,
    Accessibility,
    InputMonitoring,
    FullDiskAccess,
    NetworkInbound,
    NetworkOutbound,
    Notifications,
    Autostart,
    BackgroundActivity,
}

impl Permission {
    /// Get human-readable name for the permission
    pub fn display_name(&self) -> &'static str {
        match self {
            Permission::Camera => "Camera",
            Permission::Microphone => "Microphone",
            Permission::Location => "Location Services",
            Permission::Contacts => "Contacts",
            Permission::Calendar => "Calendar",
            Permission::Photos => "Photos Library",
            Permission::Documents => "Documents Folder",
            Permission::Downloads => "Downloads Folder",
            Permission::RemovableMedia => "Removable Media",
            Permission::ScreenRecording => "Screen Recording",
            Permission::Accessibility => "Accessibility",
            Permission::InputMonitoring => "Input Monitoring",
            Permission::FullDiskAccess => "Full Disk Access",
            Permission::NetworkInbound => "Incoming Connections",
            Permission::NetworkOutbound => "Outgoing Connections",
            Permission::Notifications => "Notifications",
            Permission::Autostart => "Login Items",
            Permission::BackgroundActivity => "Background Activity",
        }
    }

    /// Get description of what the permission allows
    pub fn description(&self) -> &'static str {
        match self {
            Permission::Camera => "Access your camera for photos and video",
            Permission::Microphone => "Access your microphone for audio recording",
            Permission::Location => "Determine your approximate or precise location",
            Permission::Contacts => "Read and modify your contacts",
            Permission::Calendar => "Read and modify your calendar events",
            Permission::Photos => "Access photos in your library",
            Permission::Documents => "Access files in your Documents folder",
            Permission::Downloads => "Access files in your Downloads folder",
            Permission::RemovableMedia => "Access removable drives and media",
            Permission::ScreenRecording => "Record the contents of your screen",
            Permission::Accessibility => "Control your computer using accessibility features",
            Permission::InputMonitoring => "Monitor keyboard, mouse, and trackpad input",
            Permission::FullDiskAccess => "Access all files on your computer",
            Permission::NetworkInbound => "Accept incoming network connections",
            Permission::NetworkOutbound => "Make outgoing network connections",
            Permission::Notifications => "Show notifications on your desktop",
            Permission::Autostart => "Start automatically when you log in",
            Permission::BackgroundActivity => "Run in the background",
        }
    }
}

/// Permission decision made by user
#[derive(Debug, Clone, PartialEq, Serialize, Deserialize)]
pub enum PermissionDecision {
    Allow,
    Deny,
    AllowOnce,
    AskEveryTime,
}

/// Permission entry for an application
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct PermissionEntry {
    pub app_id: String,
    pub app_name: String,
    pub permission: Permission,
    pub decision: PermissionDecision,
    pub granted_at: Option<u64>,
    pub expires_at: Option<u64>,
}

/// Application permission record
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct AppPermissions {
    pub app_id: String,
    pub app_name: String,
    pub executable_path: String,
    pub permissions: HashMap<Permission, PermissionDecision>,
    pub first_seen: u64,
    pub last_access: u64,
}

/// Permission database manager
pub struct PermissionManager {
    db_path: PathBuf,
    apps: HashMap<String, AppPermissions>,
}

impl PermissionManager {
    /// Create a new permission manager
    pub fn new() -> Self {
        let db_path = dirs::config_dir()
            .unwrap_or_else(|| PathBuf::from("/etc"))
            .join("sanchala")
            .join("permissions.json");

        let mut manager = PermissionManager {
            db_path,
            apps: HashMap::new(),
        };
        manager.load();
        manager
    }

    /// Load permissions from disk
    fn load(&mut self) {
        if let Ok(content) = fs::read_to_string(&self.db_path) {
            if let Ok(apps) = serde_json::from_str(&content) {
                self.apps = apps;
            }
        }
    }

    /// Save permissions to disk
    pub fn save(&self) -> Result<(), String> {
        if let Some(parent) = self.db_path.parent() {
            fs::create_dir_all(parent).map_err(|e| e.to_string())?;
        }
        let content = serde_json::to_string_pretty(&self.apps).map_err(|e| e.to_string())?;
        fs::write(&self.db_path, content).map_err(|e| e.to_string())
    }

    /// Check if an app has a specific permission
    pub fn check_permission(&self, app_id: &str, permission: &Permission) -> PermissionDecision {
        self.apps
            .get(app_id)
            .and_then(|app| app.permissions.get(permission))
            .cloned()
            .unwrap_or(PermissionDecision::AskEveryTime)
    }

    /// Set permission for an application
    pub fn set_permission(&mut self, app_id: &str, app_name: &str, 
                          executable: &str, permission: Permission, 
                          decision: PermissionDecision) {
        let now = std::time::SystemTime::now()
            .duration_since(std::time::UNIX_EPOCH)
            .unwrap_or_default()
            .as_secs();

        let app = self.apps.entry(app_id.to_string()).or_insert_with(|| {
            AppPermissions {
                app_id: app_id.to_string(),
                app_name: app_name.to_string(),
                executable_path: executable.to_string(),
                permissions: HashMap::new(),
                first_seen: now,
                last_access: now,
            }
        });

        app.permissions.insert(permission, decision);
        app.last_access = now;
    }

    /// Revoke a permission from an application
    pub fn revoke_permission(&mut self, app_id: &str, permission: &Permission) {
        if let Some(app) = self.apps.get_mut(app_id) {
            app.permissions.remove(permission);
        }
    }

    /// Revoke all permissions from an application
    pub fn revoke_all(&mut self, app_id: &str) {
        self.apps.remove(app_id);
    }

    /// List all apps with their permissions
    pub fn list_apps(&self) -> Vec<&AppPermissions> {
        self.apps.values().collect()
    }

    /// Get permissions for a specific app
    pub fn get_app_permissions(&self, app_id: &str) -> Option<&AppPermissions> {
        self.apps.get(app_id)
    }

    /// List all apps with a specific permission granted
    pub fn apps_with_permission(&self, permission: &Permission) -> Vec<&AppPermissions> {
        self.apps
            .values()
            .filter(|app| {
                app.permissions.get(permission) == Some(&PermissionDecision::Allow)
            })
            .collect()
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_permission_display() {
        assert_eq!(Permission::Camera.display_name(), "Camera");
        assert_eq!(Permission::FullDiskAccess.display_name(), "Full Disk Access");
    }

    #[test]
    fn test_permission_decision() {
        let mut manager = PermissionManager::new();
        manager.set_permission("com.test.app", "Test App", "/usr/bin/test",
                               Permission::Camera, PermissionDecision::Allow);
        assert_eq!(manager.check_permission("com.test.app", &Permission::Camera),
                   PermissionDecision::Allow);
    }
}

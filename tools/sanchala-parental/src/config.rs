//! Sanchala Parental Controls - Configuration Module

use serde::{Deserialize, Serialize};
use std::path::Path;
use std::fs;

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Config {
    pub general: GeneralConfig,
    pub screentime: ScreentimeDefaults,
    pub content_filter: ContentFilterDefaults,
    pub notifications: NotificationConfig,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct GeneralConfig {
    pub enabled: bool,
    pub require_pin: bool,
    pub pin_hash: Option<String>,
    pub data_dir: String,
    pub log_level: String,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ScreentimeDefaults {
    pub default_daily_limit_minutes: u32,
    pub warning_minutes_before: u32,
    pub allow_extensions: bool,
    pub max_extension_minutes: u32,
    pub weekend_bonus_minutes: u32,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ContentFilterDefaults {
    pub default_level: String,
    pub safe_search_enforced: bool,
    pub block_adult_content: bool,
    pub block_social_media: bool,
    pub block_gaming: bool,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct NotificationConfig {
    pub notify_parent_on_block: bool,
    pub notify_child_warnings: bool,
    pub daily_report: bool,
    pub report_email: Option<String>,
}

impl Default for Config {
    fn default() -> Self {
        Config {
            general: GeneralConfig {
                enabled: true,
                require_pin: true,
                pin_hash: None,
                data_dir: "/var/lib/sanchala/parental".to_string(),
                log_level: "info".to_string(),
            },
            screentime: ScreentimeDefaults {
                default_daily_limit_minutes: 120,
                warning_minutes_before: 15,
                allow_extensions: true,
                max_extension_minutes: 30,
                weekend_bonus_minutes: 60,
            },
            content_filter: ContentFilterDefaults {
                default_level: "moderate".to_string(),
                safe_search_enforced: true,
                block_adult_content: true,
                block_social_media: false,
                block_gaming: false,
            },
            notifications: NotificationConfig {
                notify_parent_on_block: true,
                notify_child_warnings: true,
                daily_report: false,
                report_email: None,
            },
        }
    }
}

impl Config {
    pub fn load(path: &Path) -> Result<Self, Box<dyn std::error::Error>> {
        if path.exists() {
            let content = fs::read_to_string(path)?;
            let config: Config = toml::from_str(&content)?;
            Ok(config)
        } else {
            Ok(Config::default())
        }
    }

    pub fn save(&self, path: &Path) -> Result<(), Box<dyn std::error::Error>> {
        let content = toml::to_string_pretty(self)?;
        if let Some(parent) = path.parent() {
            fs::create_dir_all(parent)?;
        }
        fs::write(path, content)?;
        Ok(())
    }
}

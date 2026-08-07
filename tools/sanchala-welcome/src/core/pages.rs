//! Page definitions and validation

use serde::{Deserialize, Serialize};
use crate::core::validation::ValidationResult;

/// Language page data
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct LanguageData {
    pub locale: String,
    pub language_name: String,
    pub country_code: String,
}

/// Region page data
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct RegionData {
    pub timezone: String,
    pub country: String,
    pub date_format: String,
    pub time_format: TimeFormat,
    pub currency: String,
    pub first_day_of_week: Weekday,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub enum TimeFormat {
    Hour12,
    Hour24,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub enum Weekday {
    Sunday,
    Monday,
    Saturday,
}

/// Keyboard page data
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct KeyboardData {
    pub layout: String,
    pub variant: Option<String>,
    pub model: String,
}

/// Network page data
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct NetworkData {
    pub connection_type: ConnectionType,
    pub ssid: Option<String>,
    pub configured: bool,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub enum ConnectionType {
    Ethernet,
    WiFi,
    None,
}

/// Account page data
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct AccountData {
    pub full_name: String,
    pub username: String,
    pub password_hash: String,
    pub avatar_path: Option<String>,
    pub auto_login: bool,
}

/// Security page data
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct SecurityData {
    pub disk_encrypted: bool,
    pub secure_boot_enabled: bool,
    pub biometric_enabled: bool,
    pub biometric_type: Option<BiometricType>,
    pub firewall_enabled: bool,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub enum BiometricType {
    Fingerprint,
    FaceId,
}

/// Privacy page data
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct PrivacyData {
    pub telemetry_enabled: bool,
    pub crash_reports_enabled: bool,
    pub location_services_enabled: bool,
    pub analytics_enabled: bool,
}

impl Default for PrivacyData {
    fn default() -> Self {
        // Privacy-first: all OFF by default
        Self {
            telemetry_enabled: false,
            crash_reports_enabled: false,
            location_services_enabled: false,
            analytics_enabled: false,
        }
    }
}

/// Appearance page data
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct AppearanceData {
    pub theme: Theme,
    pub accent_color: String,
    pub wallpaper: String,
    pub icon_theme: String,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub enum Theme {
    Light,
    Dark,
    Auto,
}

/// Online accounts page data
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct OnlineAccountsData {
    pub accounts: Vec<OnlineAccount>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct OnlineAccount {
    pub provider: String,
    pub email: String,
    pub services: Vec<String>,
}

/// All done page data
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct AllDoneData {
    pub setup_duration_secs: u64,
    pub show_tour: bool,
}

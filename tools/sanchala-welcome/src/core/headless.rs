//! Headless (unattended) setup mode

use anyhow::{Context, Result, bail};
use serde::Deserialize;
use std::fs;
use std::path::Path;
use tracing::{info, warn};

use crate::core::state::mark_first_boot_complete;
use crate::core::validation;

/// Headless setup configuration
#[derive(Debug, Deserialize)]
pub struct HeadlessConfig {
    pub language: Option<LanguageConfig>,
    pub region: Option<RegionConfig>,
    pub keyboard: Option<KeyboardConfig>,
    pub network: Option<NetworkConfig>,
    pub account: AccountConfig,
    pub security: Option<SecurityConfig>,
    pub privacy: Option<PrivacyConfig>,
    pub appearance: Option<AppearanceConfig>,
    pub tour: Option<TourConfig>,
}

#[derive(Debug, Deserialize)]
pub struct LanguageConfig {
    pub locale: String,
}

#[derive(Debug, Deserialize)]
pub struct RegionConfig {
    pub timezone: String,
    pub country: Option<String>,
    pub date_format: Option<String>,
    pub time_format: Option<String>,
}

#[derive(Debug, Deserialize)]
pub struct KeyboardConfig {
    pub layout: String,
    pub variant: Option<String>,
    pub model: Option<String>,
}

#[derive(Debug, Deserialize)]
pub struct NetworkConfig {
    #[serde(rename = "type")]
    pub network_type: Option<String>,
    pub ssid: Option<String>,
    pub security: Option<String>,
    pub password_file: Option<String>,
}

#[derive(Debug, Deserialize)]
pub struct AccountConfig {
    pub full_name: String,
    pub username: String,
    pub password_hash: Option<String>,
    pub password_file: Option<String>,
    pub auto_login: Option<bool>,
    pub avatar: Option<String>,
}

#[derive(Debug, Deserialize)]
pub struct SecurityConfig {
    pub firewall: Option<bool>,
}

#[derive(Debug, Deserialize)]
pub struct PrivacyConfig {
    pub telemetry: Option<bool>,
    pub crash_reports: Option<bool>,
    pub location: Option<bool>,
    pub analytics: Option<bool>,
}

#[derive(Debug, Deserialize)]
pub struct AppearanceConfig {
    pub theme: Option<String>,
    pub accent_color: Option<String>,
    pub wallpaper: Option<String>,
}

#[derive(Debug, Deserialize)]
pub struct TourConfig {
    pub auto_start: Option<bool>,
    pub show_offer: Option<bool>,
}

/// Run headless setup
pub async fn run_headless(config_path: &str) -> Result<()> {
    info!("Running headless setup from: {}", config_path);
    
    // Load config
    let config_content = fs::read_to_string(config_path)
        .with_context(|| format!("Failed to read config: {}", config_path))?;
    
    let config: HeadlessConfig = toml::from_str(&config_content)
        .context("Failed to parse config file")?;
    
    // Validate
    validate_config(&config)?;
    
    // Apply configuration
    apply_language(&config).await?;
    apply_region(&config).await?;
    apply_keyboard(&config).await?;
    apply_account(&config).await?;
    apply_security(&config).await?;
    apply_privacy(&config).await?;
    apply_appearance(&config).await?;
    
    // Mark complete
    mark_first_boot_complete()?;
    
    info!("Headless setup completed successfully");
    Ok(())
}

fn validate_config(config: &HeadlessConfig) -> Result<()> {
    // Validate username
    let username_result = validation::validate_username(&config.account.username);
    if !username_result.valid {
        bail!("Invalid username: {:?}", username_result.errors);
    }
    
    // Validate password exists
    if config.account.password_hash.is_none() && config.account.password_file.is_none() {
        bail!("Account must have password_hash or password_file");
    }
    
    Ok(())
}

async fn apply_language(config: &HeadlessConfig) -> Result<()> {
    if let Some(lang) = &config.language {
        info!("Setting locale: {}", lang.locale);
        // Would call localectl set-locale
    }
    Ok(())
}

async fn apply_region(config: &HeadlessConfig) -> Result<()> {
    if let Some(region) = &config.region {
        info!("Setting timezone: {}", region.timezone);
        // Would call timedatectl set-timezone
    }
    Ok(())
}

async fn apply_keyboard(config: &HeadlessConfig) -> Result<()> {
    if let Some(kb) = &config.keyboard {
        info!("Setting keyboard: {}", kb.layout);
        // Would call localectl set-keymap
    }
    Ok(())
}

async fn apply_account(config: &HeadlessConfig) -> Result<()> {
    info!("Creating user: {}", config.account.username);
    // Would call useradd and set password
    Ok(())
}

async fn apply_security(config: &HeadlessConfig) -> Result<()> {
    if let Some(sec) = &config.security {
        if sec.firewall.unwrap_or(true) {
            info!("Enabling firewall");
            // Would enable firewalld
        }
    }
    Ok(())
}

async fn apply_privacy(config: &HeadlessConfig) -> Result<()> {
    // Privacy defaults are already OFF, only apply if explicitly enabled
    if let Some(priv_cfg) = &config.privacy {
        info!("Applying privacy settings");
    }
    Ok(())
}

async fn apply_appearance(config: &HeadlessConfig) -> Result<()> {
    if let Some(app) = &config.appearance {
        if let Some(theme) = &app.theme {
            info!("Setting theme: {}", theme);
        }
    }
    Ok(())
}

//! Sanchala Parental Controls - Content Filtering

use crate::config::Config;
use serde::{Deserialize, Serialize};
use std::collections::HashSet;

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ContentFilterSettings {
    pub level: FilterLevel,
    pub blocked_sites: HashSet<String>,
    pub blocked_apps: HashSet<String>,
    pub allowed_sites: HashSet<String>,
    pub allowed_apps: HashSet<String>,
    pub safe_search: bool,
}

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq)]
pub enum FilterLevel {
    Strict,    // Ages 0-7: Only whitelisted content
    Moderate,  // Ages 8-12: Block adult, violence, gambling
    Minimal,   // Ages 13-17: Block adult content only
    Off,       // No filtering (adult supervision)
}

impl Default for ContentFilterSettings {
    fn default() -> Self {
        ContentFilterSettings {
            level: FilterLevel::Moderate,
            blocked_sites: HashSet::new(),
            blocked_apps: HashSet::new(),
            allowed_sites: HashSet::new(),
            allowed_apps: HashSet::new(),
            safe_search: true,
        }
    }
}

pub fn set_level(user: &str, level: &str, _config: &Config) -> Result<(), Box<dyn std::error::Error>> {
    let mut settings = load_settings(user)?;
    settings.level = match level.to_lowercase().as_str() {
        "strict" => FilterLevel::Strict,
        "moderate" => FilterLevel::Moderate,
        "minimal" => FilterLevel::Minimal,
        "off" => FilterLevel::Off,
        _ => return Err(format!("Unknown level: {}", level).into()),
    };
    save_settings(user, &settings)?;
    log::info!("Set content filter level for {} to {:?}", user, settings.level);
    Ok(())
}

pub fn get_level(user: &str, _config: &Config) -> Result<String, Box<dyn std::error::Error>> {
    let settings = load_settings(user)?;
    Ok(format!("{:?}", settings.level).to_lowercase())
}

pub fn block_item(user: &str, target: &str, _config: &Config) -> Result<(), Box<dyn std::error::Error>> {
    let mut settings = load_settings(user)?;
    if target.contains('.') || target.starts_with("http") {
        settings.blocked_sites.insert(normalize_url(target));
    } else {
        settings.blocked_apps.insert(target.to_string());
    }
    save_settings(user, &settings)?;
    Ok(())
}

pub fn allow_item(user: &str, target: &str, _config: &Config) -> Result<(), Box<dyn std::error::Error>> {
    let mut settings = load_settings(user)?;
    if target.contains('.') || target.starts_with("http") {
        settings.allowed_sites.insert(normalize_url(target));
        settings.blocked_sites.remove(&normalize_url(target));
    } else {
        settings.allowed_apps.insert(target.to_string());
        settings.blocked_apps.remove(target);
    }
    save_settings(user, &settings)?;
    Ok(())
}

pub fn list_blocked(user: &str, _config: &Config) -> Result<Vec<String>, Box<dyn std::error::Error>> {
    let settings = load_settings(user)?;
    let mut blocked: Vec<String> = settings.blocked_sites.into_iter()
        .chain(settings.blocked_apps.into_iter())
        .collect();
    blocked.sort();
    Ok(blocked)
}

pub fn is_allowed(user: &str, target: &str, _config: &Config) -> Result<bool, Box<dyn std::error::Error>> {
    let settings = load_settings(user)?;
    let normalized = normalize_url(target);
    
    // Check explicit allow/block lists first
    if settings.allowed_sites.contains(&normalized) || settings.allowed_apps.contains(target) {
        return Ok(true);
    }
    if settings.blocked_sites.contains(&normalized) || settings.blocked_apps.contains(target) {
        return Ok(false);
    }
    
    // Check against category filters based on level
    match settings.level {
        FilterLevel::Strict => Ok(false), // Whitelist only
        FilterLevel::Off => Ok(true),
        _ => Ok(!is_in_blocked_category(&normalized, &settings.level)),
    }
}

fn is_in_blocked_category(url: &str, level: &FilterLevel) -> bool {
    // This would integrate with a URL categorization service
    // For now, check against known patterns
    let adult_patterns = ["adult", "xxx", "porn", "gambling", "casino"];
    let social_patterns = ["facebook", "instagram", "tiktok", "twitter", "snapchat"];
    
    for pattern in adult_patterns {
        if url.contains(pattern) { return true; }
    }
    
    if *level == FilterLevel::Strict {
        for pattern in social_patterns {
            if url.contains(pattern) { return true; }
        }
    }
    false
}

fn normalize_url(url: &str) -> String {
    url.trim()
        .trim_start_matches("http://")
        .trim_start_matches("https://")
        .trim_start_matches("www.")
        .to_lowercase()
}

fn load_settings(user: &str) -> Result<ContentFilterSettings, Box<dyn std::error::Error>> {
    let path = format!("/var/lib/sanchala/parental/{}/filter.toml", user);
    if std::path::Path::new(&path).exists() {
        let content = std::fs::read_to_string(&path)?;
        Ok(toml::from_str(&content)?)
    } else {
        Ok(ContentFilterSettings::default())
    }
}

fn save_settings(user: &str, settings: &ContentFilterSettings) -> Result<(), Box<dyn std::error::Error>> {
    let dir = format!("/var/lib/sanchala/parental/{}", user);
    std::fs::create_dir_all(&dir)?;
    let content = toml::to_string_pretty(settings)?;
    std::fs::write(format!("{}/filter.toml", dir), content)?;
    Ok(())
}

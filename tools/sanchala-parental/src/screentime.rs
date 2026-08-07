//! Sanchala Parental Controls - Screen Time Management

use crate::config::Config;
use chrono::{Local, NaiveTime, Weekday, Datelike};
use serde::{Deserialize, Serialize};
use std::collections::HashMap;

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ScreenTimeSettings {
    pub daily_limit_minutes: u32,
    pub schedule_start: Option<NaiveTime>,
    pub schedule_end: Option<NaiveTime>,
    pub bedtime: Option<NaiveTime>,
    pub weekend_schedule: Option<WeekendSchedule>,
    pub used_today_minutes: u32,
    pub extensions_granted: u32,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct WeekendSchedule {
    pub daily_limit_minutes: u32,
    pub schedule_start: Option<NaiveTime>,
    pub schedule_end: Option<NaiveTime>,
    pub bedtime: Option<NaiveTime>,
}

impl Default for ScreenTimeSettings {
    fn default() -> Self {
        ScreenTimeSettings {
            daily_limit_minutes: 120,
            schedule_start: Some(NaiveTime::from_hms_opt(8, 0, 0).unwrap()),
            schedule_end: Some(NaiveTime::from_hms_opt(21, 0, 0).unwrap()),
            bedtime: Some(NaiveTime::from_hms_opt(21, 0, 0).unwrap()),
            weekend_schedule: None,
            used_today_minutes: 0,
            extensions_granted: 0,
        }
    }
}

pub fn set_daily_limit(user: &str, minutes: u32, _config: &Config) -> Result<(), Box<dyn std::error::Error>> {
    let mut settings = load_settings(user)?;
    settings.daily_limit_minutes = minutes;
    save_settings(user, &settings)?;
    log::info!("Set daily limit for {} to {} minutes", user, minutes);
    Ok(())
}

pub fn set_schedule(user: &str, start: &str, end: &str, _config: &Config) -> Result<(), Box<dyn std::error::Error>> {
    let mut settings = load_settings(user)?;
    settings.schedule_start = Some(NaiveTime::parse_from_str(start, "%H:%M")?);
    settings.schedule_end = Some(NaiveTime::parse_from_str(end, "%H:%M")?);
    save_settings(user, &settings)?;
    log::info!("Set schedule for {} to {} - {}", user, start, end);
    Ok(())
}

pub fn set_bedtime(user: &str, time: &str, _config: &Config) -> Result<(), Box<dyn std::error::Error>> {
    let mut settings = load_settings(user)?;
    settings.bedtime = Some(NaiveTime::parse_from_str(time, "%H:%M")?);
    save_settings(user, &settings)?;
    log::info!("Set bedtime for {} to {}", user, time);
    Ok(())
}

pub fn grant_extension(user: &str, minutes: u32, config: &Config) -> Result<(), Box<dyn std::error::Error>> {
    let mut settings = load_settings(user)?;
    let max = config.screentime.max_extension_minutes;
    
    if settings.extensions_granted + minutes > max {
        return Err(format!("Extension would exceed max {} minutes", max).into());
    }
    
    settings.extensions_granted += minutes;
    save_settings(user, &settings)?;
    log::info!("Granted {} minutes extension to {}", minutes, user);
    Ok(())
}

pub fn get_remaining(user: &str, config: &Config) -> Result<u32, Box<dyn std::error::Error>> {
    let settings = load_settings(user)?;
    let now = Local::now();
    
    // Check if weekend and has bonus
    let mut limit = settings.daily_limit_minutes;
    if matches!(now.weekday(), Weekday::Sat | Weekday::Sun) {
        limit += config.screentime.weekend_bonus_minutes;
    }
    
    // Add extensions
    limit += settings.extensions_granted;
    
    // Calculate remaining
    let remaining = limit.saturating_sub(settings.used_today_minutes);
    Ok(remaining)
}

pub fn is_allowed_now(user: &str, _config: &Config) -> Result<(bool, String), Box<dyn std::error::Error>> {
    let settings = load_settings(user)?;
    let now = Local::now().time();
    
    // Check schedule
    if let (Some(start), Some(end)) = (settings.schedule_start, settings.schedule_end) {
        if now < start {
            return Ok((false, format!("Computer time starts at {}", start.format("%H:%M"))));
        }
        if now > end {
            return Ok((false, format!("Computer time ended at {}", end.format("%H:%M"))));
        }
    }
    
    // Check bedtime
    if let Some(bedtime) = settings.bedtime {
        if now > bedtime {
            return Ok((false, format!("It's past bedtime ({})", bedtime.format("%H:%M"))));
        }
    }
    
    // Check remaining time
    if settings.used_today_minutes >= settings.daily_limit_minutes + settings.extensions_granted {
        return Ok((false, "Daily time limit reached".to_string()));
    }
    
    Ok((true, "Access allowed".to_string()))
}

pub fn record_usage(user: &str, minutes: u32) -> Result<(), Box<dyn std::error::Error>> {
    let mut settings = load_settings(user)?;
    settings.used_today_minutes += minutes;
    save_settings(user, &settings)?;
    Ok(())
}

pub fn reset_daily_usage(user: &str) -> Result<(), Box<dyn std::error::Error>> {
    let mut settings = load_settings(user)?;
    settings.used_today_minutes = 0;
    settings.extensions_granted = 0;
    save_settings(user, &settings)?;
    log::info!("Reset daily usage for {}", user);
    Ok(())
}

fn load_settings(user: &str) -> Result<ScreenTimeSettings, Box<dyn std::error::Error>> {
    let path = format!("/var/lib/sanchala/parental/{}/screentime.toml", user);
    if std::path::Path::new(&path).exists() {
        let content = std::fs::read_to_string(&path)?;
        Ok(toml::from_str(&content)?)
    } else {
        Ok(ScreenTimeSettings::default())
    }
}

fn save_settings(user: &str, settings: &ScreenTimeSettings) -> Result<(), Box<dyn std::error::Error>> {
    let dir = format!("/var/lib/sanchala/parental/{}", user);
    std::fs::create_dir_all(&dir)?;
    let path = format!("{}/screentime.toml", dir);
    let content = toml::to_string_pretty(settings)?;
    std::fs::write(path, content)?;
    Ok(())
}

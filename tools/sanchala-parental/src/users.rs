//! Sanchala Parental Controls - User Management

use crate::config::Config;
use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct SupervisedUser {
    pub name: String,
    pub age: u8,
    pub profile: String,
    pub created_at: String,
}

pub fn add_supervised_user(username: &str, age: u8, profile: &str, _config: &Config) -> Result<(), Box<dyn std::error::Error>> {
    // Check user exists on system
    if !user_exists(username) {
        return Err(format!("User '{}' does not exist on system", username).into());
    }
    
    let user = SupervisedUser {
        name: username.to_string(),
        age,
        profile: profile.to_string(),
        created_at: chrono::Local::now().to_rfc3339(),
    };
    
    let dir = format!("/var/lib/sanchala/parental/{}", username);
    std::fs::create_dir_all(&dir)?;
    let content = toml::to_string_pretty(&user)?;
    std::fs::write(format!("{}/user.toml", dir), content)?;
    
    log::info!("Added supervised user: {} (age: {}, profile: {})", username, age, profile);
    Ok(())
}

pub fn remove_supervision(username: &str, _config: &Config) -> Result<(), Box<dyn std::error::Error>> {
    let dir = format!("/var/lib/sanchala/parental/{}", username);
    if std::path::Path::new(&dir).exists() {
        std::fs::remove_dir_all(&dir)?;
    }
    log::info!("Removed supervision from user: {}", username);
    Ok(())
}

pub fn list_supervised(_config: &Config) -> Result<Vec<SupervisedUser>, Box<dyn std::error::Error>> {
    let base = "/var/lib/sanchala/parental";
    let mut users = Vec::new();
    
    if let Ok(entries) = std::fs::read_dir(base) {
        for entry in entries.flatten() {
            let path = entry.path().join("user.toml");
            if path.exists() {
                if let Ok(content) = std::fs::read_to_string(&path) {
                    if let Ok(user) = toml::from_str::<SupervisedUser>(&content) {
                        users.push(user);
                    }
                }
            }
        }
    }
    Ok(users)
}

pub fn get_user(username: &str, _config: &Config) -> Result<SupervisedUser, Box<dyn std::error::Error>> {
    let path = format!("/var/lib/sanchala/parental/{}/user.toml", username);
    let content = std::fs::read_to_string(&path)?;
    Ok(toml::from_str(&content)?)
}

pub fn set_age(username: &str, age: u8, config: &Config) -> Result<(), Box<dyn std::error::Error>> {
    let mut user = get_user(username, config)?;
    user.age = age;
    let dir = format!("/var/lib/sanchala/parental/{}", username);
    let content = toml::to_string_pretty(&user)?;
    std::fs::write(format!("{}/user.toml", dir), content)?;
    Ok(())
}

fn user_exists(username: &str) -> bool {
    std::process::Command::new("id")
        .arg(username)
        .output()
        .map(|o| o.status.success())
        .unwrap_or(false)
}

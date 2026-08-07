//! AccountsService D-Bus integration for Sanchala OS

use serde::{Deserialize, Serialize};
use std::process::Command;

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct UserInfo {
    pub username: String,
    pub fullname: String,
    pub uid: u32,
    pub gid: u32,
    pub home: String,
    pub shell: String,
    pub is_admin: bool,
    pub locked: bool,
    pub icon_file: Option<String>,
}

/// List all users via AccountsService D-Bus
pub fn list_users() -> Result<Vec<UserInfo>, Box<dyn std::error::Error>> {
    let mut users = Vec::new();
    
    // Read /etc/passwd for user info
    let passwd = std::fs::read_to_string("/etc/passwd")?;
    
    for line in passwd.lines() {
        let fields: Vec<&str> = line.split(':').collect();
        if fields.len() >= 7 {
            let uid: u32 = fields[2].parse().unwrap_or(0);
            let username = fields[0].to_string();
            
            // Check if user is in wheel group (admin)
            let is_admin = is_in_group(&username, "wheel");
            
            // Check if account is locked
            let locked = is_account_locked(&username);
            
            users.push(UserInfo {
                username: username.clone(),
                fullname: fields[4].split(',').next().unwrap_or(&username).to_string(),
                uid,
                gid: fields[3].parse().unwrap_or(0),
                home: fields[5].to_string(),
                shell: fields[6].to_string(),
                is_admin,
                locked,
                icon_file: get_icon_file(&username),
            });
        }
    }
    
    Ok(users)
}

/// Get single user info
pub fn get_user(username: &str) -> Result<Option<UserInfo>, Box<dyn std::error::Error>> {
    let users = list_users()?;
    Ok(users.into_iter().find(|u| u.username == username))
}

/// Set user property via AccountsService D-Bus
pub fn set_user_property(username: &str, property: &str, value: &str) -> Result<(), Box<dyn std::error::Error>> {
    // Use dbus-send to set AccountsService property
    let user_path = format!("/org/freedesktop/Accounts/User{}", get_uid(username)?);
    
    let output = Command::new("dbus-send")
        .args([
            "--system",
            "--print-reply",
            "--dest=org.freedesktop.Accounts",
            &user_path,
            &format!("org.freedesktop.Accounts.User.Set{}", property),
            &format!("string:{}", value),
        ])
        .output();
    
    match output {
        Ok(o) if o.status.success() => {
            log::info!("Set {} = {} for {}", property, value, username);
            Ok(())
        }
        Ok(o) => {
            // Fallback: write to AccountsService cache file
            write_accounts_cache(username, property, value)?;
            Ok(())
        }
        Err(e) => {
            log::warn!("D-Bus call failed, using fallback: {}", e);
            write_accounts_cache(username, property, value)?;
            Ok(())
        }
    }
}

/// Get user property from AccountsService
pub fn get_user_property(username: &str, property: &str) -> Result<Option<String>, Box<dyn std::error::Error>> {
    let cache_path = format!("/var/lib/AccountsService/users/{}", username);
    
    if let Ok(content) = std::fs::read_to_string(&cache_path) {
        for line in content.lines() {
            if line.starts_with(&format!("{}=", property)) {
                return Ok(Some(line.split('=').nth(1).unwrap_or("").to_string()));
            }
        }
    }
    
    Ok(None)
}

fn get_uid(username: &str) -> Result<u32, Box<dyn std::error::Error>> {
    let output = Command::new("id")
        .args(["-u", username])
        .output()?;
    
    let uid_str = String::from_utf8_lossy(&output.stdout);
    Ok(uid_str.trim().parse()?)
}

fn is_in_group(username: &str, group: &str) -> bool {
    Command::new("id")
        .args(["-nG", username])
        .output()
        .map(|o| String::from_utf8_lossy(&o.stdout).contains(group))
        .unwrap_or(false)
}

fn is_account_locked(username: &str) -> bool {
    Command::new("passwd")
        .args(["-S", username])
        .output()
        .map(|o| String::from_utf8_lossy(&o.stdout).contains(" L "))
        .unwrap_or(false)
}

fn get_icon_file(username: &str) -> Option<String> {
    get_user_property(username, "Icon").ok().flatten()
}

fn write_accounts_cache(username: &str, property: &str, value: &str) -> Result<(), Box<dyn std::error::Error>> {
    let cache_dir = "/var/lib/AccountsService/users";
    std::fs::create_dir_all(cache_dir)?;
    
    let cache_path = format!("{}/{}", cache_dir, username);
    let mut content = std::fs::read_to_string(&cache_path).unwrap_or_default();
    
    // Update or add property
    let prop_line = format!("{}={}", property, value);
    let prop_prefix = format!("{}=", property);
    
    if content.contains(&prop_prefix) {
        let lines: Vec<&str> = content.lines()
            .map(|l| if l.starts_with(&prop_prefix) { &prop_line } else { l })
            .collect();
        content = lines.join("\n");
    } else {
        if !content.ends_with('\n') && !content.is_empty() {
            content.push('\n');
        }
        content.push_str(&prop_line);
        content.push('\n');
    }
    
    std::fs::write(cache_path, content)?;
    Ok(())
}

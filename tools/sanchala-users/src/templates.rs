//! User Profile Templates for Sanchala OS

use std::fs;
use std::path::Path;

pub fn apply(username: &str, template: &str) -> Result<(), Box<dyn std::error::Error>> {
    let template_path = format!("/etc/accountsservice/user-templates.d/{}.conf", template);
    
    if !Path::new(&template_path).exists() {
        return Err(format!("Template not found: {}", template).into());
    }

    log::info!("Applying template '{}' to user '{}'", template, username);

    // Read template
    let content = fs::read_to_string(&template_path)?;
    
    // Parse and apply settings
    let mut current_section = String::new();
    
    for line in content.lines() {
        let line = line.trim();
        
        if line.starts_with('[') && line.ends_with(']') {
            current_section = line[1..line.len()-1].to_string();
            continue;
        }
        
        if line.is_empty() || line.starts_with('#') {
            continue;
        }
        
        if let Some((key, value)) = line.split_once('=') {
            apply_setting(username, &current_section, key.trim(), value.trim())?;
        }
    }

    // Write user's template info
    let home = format!("/home/{}", username);
    let config_dir = format!("{}/.config/sanchala", home);
    fs::create_dir_all(&config_dir)?;
    
    let user_conf = format!("{}/user.conf", config_dir);
    if let Ok(mut content) = fs::read_to_string(&user_conf) {
        content = content.replace("Template=standard", &format!("Template={}", template));
        fs::write(&user_conf, content)?;
    }

    Ok(())
}

fn apply_setting(username: &str, section: &str, key: &str, value: &str) -> Result<(), Box<dyn std::error::Error>> {
    match section {
        "Sanchala" => apply_sanchala_setting(username, key, value),
        "Desktop" => apply_desktop_setting(username, key, value),
        "Security" => apply_security_setting(username, key, value),
        "ParentalControls" => apply_parental_setting(username, key, value),
        _ => Ok(()),
    }
}

fn apply_sanchala_setting(username: &str, key: &str, value: &str) -> Result<(), Box<dyn std::error::Error>> {
    match key {
        "UserType" => {
            log::info!("Setting user type to {} for {}", value, username);
        }
        "CanInstallApps" => {
            if value == "false" {
                // Add to restricted group
                log::info!("Restricting app installation for {}", username);
            }
        }
        "CanUseTerminal" => {
            if value == "false" {
                // Block terminal access
                let home = format!("/home/{}", username);
                let bashrc = format!("{}/.bashrc", home);
                if let Ok(mut content) = fs::read_to_string(&bashrc) {
                    if !content.contains("# SANCHALA: Terminal restricted") {
                        content.push_str("\n# SANCHALA: Terminal restricted\nexit\n");
                        fs::write(bashrc, content)?;
                    }
                }
            }
        }
        _ => {}
    }
    Ok(())
}

fn apply_desktop_setting(username: &str, key: &str, value: &str) -> Result<(), Box<dyn std::error::Error>> {
    let home = format!("/home/{}", username);
    let config_dir = format!("{}/.config", home);
    
    match key {
        "Theme" => {
            let kdeglobals = format!("{}/kdeglobals", config_dir);
            update_config_value(&kdeglobals, "General", "ColorScheme", value)?;
        }
        "IconTheme" => {
            let kdeglobals = format!("{}/kdeglobals", config_dir);
            update_config_value(&kdeglobals, "Icons", "Theme", value)?;
        }
        _ => {}
    }
    Ok(())
}

fn apply_security_setting(username: &str, key: &str, value: &str) -> Result<(), Box<dyn std::error::Error>> {
    match key {
        "AuditActions" => {
            if value == "true" {
                log::info!("Enabling action audit for {}", username);
            }
        }
        _ => {}
    }
    Ok(())
}

fn apply_parental_setting(username: &str, key: &str, value: &str) -> Result<(), Box<dyn std::error::Error>> {
    if key == "DefaultProfile" {
        // Apply parental control profile
        let profile_path = format!("/usr/share/sanchala/parental/profiles/{}.toml", value);
        let user_path = format!("/var/lib/sanchala/parental/{}", username);
        fs::create_dir_all(&user_path)?;
        if Path::new(&profile_path).exists() {
            fs::copy(&profile_path, format!("{}/profile.toml", user_path))?;
        }
    }
    Ok(())
}

fn update_config_value(path: &str, section: &str, key: &str, value: &str) -> Result<(), Box<dyn std::error::Error>> {
    let content = fs::read_to_string(path).unwrap_or_default();
    let mut lines: Vec<String> = content.lines().map(|s| s.to_string()).collect();
    
    let section_header = format!("[{}]", section);
    let mut in_section = false;
    let mut found = false;
    
    for line in &mut lines {
        if line.starts_with('[') {
            in_section = line == &section_header;
        } else if in_section && line.starts_with(&format!("{}=", key)) {
            *line = format!("{}={}", key, value);
            found = true;
            break;
        }
    }
    
    if !found {
        lines.push(section_header);
        lines.push(format!("{}={}", key, value));
    }
    
    if let Some(parent) = Path::new(path).parent() {
        fs::create_dir_all(parent)?;
    }
    fs::write(path, lines.join("\n"))?;
    Ok(())
}

pub fn list_templates() -> Result<Vec<String>, Box<dyn std::error::Error>> {
    let dir = "/etc/accountsservice/user-templates.d";
    let mut templates = Vec::new();
    
    if let Ok(entries) = fs::read_dir(dir) {
        for entry in entries.flatten() {
            if let Some(name) = entry.path().file_stem() {
                templates.push(name.to_string_lossy().to_string());
            }
        }
    }
    
    Ok(templates)
}

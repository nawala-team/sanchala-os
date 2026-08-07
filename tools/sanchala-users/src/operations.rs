//! User management operations

use std::process::Command;
use crate::accountsservice;
use crate::templates;

pub fn create_user(username: &str, fullname: Option<&str>, template: &str, admin: bool) -> Result<(), Box<dyn std::error::Error>> {
    println!("Creating user: {}", username);

    if !username.chars().all(|c| c.is_alphanumeric() || c == '_' || c == '-') {
        return Err("Invalid username".into());
    }

    let mut cmd = Command::new("useradd");
    cmd.args(["-m", "-s", "/bin/bash"]);
    
    if let Some(name) = fullname {
        cmd.args(["-c", name]);
    }
    
    if admin {
        cmd.args(["-G", "wheel"]);
    }
    
    cmd.arg(username);
    
    if !cmd.status()?.success() {
        return Err("Failed to create user".into());
    }

    templates::apply(username, template)?;

    Command::new("cp")
        .args(["-rT", "/etc/skel", &format!("/home/{}", username)])
        .status()?;

    Command::new("chown")
        .args(["-R", &format!("{}:{}", username, username), &format!("/home/{}", username)])
        .status()?;

    println!("✓ User {} created (template: {}, admin: {})", username, template, admin);
    Ok(())
}

pub fn delete_user(username: &str, remove_home: bool) -> Result<(), Box<dyn std::error::Error>> {
    if username == "root" || username == "guest" {
        return Err("Cannot delete system user".into());
    }

    let mut cmd = Command::new("userdel");
    if remove_home { cmd.arg("-r"); }
    cmd.arg(username);

    if cmd.status()?.success() {
        println!("✓ User {} deleted", username);
        Ok(())
    } else {
        Err("Failed to delete user".into())
    }
}

pub fn list_users(show_all: bool) -> Result<(), Box<dyn std::error::Error>> {
    println!("\n╔════════════════════════════════════════════╗");
    println!("║       SANCHALA OS - User Accounts          ║");
    println!("╚════════════════════════════════════════════╝\n");

    for user in accountsservice::list_users()? {
        if !show_all && user.uid < 1000 && user.username != "guest" {
            continue;
        }
        let icon = if user.is_admin { "👑" } else { "👤" };
        println!("  {} {} - {}", icon, user.username, user.fullname);
        println!("     UID: {} | Home: {}\n", user.uid, user.home);
    }
    Ok(())
}

pub fn show_user_info(username: Option<String>) -> Result<(), Box<dyn std::error::Error>> {
    let name = username.unwrap_or_else(|| std::env::var("USER").unwrap_or_default());
    
    if let Some(user) = accountsservice::get_user(&name)? {
        println!("\n👤 User: {}", user.username);
        println!("   Full Name: {}", user.fullname);
        println!("   UID: {} | Admin: {}", user.uid, user.is_admin);
        println!("   Home: {}", user.home);
    } else {
        println!("User not found: {}", name);
    }
    Ok(())
}

pub fn toggle_guest(enable: bool) -> Result<(), Box<dyn std::error::Error>> {
    let config = "/etc/sanchala/users/guest.conf";
    let content = std::fs::read_to_string(config)?;
    let (from, to) = if enable {
        ("enabled = false", "enabled = true")
    } else {
        ("enabled = true", "enabled = false")
    };
    std::fs::write(config, content.replace(from, to))?;
    println!("✓ Guest mode {}", if enable { "enabled" } else { "disabled" });
    Ok(())
}

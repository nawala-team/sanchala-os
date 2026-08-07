//! Sanchala Parental Controls - Background Daemon
//! 
//! Monitors screen time, enforces limits, and tracks activity.

use std::time::Duration;
use tokio::time::interval;

mod config;
mod screentime;
mod content_filter;
mod activity;
mod users;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    env_logger::init();
    log::info!("Sanchala Parental Daemon starting...");

    let config_path = std::path::PathBuf::from("/etc/sanchala/parental/config.toml");
    let config = config::Config::load(&config_path)?;

    if !config.general.enabled {
        log::info!("Parental controls disabled in config");
        return Ok(());
    }

    // Start monitoring tasks
    let config_clone = config.clone();
    let screentime_task = tokio::spawn(async move {
        screentime_monitor(config_clone).await
    });

    let config_clone = config.clone();
    let activity_task = tokio::spawn(async move {
        activity_tracker(config_clone).await
    });

    let midnight_task = tokio::spawn(async {
        midnight_reset().await
    });

    log::info!("Parental daemon running");
    
    tokio::select! {
        _ = screentime_task => log::error!("Screentime monitor stopped"),
        _ = activity_task => log::error!("Activity tracker stopped"),
        _ = midnight_task => log::error!("Midnight reset stopped"),
        _ = tokio::signal::ctrl_c() => log::info!("Shutdown signal received"),
    }

    log::info!("Sanchala Parental Daemon stopped");
    Ok(())
}

async fn screentime_monitor(config: config::Config) {
    let mut ticker = interval(Duration::from_secs(60));
    
    loop {
        ticker.tick().await;
        
        if let Ok(users) = users::list_supervised(&config) {
            for user in users {
                check_user_screentime(&user.name, &config).await;
            }
        }
    }
}

async fn check_user_screentime(username: &str, config: &config::Config) {
    // Check if user is logged in
    if !is_user_logged_in(username) {
        return;
    }

    // Record 1 minute of usage
    let _ = screentime::record_usage(username, 1);

    // Check if access is still allowed
    match screentime::is_allowed_now(username, config) {
        Ok((allowed, reason)) => {
            if !allowed {
                log::info!("Time limit reached for {}: {}", username, reason);
                send_warning(username, &reason).await;
                
                // Give 5 minute grace period, then lock
                tokio::time::sleep(Duration::from_secs(300)).await;
                
                if is_user_logged_in(username) {
                    lock_user_session(username).await;
                }
            }
        }
        Err(e) => log::error!("Error checking screentime for {}: {}", username, e),
    }

    // Check remaining time for warnings
    if let Ok(remaining) = screentime::get_remaining(username, config) {
        if remaining == config.screentime.warning_minutes_before {
            let msg = format!("{} minutes remaining", remaining);
            send_warning(username, &msg).await;
        }
    }
}

async fn activity_tracker(config: config::Config) {
    let mut ticker = interval(Duration::from_secs(30));
    
    loop {
        ticker.tick().await;
        
        if let Ok(users) = users::list_supervised(&config) {
            for user in users {
                if is_user_logged_in(&user.name) {
                    track_user_activity(&user.name).await;
                }
            }
        }
    }
}

async fn track_user_activity(username: &str) {
    // Get active window info via D-Bus/KWin
    if let Some((app, title)) = get_active_window(username) {
        let entry = activity::ActivityEntry {
            timestamp: chrono::Local::now(),
            app_name: app,
            window_title: title,
            duration_seconds: 30,
            category: "unknown".to_string(),
        };
        let _ = activity::record_activity(username, &entry);
    }
}

async fn midnight_reset() {
    loop {
        // Calculate time until midnight
        let now = chrono::Local::now();
        let tomorrow = (now + chrono::Duration::days(1)).date_naive();
        let midnight = tomorrow.and_hms_opt(0, 0, 0).unwrap();
        let until_midnight = midnight.signed_duration_since(now.naive_local());
        
        tokio::time::sleep(until_midnight.to_std().unwrap_or(Duration::from_secs(3600))).await;
        
        log::info!("Midnight: resetting daily usage counters");
        let config = config::Config::default();
        if let Ok(users) = users::list_supervised(&config) {
            for user in users {
                let _ = screentime::reset_daily_usage(&user.name);
            }
        }
    }
}

fn is_user_logged_in(username: &str) -> bool {
    std::process::Command::new("loginctl")
        .args(["show-user", username, "--property=State"])
        .output()
        .map(|o| String::from_utf8_lossy(&o.stdout).contains("active"))
        .unwrap_or(false)
}

async fn send_warning(username: &str, message: &str) {
    // Send desktop notification to user
    let _ = std::process::Command::new("sudo")
        .args(["-u", username, "notify-send", "-u", "critical", 
               "Sanchala Parental Controls", message])
        .spawn();
}

async fn lock_user_session(username: &str) {
    log::info!("Locking session for user: {}", username);
    let _ = std::process::Command::new("loginctl")
        .args(["lock-session", &format!("user-{}", username)])
        .spawn();
}

fn get_active_window(_username: &str) -> Option<(String, String)> {
    // Would use D-Bus to query KWin for active window
    // Placeholder implementation
    None
}

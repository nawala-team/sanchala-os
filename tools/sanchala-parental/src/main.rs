//! Sanchala Parental Controls - Main Entry Point
//! 
//! Part of SANCHALA OS - "Set Your System in Motion"

use clap::{Parser, Subcommand};
use std::path::PathBuf;

mod config;
mod screentime;
mod content_filter;
mod activity;
mod users;

/// Sanchala Parental Controls
#[derive(Parser)]
#[command(name = "sanchala-parental")]
#[command(version = "1.0.0")]
#[command(about = "Parental controls and screen time management")]
struct Cli {
    #[command(subcommand)]
    command: Commands,

    #[arg(short, long, default_value = "/etc/sanchala/parental/config.toml")]
    config: PathBuf,

    #[arg(short, long)]
    verbose: bool,
}

#[derive(Subcommand)]
enum Commands {
    /// Manage supervised users
    User {
        #[command(subcommand)]
        action: UserAction,
    },
    /// Screen time controls
    Screentime {
        #[command(subcommand)]
        action: ScreentimeAction,
    },
    /// Content filtering
    Filter {
        #[command(subcommand)]
        action: FilterAction,
    },
    /// View activity reports
    Activity {
        #[arg(short, long)]
        user: String,
        #[arg(short, long, default_value = "7")]
        days: u32,
    },
    /// Show current status
    Status {
        #[arg(short, long)]
        user: Option<String>,
    },
}

#[derive(Subcommand)]
enum UserAction {
    Add { username: String, age: u8, profile: Option<String> },
    Remove { username: String },
    List,
}

#[derive(Subcommand)]
enum ScreentimeAction {
    Limit { user: String, minutes: u32 },
    Schedule { user: String, start: String, end: String },
    Bedtime { user: String, time: String },
    Extend { user: String, minutes: u32 },
    Remaining { user: String },
}

#[derive(Subcommand)]
enum FilterAction {
    Level { user: String, level: String },
    Block { user: String, target: String },
    Allow { user: String, target: String },
    List { user: String },
}

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let cli = Cli::parse();
    env_logger::init();
    let config = config::Config::load(&cli.config)?;

    match cli.command {
        Commands::User { action } => match action {
            UserAction::Add { username, age, profile } => {
                let p = profile.unwrap_or_else(|| "standard".to_string());
                users::add_supervised_user(&username, age, &p, &config)?;
                println!("✓ User {} is now supervised", username);
            }
            UserAction::Remove { username } => {
                users::remove_supervision(&username, &config)?;
                println!("✓ Supervision removed from {}", username);
            }
            UserAction::List => {
                let list = users::list_supervised(&config)?;
                println!("\n📋 Supervised Users:\n");
                for u in list {
                    println!("  👤 {} (age: {}, profile: {})", u.name, u.age, u.profile);
                }
            }
        },
        Commands::Screentime { action } => match action {
            ScreentimeAction::Limit { user, minutes } => {
                screentime::set_daily_limit(&user, minutes, &config)?;
                println!("✓ Daily limit set to {} min for {}", minutes, user);
            }
            ScreentimeAction::Schedule { user, start, end } => {
                screentime::set_schedule(&user, &start, &end, &config)?;
                println!("✓ Schedule set for {}", user);
            }
            ScreentimeAction::Bedtime { user, time } => {
                screentime::set_bedtime(&user, &time, &config)?;
                println!("✓ Bedtime set for {}", user);
            }
            ScreentimeAction::Extend { user, minutes } => {
                screentime::grant_extension(&user, minutes, &config)?;
                println!("✓ Granted {} extra min to {}", minutes, user);
            }
            ScreentimeAction::Remaining { user } => {
                let r = screentime::get_remaining(&user, &config)?;
                println!("⏱️  {} has {} min remaining", user, r);
            }
        },
        Commands::Filter { action } => match action {
            FilterAction::Level { user, level } => {
                content_filter::set_level(&user, &level, &config)?;
                println!("✓ Filter level set to '{}' for {}", level, user);
            }
            FilterAction::Block { user, target } => {
                content_filter::block_item(&user, &target, &config)?;
                println!("✓ Blocked '{}' for {}", target, user);
            }
            FilterAction::Allow { user, target } => {
                content_filter::allow_item(&user, &target, &config)?;
                println!("✓ Allowed '{}' for {}", target, user);
            }
            FilterAction::List { user } => {
                let blocked = content_filter::list_blocked(&user, &config)?;
                println!("\n🚫 Blocked for {}:", user);
                for item in blocked { println!("  • {}", item); }
            }
        },
        Commands::Activity { user, days } => {
            let report = activity::get_report(&user, days, &config)?;
            println!("\n📊 Activity for {} ({} days)\n{}", user, days, report);
        }
        Commands::Status { user } => {
            println!("\n╔════════════════════════════════════════════╗");
            println!("║   SANCHALA PARENTAL CONTROLS - Status      ║");
            println!("╚════════════════════════════════════════════╝\n");
            let list = match user {
                Some(u) => vec![users::get_user(&u, &config)?],
                None => users::list_supervised(&config)?,
            };
            for u in list {
                let r = screentime::get_remaining(&u.name, &config).unwrap_or(0);
                println!("  👤 {} | Age: {} | ⏱️ {} min left", u.name, u.age, r);
            }
        }
    }
    Ok(())
}

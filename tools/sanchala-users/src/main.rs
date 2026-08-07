//! Sanchala Users - User Management Tool
//! 
//! Part of SANCHALA OS - "Set Your System in Motion"

use clap::{Parser, Subcommand};

mod accountsservice;
mod templates;
mod operations;

use operations::*;

#[derive(Parser)]
#[command(name = "sanchala-users")]
#[command(version = "1.0.0")]
#[command(about = "Sanchala OS User Management")]
struct Cli {
    #[command(subcommand)]
    command: Commands,
}

#[derive(Subcommand)]
enum Commands {
    /// Create a new user
    Create {
        username: String,
        #[arg(short, long)]
        fullname: Option<String>,
        #[arg(short, long, default_value = "standard")]
        template: String,
        #[arg(short, long)]
        admin: bool,
    },
    /// Delete a user
    Delete {
        username: String,
        #[arg(short, long)]
        remove_home: bool,
    },
    /// List all users
    List {
        #[arg(short, long)]
        all: bool,
    },
    /// Show user info
    Info { username: Option<String> },
    /// Enable guest mode
    GuestEnable,
    /// Disable guest mode  
    GuestDisable,
    /// Apply template to user
    ApplyTemplate { username: String, template: String },
}

fn main() -> Result<(), Box<dyn std::error::Error>> {
    env_logger::init();
    let cli = Cli::parse();

    match cli.command {
        Commands::Create { username, fullname, template, admin } => {
            create_user(&username, fullname.as_deref(), &template, admin)?;
        }
        Commands::Delete { username, remove_home } => {
            delete_user(&username, remove_home)?;
        }
        Commands::List { all } => {
            list_users(all)?;
        }
        Commands::Info { username } => {
            show_user_info(username)?;
        }
        Commands::GuestEnable => {
            toggle_guest(true)?;
        }
        Commands::GuestDisable => {
            toggle_guest(false)?;
        }
        Commands::ApplyTemplate { username, template } => {
            templates::apply(&username, &template)?;
            println!("✓ Applied template '{}' to {}", template, username);
        }
    }
    Ok(())
}

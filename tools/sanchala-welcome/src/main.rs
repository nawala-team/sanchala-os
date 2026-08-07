//! Sanchala Welcome - First-Run Setup Wizard
//!
//! Main entry point for the welcome wizard application.

mod config;
mod core;
mod dbus;
mod tour;
mod tips;

use anyhow::Result;
use clap::Parser;
use tracing::{info, Level};
use tracing_subscriber::FmtSubscriber;

#[derive(Parser, Debug)]
#[command(name = "sanchala-welcome")]
#[command(about = "Sanchala OS First-Run Setup Wizard")]
#[command(version)]
struct Args {
    /// Force re-run the setup wizard
    #[arg(long)]
    force: bool,

    /// Jump to specific page
    #[arg(long)]
    page: Option<String>,

    /// Run in headless mode with config file
    #[arg(long)]
    config: Option<String>,

    /// Headless mode (requires --config)
    #[arg(long)]
    headless: bool,

    /// Check if first boot is complete
    #[arg(long)]
    check_first_boot: bool,

    /// Launch feature tour
    #[arg(long)]
    tour: Option<Option<String>>,

    /// Show tips
    #[arg(long)]
    tips: bool,

    /// Reset welcome state
    #[arg(long)]
    reset: bool,

    /// Export current config
    #[arg(long)]
    export_config: bool,

    /// Verbose output
    #[arg(short, long)]
    verbose: bool,
}

fn setup_logging(verbose: bool) {
    let level = if verbose { Level::DEBUG } else { Level::INFO };
    
    let subscriber = FmtSubscriber::builder()
        .with_max_level(level)
        .with_target(false)
        .init();
}

#[tokio::main]
async fn main() -> Result<()> {
    let args = Args::parse();
    setup_logging(args.verbose);

    info!("Sanchala Welcome v{}", env!("CARGO_PKG_VERSION"));

    // Check first boot status
    if args.check_first_boot {
        let complete = core::state::is_first_boot_complete()?;
        std::process::exit(if complete { 0 } else { 1 });
    }

    // Reset state
    if args.reset {
        core::state::reset_state()?;
        info!("Welcome state reset successfully");
        return Ok(());
    }

    // Export config
    if args.export_config {
        let config = core::state::export_config()?;
        println!("{}", config);
        return Ok(());
    }

    // Launch tour
    if let Some(tour_id) = args.tour {
        let tour_name = tour_id.unwrap_or_else(|| "desktop".to_string());
        return tour::launch_tour(&tour_name).await;
    }

    // Show tips
    if args.tips {
        return tips::show_tips().await;
    }

    // Headless mode
    if args.headless {
        let config_path = args.config.ok_or_else(|| {
            anyhow::anyhow!("--headless requires --config")
        })?;
        return core::headless::run_headless(&config_path).await;
    }

    // Check if should run
    let should_run = args.force || !core::state::is_first_boot_complete()?;
    
    if !should_run {
        info!("First boot already complete. Use --force to re-run.");
        return Ok(());
    }

    // Launch wizard UI
    core::wizard::launch(args.page).await
}

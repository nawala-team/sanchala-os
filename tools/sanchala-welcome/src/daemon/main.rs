//! Sanchala Welcome Daemon
//!
//! D-Bus service for welcome wizard functionality.

use anyhow::Result;
use tracing::{info, Level};
use tracing_subscriber::FmtSubscriber;

// Import from parent crate would work in actual build
// For now, inline the server code

#[tokio::main]
async fn main() -> Result<()> {
    // Setup logging
    let subscriber = FmtSubscriber::builder()
        .with_max_level(Level::INFO)
        .with_target(false)
        .init();
    
    info!("Sanchala Welcome Daemon starting...");
    info!("D-Bus name: id.sanchala.Welcome1");
    
    // Start D-Bus server
    // In actual implementation:
    // sanchala_welcome::dbus::start_server().await?;
    
    info!("Daemon ready, waiting for requests...");
    
    // Keep running
    loop {
        tokio::time::sleep(tokio::time::Duration::from_secs(3600)).await;
    }
}

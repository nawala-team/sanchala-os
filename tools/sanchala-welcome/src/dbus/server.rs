//! D-Bus server setup

use anyhow::Result;
use tracing::info;
use zbus::ConnectionBuilder;

use super::interface::WelcomeInterface;

/// Start the D-Bus service
pub async fn start_server() -> Result<()> {
    info!("Starting D-Bus service: id.sanchala.Welcome1");
    
    let interface = WelcomeInterface::new();
    
    let _conn = ConnectionBuilder::session()?
        .name("id.sanchala.Welcome1")?
        .serve_at("/id/sanchala/Welcome1", interface)?
        .build()
        .await?;
    
    info!("D-Bus service started");
    
    // Keep running
    std::future::pending::<()>().await;
    
    Ok(())
}

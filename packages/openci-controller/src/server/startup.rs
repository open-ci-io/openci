use axum::Router;
use tokio::net::TcpListener;
use tracing::{error, info};

pub async fn run(app: Router, addr: &str) -> Result<(), std::io::Error> {
    let listener = TcpListener::bind(addr).await?;

    println!("Server running on http://{}", addr);

    let graceful = axum::serve(listener, app)
        .with_graceful_shutdown(shutdown_signal())
        .await
        .map_err(|e| std::io::Error::new(std::io::ErrorKind::Other, e));

    println!("Server has been shut down gracefully");
    graceful
}

async fn shutdown_signal() {
    let ctrl_c = async {
        match tokio::signal::ctrl_c().await {
            Ok(_) => {
                info!("Received Ctrl+C signal");
                Some(())
            }
            Err(e) => {
                error!("Failed to install Ctrl+C handler: {}", e);
                None
            }
        }
    };

    #[cfg(unix)]
    let terminate = async {
        match tokio::signal::unix::signal(tokio::signal::unix::SignalKind::terminate()) {
            Ok(mut signal) => {
                info!("SIGTERM signal handler installed successfully");
                signal.recv().await;
                Some(())
            }
            Err(e) => {
                error!("Failed to install SIGTERM handler: {}", e);
                None
            }
        }
    };

    #[cfg(not(unix))]
    let terminate = async { std::future::pending::<Option<()>>().await };

    tokio::select! {
        result = ctrl_c => {
            if result.is_some() {
                info!("Received Ctrl+C, starting graceful shutdown...");
            }
        },
        result = terminate => {
            if result.is_some() {
                info!("Received SIGTERM, starting graceful shutdown...");
            }
        },
    }
}

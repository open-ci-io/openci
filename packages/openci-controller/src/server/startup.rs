use axum::Router;
use tokio::net::TcpListener;

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
        tokio::signal::ctrl_c()
            .await
            .expect("Failed to install Ctrl+C handler");
    };

    #[cfg(unix)]
    let terminate = async {
        tokio::signal::unix::signal(tokio::signal::unix::SignalKind::terminate())
            .expect("Failed to install signal handler")
            .recv()
            .await;
    };

    #[cfg(not(unix))]
    let terminate = std::future::pending::<()>();

    tokio::select! {
        _ = ctrl_c => {
            println!("Received Ctrl+C, starting graceful shutdown...");
        },
        _ = terminate => {
            println!("Received SIGTERM, starting graceful shutdown...");
        },
    }
}

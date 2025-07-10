use axum::Router;
use tokio::net::TcpListener;

pub async fn run(app: Router, addr: &str) -> Result<(), std::io::Error> {
    let listener = TcpListener::bind(addr).await?;

    println!("Server running on http://{}", addr);

    axum::serve(listener, app)
        .await
        .map_err(|e| std::io::Error::new(std::io::ErrorKind::Other, e))
}

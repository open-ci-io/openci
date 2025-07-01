use axum::{routing::get, Router};

#[tokio::main(flavor = "current_thread")]
async fn main() {
    let app = Router::new()
        .route("/", get(|| async { "Hello, OpenCI!" }))
        .route("/health", get(|| async { "OK" }))
        .route("/sample", get(|| async { "sample" }))
        .route("/sample2", get(|| async { "sample2" }));

    let listener = tokio::net::TcpListener::bind("0.0.0.0:8080").await.unwrap();

    println!("Server running on http://0.0.0.0:8080");

    axum::serve(listener, app).await.unwrap();
}

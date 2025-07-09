use crate::models::{error_response::ErrorResponse, user::User};
use axum::{routing::get, Router};
use dotenvy::dotenv;
use sqlx::postgres::PgPoolOptions;
use std::env;
use utoipa::OpenApi;
use utoipa_swagger_ui::SwaggerUi;

mod handlers;
mod models;

#[tokio::main(flavor = "current_thread")]
async fn main() {
    dotenv().ok();
    let database_url = env::var("DATABASE_URL").expect("DATABASE_URL must be set");
    let pool = PgPoolOptions::new()
        .max_connections(5)
        .connect(&database_url)
        .await
        .unwrap_or_else(|err| {
            eprintln!("Failed to connect to database: {}", err);
            std::process::exit(1);
        });

    let app = Router::new()
        .route("/", get(|| async { "Hello, OpenCI!" }))
        .route("/users", get(crate::handlers::user_handler::get_users))
        .merge(SwaggerUi::new("/docs").url("/api-docs/openapi.json", ApiDoc::openapi()))
        .with_state(pool);

    let listener = tokio::net::TcpListener::bind("0.0.0.0:8080").await.unwrap();

    println!("Server running on http://0.0.0.0:8080");

    axum::serve(listener, app).await.unwrap();
}

#[derive(OpenApi)]
#[openapi(
    paths(handlers::user_handler::get_users),
    components(schemas(User, ErrorResponse))
)]
struct ApiDoc;

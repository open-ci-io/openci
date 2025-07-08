use crate::models::{error_response::ErrorResponse, user::User};
use axum::{routing::get, Router};
use dotenvy::dotenv;
use sqlx::{postgres::PgPoolOptions, Row};
use std::env;
use utoipa::OpenApi;
use utoipa_swagger_ui::SwaggerUi;

mod models;

#[tokio::main(flavor = "current_thread")]
async fn main() {
    dotenv().ok();
    let app = Router::new()
        .route("/", get(|| async { "Hello, OpenCI!" }))
        .route("/users", get(get_users))
        .merge(SwaggerUi::new("/swagger-ui").url("/api-docs/openapi.json", ApiDoc::openapi()));

    let listener = tokio::net::TcpListener::bind("0.0.0.0:8080").await.unwrap();

    println!("Server running on http://0.0.0.0:8080");

    axum::serve(listener, app).await.unwrap();
}

#[derive(OpenApi)]
#[openapi(paths(get_users), components(schemas(User, ErrorResponse)))]
struct ApiDoc;

#[utoipa::path(
    get,
    path = "/users",
    responses(
        (status = 200, description = "User found", body = User),
        (status = 404, description = "User not found")
    )
)]
async fn get_users() -> String {
    let database_url = env::var("DATABASE_URL").expect("DATABASE_URL must be set");

    let pool = PgPoolOptions::new()
        .max_connections(5)
        .connect(&database_url)
        .await
        .expect("Failed to connect to the database");

    let row = sqlx::query("SELECT * FROM users")
        .fetch_one(&pool)
        .await
        .expect("Failed to fetch users");

    let id: i32 = row.get("id");
    let name: String = row.get("name");

    format!("id: {}, name: {}", id, name)
}

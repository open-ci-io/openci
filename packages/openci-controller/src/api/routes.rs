use axum::{routing::get, Router};
use sqlx::PgPool;
use utoipa::OpenApi;
use utoipa_swagger_ui::SwaggerUi;

use super::doc::ApiDoc;
use crate::handlers;

pub fn create_routes(pool: PgPool) -> Router {
    Router::new()
        .route("/", get(|| async { "Hello, welcome to OpenCI!" }))
        .route("/users", get(handlers::user_handler::get_users))
        .merge(SwaggerUi::new("/docs").url("/api-docs/openapi.json", ApiDoc::openapi()))
        .with_state(pool)
}

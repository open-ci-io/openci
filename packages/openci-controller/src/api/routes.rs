use axum::{
    middleware,
    routing::{get, post},
    Router,
};
use sqlx::PgPool;
use utoipa::OpenApi;
use utoipa_swagger_ui::SwaggerUi;

use super::doc::ApiDoc;
use crate::{handlers, middleware::auth::auth_middleware};

pub fn create_routes(pool: PgPool) -> Router {
    let authenticated_routes = Router::new()
        .route("/users", get(handlers::user_handler::get_users))
        .route(
            "/users/{user_id}/api-keys",
            post(handlers::api_key_handler::create_api_key),
        )
        .route(
            "/workflows",
            post(handlers::workflow_handler::post_workflow),
        )
        .route_layer(middleware::from_fn_with_state(
            pool.clone(),
            auth_middleware,
        ));

    Router::new()
        .route("/", get(|| async { "Hello, welcome to OpenCI!" }))
        .merge(authenticated_routes)
        .merge(SwaggerUi::new("/docs").url("/api-docs/openapi.json", ApiDoc::openapi()))
        .with_state(pool)
}

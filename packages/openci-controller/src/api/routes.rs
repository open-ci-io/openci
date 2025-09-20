use axum::{
    middleware,
    routing::{delete, get, patch, post},
    Router,
};
use sqlx::PgPool;
use utoipa::OpenApi;
use utoipa_swagger_ui::SwaggerUi;

use super::doc::ApiDoc;
use crate::{
    handlers,
    middleware::{auth::auth_middleware, github_webhook_auth::github_webhook_auth_middleware},
};

pub fn create_routes(pool: PgPool) -> Router {
    let authenticated_routes = Router::new()
        .route(
            "/build_jobs/{build_job_id}",
            get(handlers::github_webhook_handler::get_build_job),
        )
        .route("/users", get(handlers::user_handler::get_users))
        .route(
            "/users/{user_id}/api-keys",
            post(handlers::api_key_handler::create_api_key),
        )
        .route(
            "/workflows",
            post(handlers::workflow_handler::post_workflow),
        )
        .route("/workflows", get(handlers::workflow_handler::get_workflows))
        .route(
            "/workflows/{workflow_id}",
            get(handlers::workflow_handler::get_workflow),
        )
        .route(
            "/workflows/{workflow_id}",
            patch(handlers::workflow_handler::patch_workflow),
        )
        .route(
            "/workflows/{workflow_id}",
            delete(handlers::workflow_handler::delete_workflow),
        )
        .route_layer(middleware::from_fn_with_state(
            pool.clone(),
            auth_middleware,
        ));

    Router::new()
        .route("/", get(|| async { "Hello, welcome to OpenCI!" }))
        .route(
            "/webhooks/github",
            post(handlers::github_webhook_handler::post_github_webhook_handler)
                .layer(middleware::from_fn(github_webhook_auth_middleware)),
        )
        .merge(authenticated_routes)
        .merge(SwaggerUi::new("/docs").url("/api-docs/openapi.json", ApiDoc::openapi()))
        .with_state(pool)
}

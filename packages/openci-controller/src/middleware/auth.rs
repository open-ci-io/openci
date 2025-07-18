use crate::services::api_key_service::validate_api_key;
use axum::{
    extract::{Request, State},
    http::StatusCode,
    middleware::Next,
    response::Response,
};
use sqlx::PgPool;

const API_KEY_HEADER: &str = "X-API-Key";

pub async fn auth_middleware(
    State(pool): State<PgPool>,
    mut request: Request,
    next: Next,
) -> Result<Response, StatusCode> {
    let api_key = request
        .headers()
        .get(API_KEY_HEADER)
        .and_then(|value| value.to_str().ok());

    let api_key = match api_key {
        Some(key) => key,
        None => return Err(StatusCode::UNAUTHORIZED),
    };

    let user_id = match validate_api_key(&pool, api_key).await {
        Some(id) => id,
        None => return Err(StatusCode::UNAUTHORIZED),
    };

    request.extensions_mut().insert(user_id);

    Ok(next.run(request).await)
}

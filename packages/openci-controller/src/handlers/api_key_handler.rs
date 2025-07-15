use crate::models::api_key::{CreateApiKeyRequest, CreateApiKeyResponse};
use crate::services::api_key_service::{
    create_full_api_key, generate_api_key_body, get_api_key_prefix, hash_api_key,
};
use axum::{
    extract::{Path, State},
    http::StatusCode,
    Json,
};
use sqlx::PgPool;
use tracing::error;

#[utoipa::path(
    post,
    path = "/users/{user_id}/api-keys",
    request_body = CreateApiKeyRequest,
    responses(
        (status = 201, description = "API key created successfully", body = CreateApiKeyResponse),
        (status = 500, description = "Internal server error")
    ),
    params(
        ("user_id" = i32, Path, description = "User ID")
    )
)]
pub async fn create_api_key(
    State(pool): State<PgPool>,
    Path(user_id): Path<i32>,
    Json(payload): Json<CreateApiKeyRequest>,
) -> Result<(StatusCode, Json<CreateApiKeyResponse>), (StatusCode, String)> {
    let api_key_body = generate_api_key_body();
    let full_api_key = create_full_api_key(&api_key_body);
    let hashed_key = hash_api_key(&full_api_key);

    let result = sqlx::query!(
        r#"
        INSERT INTO api_keys (user_id, name, hashed_key, prefix)
        VALUES ($1, $2, $3, $4)
        RETURNING id, created_at
        "#,
        user_id,
        payload.name,
        hashed_key,
        get_api_key_prefix(),
    )
    .fetch_one(&pool)
    .await
    .map_err(|e| {
        error!("Failed to create API key: {}", e);
        (
            StatusCode::INTERNAL_SERVER_ERROR,
            "Failed to create API key".into(),
        )
    })?;

    let response = CreateApiKeyResponse {
        id: result.id,
        name: payload.name,
        api_key: full_api_key,
        prefix: get_api_key_prefix().to_string(),
        created_at: result.created_at,
    };

    Ok((StatusCode::CREATED, Json(response)))
}

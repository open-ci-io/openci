use crate::models::api_key::{CreateApiKeyRequest, CreateApiKeyResponse};
use crate::services::api_key_service::{
    create_full_api_key, generate_api_key_body, get_api_key_prefix, hash_api_key,
};
use axum::{
    extract::{Path, State},
    http::StatusCode,
    Extension, // Extension を追加
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
        (status = 403, description = "Forbidden - Cannot create API keys for other users"),
        (status = 404, description = "User not found"),
        (status = 500, description = "Internal server error")
    ),
    params(
        ("user_id" = i32, Path, description = "User ID")
    )
)]
pub async fn create_api_key(
    State(pool): State<PgPool>,
    Path(user_id): Path<i32>,
    Extension(authenticated_user_id): Extension<i32>,
    Json(payload): Json<CreateApiKeyRequest>,
) -> Result<(StatusCode, Json<CreateApiKeyResponse>), (StatusCode, String)> {
    if authenticated_user_id != user_id {
        return Err((
            StatusCode::FORBIDDEN,
            "Cannot create API keys for other users".into(),
        ));
    }

    let user_exists = sqlx::query!(
        "SELECT EXISTS(SELECT 1 FROM users WHERE id = $1) as exists",
        user_id
    )
    .fetch_one(&pool)
    .await
    .map_err(|e| {
        error!("Failed to check user existence: {}", e);
        (
            StatusCode::INTERNAL_SERVER_ERROR,
            "Failed to verify user".into(),
        )
    })?;

    if !user_exists.exists.unwrap_or(false) {
        return Err((StatusCode::NOT_FOUND, "User not found".into()));
    }

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

#[cfg(test)]
mod tests {
    use super::*;
    use axum::Extension;
    use sqlx::PgPool;

    #[sqlx::test(fixtures("../../fixtures/users.sql"))]
    async fn test_create_api_key_forbidden_for_other_users(pool: PgPool) {
        let payload = CreateApiKeyRequest {
            name: "Test Key".to_string(),
        };

        let result = create_api_key(State(pool), Path(2), Extension(1), Json(payload)).await;

        assert!(result.is_err());
        let Err((status, message)) = result else {
            panic!("Expected error, but got Ok");
        };
        assert_eq!(status, StatusCode::FORBIDDEN);
        assert_eq!(message, "Cannot create API keys for other users");
    }

    #[sqlx::test(fixtures("../../fixtures/users.sql"))]
    async fn test_create_api_key_success_for_own_user(pool: PgPool) {
        let payload = CreateApiKeyRequest {
            name: "My API Key".to_string(),
        };

        let result = create_api_key(State(pool), Path(1), Extension(1), Json(payload)).await;

        assert!(result.is_ok());
        let (status, response) = result.unwrap();
        assert_eq!(status, StatusCode::CREATED);
        assert_eq!(response.name, "My API Key");
    }
}

use crate::models::api_key::{CreateApiKeyRequest, CreateApiKeyResponse};
use axum::{
    extract::{Path, State},
    http::StatusCode,
    Json,
};
use rand::Rng;
use sha2::{Digest, Sha256};
use sqlx::PgPool;

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
    let full_api_key = format!("{}{}", API_KEY_PREFIX, api_key_body);
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
        API_KEY_PREFIX,
    )
    .fetch_one(&pool)
    .await
    .map_err(|e| {
        eprintln!("Failed to create API key: {}", e);
        (
            StatusCode::INTERNAL_SERVER_ERROR,
            "Failed to create API key".into(),
        )
    })?;

    let response = CreateApiKeyResponse {
        id: result.id,
        name: payload.name,
        api_key: full_api_key,
        prefix: API_KEY_PREFIX.to_string(),
        created_at: result.created_at,
    };

    Ok((StatusCode::CREATED, Json(response)))
}

// #[utoipa::path(...)] // ← これもエンドポイント
// pub async fn list_api_keys(...) { /* APIキー一覧取得 */
// }

// #[utoipa::path(...)] // ← これもエンドポイント
// pub async fn delete_api_key(...) { /* APIキー削除 */
// }

pub async fn validate_api_key(pool: &PgPool, api_key: &str) -> Option<i32> {
    if !api_key.starts_with(API_KEY_PREFIX) {
        return None;
    }

    let hashed_key = hash_api_key(api_key);

    match sqlx::query!(
        r#"
        UPDATE api_keys
        SET last_used_at = NOW()
        WHERE hashed_key = $1
        RETURNING user_id
        "#,
        hashed_key
    )
    .fetch_optional(pool)
    .await
    {
        Ok(Some(record)) => Some(record.user_id),
        Ok(None) => None,
        Err(e) => {
            eprintln!("API key validation database error: {}", e);
            None
        }
    }
}

const API_KEY_PREFIX: &str = "opnci_";
const API_KEY_BODY_LENGTH: usize = 32;

fn generate_api_key_body() -> String {
    let charset: &[u8] = b"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    let mut rng = rand::rng();

    (0..API_KEY_BODY_LENGTH)
        .map(|_| {
            let idx = rng.random_range(0..charset.len());
            charset[idx] as char
        })
        .collect()
}

fn hash_api_key(api_key: &str) -> String {
    let mut hasher = Sha256::new();
    hasher.update(api_key.as_bytes());
    format!("{:x}", hasher.finalize())
}

use chrono::{DateTime, Utc};
use serde::{Deserialize, Serialize};
use sqlx::FromRow;
use utoipa::ToSchema;
use validator::Validate;

#[derive(Serialize, FromRow, ToSchema)]
pub struct ApiKey {
    pub id: i32,
    pub user_id: i32,
    pub name: String,
    #[serde(skip)]
    pub hashed_key: String,
    pub created_at: DateTime<Utc>,
    pub last_used_at: Option<DateTime<Utc>>,
    pub prefix: String,
}

#[derive(Deserialize, ToSchema, Validate)]
pub struct CreateApiKeyRequest {
    #[validate(length(min = 1, max = 64))]
    pub name: String,
}

#[derive(Serialize, ToSchema)]
pub struct CreateApiKeyResponse {
    pub id: i32,
    pub name: String,
    pub api_key: String,
    pub prefix: String,
    pub created_at: DateTime<Utc>,
}

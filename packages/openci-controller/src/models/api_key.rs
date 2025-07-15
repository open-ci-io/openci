use chrono::{DateTime, Utc};
use serde::{Deserialize, Serialize};
use sqlx::FromRow;
use utoipa::ToSchema;

#[derive(Serialize, FromRow, ToSchema)]
pub struct ApiKey {
    pub id: i32,
    pub user_id: i32,
    pub name: String,
    #[allow(dead_code)]
    #[serde(skip)]
    pub hashed_key: String,
    pub created_at: DateTime<Utc>,
    pub last_used_at: Option<DateTime<Utc>>,
    pub prefix: String,
}

#[derive(Deserialize, ToSchema)]
pub struct CreateApiKeyRequest {
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

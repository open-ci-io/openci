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
    #[validate(length(min = 1, max = 64), custom(function = "validate_api_key_name"))]
    pub name: String,
}

#[derive(Serialize, ToSchema)]
pub struct CreateApiKeyResponse {
    pub id: i32,
    pub name: String,
    /// WARNING: Contains the actual API key in plain text.
    /// This is only returned once during creation and should never be logged.
    /// The client must store this securely as it cannot be retrieved again.
    pub api_key: String,
    pub prefix: String,
    pub created_at: DateTime<Utc>,
}

impl std::fmt::Debug for CreateApiKeyResponse {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.debug_struct("CreateApiKeyResponse")
            .field("id", &self.id)
            .field("name", &self.name)
            .field("api_key", &"[REDACTED]")
            .field("prefix", &self.prefix)
            .field("created_at", &self.created_at)
            .finish()
    }
}

fn validate_api_key_name(name: &str) -> Result<(), validator::ValidationError> {
    if name.trim().is_empty() {
        return Err(validator::ValidationError::new(
            "name_cannot_be_empty_or_whitespace",
        ));
    }
    Ok(())
}

use chrono::{DateTime, Utc};
use serde::{Deserialize, Serialize};
use sqlx::{FromRow, Type};
use utoipa::ToSchema;

#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize, Type, ToSchema)]
#[sqlx(type_name = "text")]
#[serde(rename_all = "lowercase")]
pub enum UserRole {
    Admin,
    Member,
}

#[derive(Serialize, FromRow, ToSchema)]
pub struct User {
    pub id: i32,
    pub name: String,
    pub email: String,
    pub created_at: DateTime<Utc>,
    #[sqlx(try_from = "String")]
    pub role: UserRole,
}

impl TryFrom<String> for UserRole {
    type Error = String;

    fn try_from(value: String) -> Result<Self, Self::Error> {
        match value.as_str() {
            "admin" => Ok(UserRole::Admin),
            "member" => Ok(UserRole::Member),
            _ => Err(format!("Invalid role: {}", value)),
        }
    }
}

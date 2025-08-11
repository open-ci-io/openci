use chrono::{DateTime, Utc};
use serde::{Deserialize, Serialize};
use serde_json::Value;
use sqlx::encode::IsNull;
use sqlx::postgres::{PgArgumentBuffer, PgTypeInfo};
use sqlx::FromRow;
use utoipa::ToSchema;
use validator::Validate;

#[derive(Debug, Clone, Serialize, Deserialize, ToSchema, PartialEq)]
#[serde(rename_all = "camelCase")]
pub enum BuildStatus {
    Queued,
    InProgress,
    Failure,
    Success,
    Cancelled,
}

impl sqlx::Type<sqlx::Postgres> for BuildStatus {
    fn type_info() -> PgTypeInfo {
        PgTypeInfo::with_name("varchar")
    }
}

impl sqlx::Encode<'_, sqlx::Postgres> for BuildStatus {
    fn encode_by_ref(
        &self,
        buf: &mut PgArgumentBuffer,
    ) -> Result<IsNull, Box<dyn std::error::Error + Send + Sync>> {
        let value = match self {
            BuildStatus::Queued => "queued",
            BuildStatus::InProgress => "inProgress",
            BuildStatus::Failure => "failure",
            BuildStatus::Success => "success",
            BuildStatus::Cancelled => "cancelled",
        };
        <&str as sqlx::Encode<sqlx::Postgres>>::encode(value, buf)
    }
}

impl sqlx::Decode<'_, sqlx::Postgres> for BuildStatus {
    fn decode(
        value: sqlx::postgres::PgValueRef<'_>,
    ) -> Result<Self, Box<dyn std::error::Error + Send + Sync>> {
        let text = <String as sqlx::Decode<sqlx::Postgres>>::decode(value)?;
        match text.as_str() {
            "queued" => Ok(BuildStatus::Queued),
            "inProgress" => Ok(BuildStatus::InProgress),
            "failure" => Ok(BuildStatus::Failure),
            "success" => Ok(BuildStatus::Success),
            "cancelled" => Ok(BuildStatus::Cancelled),
            _ => Err(format!("Unknown build status: {}", text).into()),
        }
    }
}

#[derive(Serialize, FromRow, ToSchema, Debug)]
pub struct BuildJob {
    pub id: i32,
    pub workflow_id: Option<i32>,
    pub repository_id: i32,
    pub workflow_name: Option<String>,
    pub workflow_config: Option<Value>,
    pub build_status: BuildStatus,
    pub commit_sha: String,
    pub build_branch: String,
    pub base_branch: String,
    pub commit_message: Option<String>,
    pub commit_author_name: Option<String>,
    pub commit_author_email: Option<String>,
    pub pr_number: Option<i32>,
    pub pr_title: Option<String>,
    pub github_check_run_id: i64,
    pub github_app_id: i32,
    pub github_installation_id: i64,
    pub started_at: Option<DateTime<Utc>>,
    pub finished_at: Option<DateTime<Utc>>,
    pub worker_id: Option<String>,
    pub exit_code: Option<i32>,
    pub created_at: DateTime<Utc>,
}

#[derive(Debug, Deserialize, ToSchema, Validate)]
#[serde(rename_all = "camelCase")]
pub struct CreateBuildJobRequest {
    #[validate(range(min = 1))]
    pub workflow_id: Option<i32>,
    #[validate(range(min = 1))]
    pub repository_id: i32,
    #[validate(length(max = 255))]
    pub workflow_name: Option<String>,
    pub workflow_config: Option<Value>,
    #[validate(length(equal = 40))]
    pub commit_sha: String,
    #[validate(length(max = 255, min = 1))]
    pub build_branch: String,
    #[validate(length(max = 255, min = 1))]
    pub base_branch: String,
    #[validate(length(max = 255, min = 1))]
    pub commit_message: Option<String>,
    #[validate(length(max = 255, min = 1))]
    pub commit_author_name: Option<String>,
    #[validate(length(max = 255), email)]
    pub commit_author_email: Option<String>,
    #[validate(range(min = 1))]
    pub pr_number: Option<i32>,
    #[validate(length(max = 255))]
    pub pr_title: Option<String>,
    #[validate(range(min = 1))]
    pub github_check_run_id: i64,
    #[validate(range(min = 1))]
    pub github_app_id: i32,
    #[validate(range(min = 1))]
    pub github_installation_id: i64,
}

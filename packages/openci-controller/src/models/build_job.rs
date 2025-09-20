use chrono::{DateTime, Utc};
use serde::Serialize;

#[derive(Serialize, Debug)]
pub struct BuildJob {
    pub id: i32,
    pub workflow_id: i32,
    pub status: BuildStatus,
    pub created_at: DateTime<Utc>,
    pub updated_at: DateTime<Utc>,
    pub commit_sha: String,
    pub github_delivery_id: String,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, sqlx::Type)]
#[sqlx(type_name = "build_status", rename_all = "snake_case")]
pub enum BuildStatus {
    Queued,
    Running,
    Success,
    Failed,
    Cancelled,
    TimedOut,
    Skipped,
}

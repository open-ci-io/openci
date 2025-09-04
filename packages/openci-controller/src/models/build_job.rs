use chrono::{DateTime, Utc};

struct BuildJob {
    pub id: i32,
    pub workflow_id: i32,
    pub repository_id: i32,
    pub status: BuildStatus,
    pub created_at: DateTime<Utc>,
    pub updated_at: DateTime<Utc>,
    pub commit_sha: String,
    pub github_delivery_id: String,
}

enum BuildStatus {
    Queued,
    Running,
    Success,
    Failed,
    Cancelled,
    TimedOut,
    Skipped,
}

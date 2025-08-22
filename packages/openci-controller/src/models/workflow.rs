use chrono::{DateTime, Utc};
use serde::{Deserialize, Serialize};

#[derive(Debug, Serialize, Deserialize)]
#[serde(rename_all = "snake_case")]
pub struct Workflow {
    pub id: i32,
    pub name: String,
    pub created_at: DateTime<Utc>,
    pub updated_at: DateTime<Utc>,
    pub github_trigger_type: GitHubTriggerType,
}

#[derive(Debug, Serialize, Deserialize)]
#[serde(rename_all = "snake_case")]
pub struct CreateWorkflowRequest {
    pub name: String,
    pub github_trigger_type: GitHubTriggerType,
}

#[derive(Debug, Serialize, Deserialize, sqlx::Type, PartialEq)]
#[sqlx(type_name = "text", rename_all = "snake_case")]
pub enum GitHubTriggerType {
    Push,
    PullRequest,
}
impl From<String> for GitHubTriggerType {
    fn from(s: String) -> Self {
        match s.as_str() {
            "push" => GitHubTriggerType::Push,
            "pull_request" => GitHubTriggerType::PullRequest,
            _ => panic!("Invalid GitHubTriggerType: {}", s),
        }
    }
}
#[derive(Debug, Serialize, Deserialize)]
#[serde(rename_all = "snake_case")]
struct WorkflowStep {
    pub id: i32,
    pub workflow_id: i32,
    pub step_order: i32,
    pub name: String,
    pub command: String,
    pub created_at: DateTime<Utc>,
    pub updated_at: DateTime<Utc>,
}

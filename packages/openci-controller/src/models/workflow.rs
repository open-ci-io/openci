use chrono::{DateTime, Utc};
use mockall::predicate::str;
use serde::{Deserialize, Serialize};

#[derive(Debug, Serialize, Deserialize, utoipa::ToSchema)]
#[serde(rename_all = "snake_case")]
pub struct Workflow {
    pub id: i32,
    pub name: String,
    pub base_branch: String,
    pub created_at: DateTime<Utc>,
    pub updated_at: DateTime<Utc>,
    pub github_trigger_type: GitHubTriggerType,
}

#[derive(Debug, Serialize, Deserialize, utoipa::ToSchema)]
#[serde(rename_all = "snake_case")]
pub struct CreateWorkflowRequest {
    pub name: String,
    pub github_trigger_type: GitHubTriggerType,
    pub steps: Vec<CreateWorkflowStepRequest>,
    pub base_branch: String,
}

#[derive(Debug, Serialize, Deserialize, utoipa::ToSchema)]
#[serde(rename_all = "snake_case")]
#[schema(example = json!({
    "step_order": 1,
    "name": "Build",
    "command": "flutter build"
}))]
pub struct CreateWorkflowStepRequest {
    #[schema(minimum = 0, example = 1)]
    pub step_order: i32,

    #[schema(max_length = 255, example = "Build")]
    pub name: String,

    #[schema(max_length = 255, example = "flutter build")]
    pub command: String,
}

#[derive(Debug, Serialize, Deserialize, utoipa::ToSchema)]
pub struct WorkflowWithSteps {
    #[serde(flatten)]
    pub workflow: Workflow,
    pub steps: Vec<WorkflowStep>,
}

#[derive(Debug, serde::Deserialize, utoipa::ToSchema, validator::Validate)]
pub struct UpdateWorkflowRequest {
    pub name: Option<String>,
    pub github_trigger_type: Option<GitHubTriggerType>,
    pub steps: Option<Vec<UpdateWorkflowStep>>,
    #[validate(length(min = 1, max = 255))]
    pub base_branch: Option<String>,
}

#[derive(Debug, serde::Deserialize, utoipa::ToSchema)]
pub struct UpdateWorkflowStep {
    pub name: String,
    pub step_order: i32,
    pub command: String,
}

#[derive(Debug, Serialize, Deserialize, sqlx::Type, PartialEq, utoipa::ToSchema)]
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
#[derive(Debug, Serialize, Deserialize, utoipa::ToSchema)]
#[serde(rename_all = "snake_case")]
pub struct WorkflowStep {
    pub id: i32,
    pub workflow_id: i32,
    pub step_order: i32,
    pub name: String,
    pub command: String,
    pub created_at: DateTime<Utc>,
    pub updated_at: DateTime<Utc>,
}

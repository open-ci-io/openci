use crate::handlers::api_key_handler;
use crate::handlers::build_job_handler;
use crate::handlers::github_webhook_handler;
use crate::handlers::user_handler;
use crate::handlers::workflow_handler;
use crate::models::workflow::CreateWorkflowRequest;
use crate::models::workflow::CreateWorkflowStepRequest;
use crate::models::workflow::GitHubTriggerType;
use crate::models::workflow::UpdateWorkflowRequest;
use crate::models::workflow::Workflow;
use crate::models::workflow::WorkflowStep;
use crate::models::workflow::WorkflowWithSteps;
use crate::models::{
    api_key::{CreateApiKeyRequest, CreateApiKeyResponse},
    error_response::ErrorResponse,
    user::User,
};
use utoipa::OpenApi;

#[derive(OpenApi)]
#[openapi(
    info(
        title = "OpenCI API",
        version = "0.1.0",
        description = "OpenCI Controller API Documentation"
    ),
    paths(
        user_handler::get_users,
        api_key_handler::create_api_key,
        workflow_handler::post_workflow,
        workflow_handler::get_workflows,
        workflow_handler::get_workflow,
        workflow_handler::patch_workflow,
        workflow_handler::delete_workflow,
        build_job_handler::get_build_job,
        build_job_handler::get_build_jobs,
        github_webhook_handler::post_github_webhook_handler,
    ),
    components(schemas(
        User,
        ErrorResponse,
        CreateApiKeyRequest,
        CreateApiKeyResponse,
        GitHubTriggerType,
        Workflow,
        WorkflowStep,
        WorkflowWithSteps,
        CreateWorkflowRequest,
        CreateWorkflowStepRequest,
        UpdateWorkflowRequest,
    )),
    tags(
        (name = "build-jobs", description = "Build jobs endpoints"),
        (name = "users", description = "User management endpoints"),
        (name = "api-keys", description = "API key management endpoints"),
        (name = "workflows", description = "Workflow management endpoints"),
        (name = "webhooks", description = "GitHub webhook endpoints"),
    )
)]
pub struct ApiDoc;

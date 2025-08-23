use crate::models::workflow::{CreateWorkflowRequest, GitHubTriggerType, Workflow};
use axum::Json;
use axum::{extract::State, http::StatusCode};
use sqlx::PgPool;
use tracing::error;

#[utoipa::path(
    get,
    path = "/workflows",
    responses(
        (status = 200, description = "Workflows retrieved successfully", body = Vec<Workflow>),
        (status = 500, description = "Internal server error")
    )
)]
#[tracing::instrument(skip(pool))]
pub async fn get_workflows(
    State(pool): State<PgPool>,
) -> Result<Json<Vec<Workflow>>, (StatusCode, String)> {
    let workflows = sqlx::query_as!(
        Workflow,
        r#"
        SELECT id, name, created_at, updated_at, github_trigger_type
        FROM workflows
        ORDER BY created_at DESC, id DESC
        "#,
    )
    .fetch_all(&pool)
    .await
    .map_err(|e| {
        error!("Database error: {}", e);
        (
            StatusCode::INTERNAL_SERVER_ERROR,
            "Failed to create workflow".to_string(),
        )
    })?;

    Ok(Json(workflows))
}

#[utoipa::path(
    post,
    path = "/workflows",
    request_body = CreateWorkflowRequest,
    responses(
        (status = 201, description = "Workflow created successfully"),
        (status = 500, description = "Internal server error")
    )
)]
#[tracing::instrument(skip(pool))]
pub async fn post_workflow(
    State(pool): State<PgPool>,
    Json(request): Json<CreateWorkflowRequest>,
) -> Result<Json<Workflow>, (StatusCode, String)> {
    let workflow = sqlx::query_as!(
        Workflow,
        r#"
          INSERT INTO workflows (name, github_trigger_type)
          VALUES ($1, $2)
          RETURNING *
          "#,
        request.name,
        match request.github_trigger_type {
            GitHubTriggerType::Push => "push",
            GitHubTriggerType::PullRequest => "pull_request",
        }
    )
    .fetch_one(&pool)
    .await
    .map_err(|e| {
        error!("Database error: {}", e);
        (
            StatusCode::INTERNAL_SERVER_ERROR,
            "Failed to create workflow".to_string(),
        )
    })?;

    Ok(Json(workflow))
}

#[cfg(test)]
mod tests {
    use super::*;

    #[sqlx::test]
    async fn test_post_workflow_push_trigger(pool: PgPool) {
        let request = CreateWorkflowRequest {
            name: "test-workflow".to_string(),
            github_trigger_type: GitHubTriggerType::Push,
        };

        let result = post_workflow(State(pool), Json(request)).await;
        assert!(result.is_ok());

        let workflow = result.unwrap().0;
        assert_eq!(workflow.name, "test-workflow");
        assert_eq!(workflow.github_trigger_type, GitHubTriggerType::Push);
    }

    #[sqlx::test]
    async fn test_get_workflows_empty(pool: PgPool) {
        let request = get_workflows(State(pool)).await;
        assert!(request.is_ok());

        let workflows = request.unwrap().0;
        assert!(workflows.is_empty());
    }

    #[sqlx::test]
    async fn test_get_workflows_with_multiple_workflows(pool: PgPool) {
        let workflow1 = CreateWorkflowRequest {
            name: "workflow-1".to_string(),
            github_trigger_type: GitHubTriggerType::Push,
        };
        let workflow2 = CreateWorkflowRequest {
            name: "workflow-2".to_string(),
            github_trigger_type: GitHubTriggerType::PullRequest,
        };
        let workflow3 = CreateWorkflowRequest {
            name: "workflow-3".to_string(),
            github_trigger_type: GitHubTriggerType::Push,
        };

        let result1 = post_workflow(State(pool.clone()), Json(workflow1)).await;
        assert!(result1.is_ok());
        let created_workflow1 = result1.unwrap().0;

        let result2 = post_workflow(State(pool.clone()), Json(workflow2)).await;
        assert!(result2.is_ok());
        let created_workflow2 = result2.unwrap().0;

        let result3 = post_workflow(State(pool.clone()), Json(workflow3)).await;
        assert!(result3.is_ok());
        let created_workflow3 = result3.unwrap().0;

        let get_result = get_workflows(State(pool)).await;
        assert!(get_result.is_ok());

        let workflows = get_result.unwrap().0;

        assert_eq!(workflows.len(), 3);

        assert_eq!(workflows[0].id, created_workflow3.id);
        assert_eq!(workflows[0].name, "workflow-3");
        assert_eq!(workflows[1].id, created_workflow2.id);
        assert_eq!(workflows[1].name, "workflow-2");
        assert_eq!(workflows[2].id, created_workflow1.id);
        assert_eq!(workflows[2].name, "workflow-1");

        assert_eq!(workflows[0].github_trigger_type, GitHubTriggerType::Push);
        assert_eq!(
            workflows[1].github_trigger_type,
            GitHubTriggerType::PullRequest
        );
        assert_eq!(workflows[2].github_trigger_type, GitHubTriggerType::Push);
    }
}

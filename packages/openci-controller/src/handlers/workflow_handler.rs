use crate::models::workflow::{CreateWorkflowRequest, GitHubTriggerType, Workflow};
use axum::Json;
use axum::{extract::State, http::StatusCode};
use sqlx::PgPool;
use tracing::error;

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
}

use std::collections::HashMap;

use crate::models::workflow::{
    CreateWorkflowRequest, GitHubTriggerType, UpdateWorkflowRequest, Workflow, WorkflowStep,
    WorkflowWithSteps,
};
use axum::extract::Path;
use axum::Json;
use axum::{extract::State, http::StatusCode};
use sqlx::{PgPool, QueryBuilder};
use tracing::error;

#[utoipa::path(
    get,
    path = "/workflows",
    responses(
        (status = 200, description = "Workflows retrieved successfully", body = Vec<WorkflowWithSteps>),
        (status = 500, description = "Internal server error")
    )
)]
#[tracing::instrument(skip(pool))]
pub async fn get_workflows(
    State(pool): State<PgPool>,
) -> Result<Json<Vec<WorkflowWithSteps>>, (StatusCode, String)> {
    let workflows = sqlx::query_as!(
        Workflow,
        r#"
        SELECT id, name, created_at, updated_at, github_trigger_type
        FROM workflows
        ORDER BY updated_at DESC, id DESC
        "#,
    )
    .fetch_all(&pool)
    .await
    .map_err(|e| {
        error!("Database error: {}", e);
        (
            StatusCode::INTERNAL_SERVER_ERROR,
            "Failed to fetch workflows".to_string(),
        )
    })?;

    let workflow_ids: Vec<i32> = workflows.iter().map(|w| w.id).collect();

    let steps = if !workflow_ids.is_empty() {
        sqlx::query_as!(
            WorkflowStep,
            r#"
            SELECT id, workflow_id, step_order, name, command, created_at, updated_at
            FROM workflow_steps
            WHERE workflow_id = ANY($1)
            ORDER BY step_order
            "#,
            &workflow_ids[..]
        )
        .fetch_all(&pool)
        .await
        .map_err(|e| {
            error!("Failed to fetch workflow steps: {}", e);
            (
                StatusCode::INTERNAL_SERVER_ERROR,
                "Failed to fetch workflow details".to_string(),
            )
        })?
    } else {
        vec![]
    };

    let mut steps_map: HashMap<i32, Vec<WorkflowStep>> = HashMap::new();

    for step in steps {
        steps_map.entry(step.workflow_id).or_default().push(step);
    }

    let workflows_with_steps: Vec<WorkflowWithSteps> = workflows
        .into_iter()
        .map(|workflow| {
            let workflow_id = workflow.id;
            WorkflowWithSteps {
                workflow,
                steps: steps_map.remove(&workflow_id).unwrap_or_default(),
            }
        })
        .collect();

    Ok(Json(workflows_with_steps))
}

// pub struct WorkflowStep {
//     pub id: i32,
//     pub workflow_id: i32,
//     pub step_order: i32,
//     pub name: String,
//     pub command: String,
//     pub created_at: DateTime<Utc>,
//     pub updated_at: DateTime<Utc>,
// }

#[utoipa::path(
    get,
    path = "/workflows/{workflow_id}",
    responses(
        (status = 200, description = "Workflow retrieved successfully", body = WorkflowWithSteps),
        (status = 404, description = "Specified workflow not found"),
        (status = 500, description = "Internal server error")
    ),
    params(
          ("workflow_id" = i32, Path, description = "Workflow ID")
    )
)]
#[tracing::instrument(skip(pool))]
pub async fn get_workflow(
    State(pool): State<PgPool>,
    Path(workflow_id): Path<i32>,
) -> Result<Json<WorkflowWithSteps>, (StatusCode, String)> {
    let workflow = sqlx::query_as!(
        Workflow,
        r#"
    SELECT id, name, created_at, updated_at, github_trigger_type
    FROM workflows
    WHERE id = $1
    "#,
        workflow_id
    )
    .fetch_one(&pool)
    .await
    .map_err(|e| match e {
        sqlx::Error::RowNotFound => (StatusCode::NOT_FOUND, "Workflow not found".to_string()),
        _ => {
            error!("Database error: {}", e);
            (
                StatusCode::INTERNAL_SERVER_ERROR,
                "Failed to fetch workflow".to_string(),
            )
        }
    })?;

    let steps = sqlx::query_as!(
        WorkflowStep,
        r#"
        SELECT id, workflow_id, step_order, name, command, created_at, updated_at
        FROM workflow_steps
        WHERE workflow_id = $1
        ORDER BY step_order
        "#,
        workflow_id,
    )
    .fetch_all(&pool)
    .await
    .map_err(|e| {
        error!("Database error: {}", e);
        (
            StatusCode::INTERNAL_SERVER_ERROR,
            "Failed to fetch workflow steps".to_string(),
        )
    })?;

    let workflow_with_steps = WorkflowWithSteps { workflow, steps };

    Ok(Json(workflow_with_steps))
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
) -> Result<Json<WorkflowWithSteps>, (StatusCode, String)> {
    let mut tx = pool.begin().await.map_err(|e| {
        error!("Failed to begin transaction: {}", e);
        (
            StatusCode::INTERNAL_SERVER_ERROR,
            "Transaction error".to_string(),
        )
    })?;
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
    .fetch_one(&mut *tx)
    .await
    .map_err(|e| {
        error!("Database error: {}", e);
        (
            StatusCode::INTERNAL_SERVER_ERROR,
            "Failed to create workflow".to_string(),
        )
    })?;

    let mut created_steps = Vec::new();
    if !request.steps.is_empty() {
        let mut query = QueryBuilder::new(
            "INSERT INTO workflow_steps (workflow_id, step_order, name, command) ",
        );

        query.push_values(request.steps.iter(), |mut b, step| {
            b.push_bind(workflow.id)
                .push_bind(&step.step_order)
                .push_bind(&step.name)
                .push_bind(&step.command);
        });

        query.build().execute(&mut *tx).await.map_err(|e| {
            error!("Database error: {}", e);
            (
                StatusCode::INTERNAL_SERVER_ERROR,
                "Failed to create workflow steps".to_string(),
            )
        })?;

        created_steps = sqlx::query_as!(
            WorkflowStep,
            "SELECT * FROM workflow_steps WHERE workflow_id = $1 ORDER BY 
  step_order",
            workflow.id
        )
        .fetch_all(&mut *tx)
        .await
        .map_err(|e| {
            error!("Failed to fetch created workflow steps: {}", e);
            (
                StatusCode::INTERNAL_SERVER_ERROR,
                "Failed to fetch created workflow steps".to_string(),
            )
        })?;
    }

    tx.commit().await.map_err(|e| {
        error!("Failed to commit: {}", e);
        (
            StatusCode::INTERNAL_SERVER_ERROR,
            "Failed to commit".to_string(),
        )
    })?;

    Ok(Json(WorkflowWithSteps {
        workflow,
        steps: created_steps,
    }))
}

#[utoipa::path(
    patch,
    path = "/workflows/{workflow_id}",
    request_body = UpdateWorkflowRequest,
    responses(
        (status = 200, description = "Workflow updated successfully"),
        (status = 500, description = "Internal server error")
    )
)]
#[tracing::instrument(skip(pool))]
pub async fn patch_workflow(
    State(pool): State<PgPool>,
    Path(workflow_id): Path<i32>,
    Json(request): Json<UpdateWorkflowRequest>,
) -> Result<Json<Workflow>, (StatusCode, String)> {
    if let Some(name) = request.name {
        sqlx::query!(
            "UPDATE workflows SET name = $1, updated_at = NOW() WHERE id = $2",
            name,
            workflow_id
        )
        .execute(&pool)
        .await
        .map_err(|e| {
            error!("Failed to update name: {}", e);
            (
                StatusCode::INTERNAL_SERVER_ERROR,
                "Failed to update workflow".to_string(),
            )
        })?;
    }

    if let Some(github_trigger_type) = request.github_trigger_type {
        let trigger_str = match github_trigger_type {
            GitHubTriggerType::Push => "push",
            GitHubTriggerType::PullRequest => "pull_request",
        };
        sqlx::query!(
            "UPDATE workflows SET github_trigger_type = $1, updated_at = NOW() WHERE id = $2",
            trigger_str,
            workflow_id
        )
        .execute(&pool)
        .await
        .map_err(|e| {
            error!("Failed to update github_trigger_type: {}", e);
            (
                StatusCode::INTERNAL_SERVER_ERROR,
                "Failed to update workflow".to_string(),
            )
        })?;
    }

    let workflow = sqlx::query_as!(
        Workflow,
        "SELECT id, name, created_at, updated_at, github_trigger_type FROM workflows WHERE id = $1",
        workflow_id
    )
    .fetch_one(&pool)
    .await
    .map_err(|e| {
        error!("Failed to fetch workflow: {}", e);
        (
            StatusCode::INTERNAL_SERVER_ERROR,
            "Failed to fetch workflow".to_string(),
        )
    })?;

    Ok(Json(workflow))
}

#[utoipa::path(
    delete,
    path = "/workflows/{workflow_id}",
    responses(
        (status = 204, description = "Workflow deleted successfully"),
        (status = 404, description = "Specified workflow not found"),
        (status = 409, description = "Conflict: Workflow has dependent records"),
        (status = 500, description = "Internal server error")
    ),
    params(
        ("workflow_id" = i32, Path, description = "Workflow ID")
    )
)]
#[tracing::instrument(skip(pool))]
pub async fn delete_workflow(
    State(pool): State<PgPool>,
    Path(workflow_id): Path<i32>,
) -> Result<StatusCode, (StatusCode, String)> {
    let result = sqlx::query!("DELETE FROM workflows WHERE id = $1", workflow_id)
        .execute(&pool)
        .await;

    match result {
        Ok(res) if res.rows_affected() == 0 => {
            Err((StatusCode::NOT_FOUND, "Workflow not found".to_string()))
        }
        Ok(_) => Ok(StatusCode::NO_CONTENT),
        Err(e) => {
            if e.to_string().contains("foreign key") || e.to_string().contains("constraint") {
                Err((
                    StatusCode::CONFLICT,
                    "Cannot delete workflow with dependent records".to_string(),
                ))
            } else {
                error!("Failed to delete workflow: {}", e);
                Err((
                    StatusCode::INTERNAL_SERVER_ERROR,
                    "Failed to delete workflow".to_string(),
                ))
            }
        }
    }
}

#[cfg(test)]
mod tests {
    use crate::models::workflow::CreateWorkflowStepRequest;

    use super::*;

    #[sqlx::test]
    async fn test_post_workflow_push_trigger(pool: PgPool) {
        let request = CreateWorkflowRequest {
            name: "test-workflow".to_string(),
            github_trigger_type: GitHubTriggerType::Push,
            steps: vec![],
        };

        let result = post_workflow(State(pool), Json(request)).await;
        assert!(result.is_ok());

        let response = result.unwrap().0;
        let workflow = response.workflow;
        assert_eq!(workflow.name, "test-workflow");
        assert_eq!(workflow.github_trigger_type, GitHubTriggerType::Push);
        assert_eq!(response.steps.len(), 0);
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
            steps: vec![],
        };
        let workflow2 = CreateWorkflowRequest {
            name: "workflow-2".to_string(),
            github_trigger_type: GitHubTriggerType::PullRequest,
            steps: vec![],
        };
        let workflow3 = CreateWorkflowRequest {
            name: "workflow-3".to_string(),
            github_trigger_type: GitHubTriggerType::Push,
            steps: vec![],
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

        let workflows_with_steps_vec = get_result.unwrap().0;

        assert_eq!(workflows_with_steps_vec.len(), 3);

        let first_workflow = &workflows_with_steps_vec[0].workflow;
        let second_workflow = &workflows_with_steps_vec[1].workflow;
        let third_workflow = &workflows_with_steps_vec[2].workflow;

        assert_eq!(first_workflow.id, created_workflow3.workflow.id);
        assert_eq!(first_workflow.name, "workflow-3");
        assert_eq!(first_workflow.github_trigger_type, GitHubTriggerType::Push);
        assert_eq!(second_workflow.id, created_workflow2.workflow.id);
        assert_eq!(second_workflow.name, "workflow-2");
        assert_eq!(
            second_workflow.github_trigger_type,
            GitHubTriggerType::PullRequest
        );
        assert_eq!(third_workflow.id, created_workflow1.workflow.id);
        assert_eq!(third_workflow.name, "workflow-1");
        assert_eq!(third_workflow.github_trigger_type, GitHubTriggerType::Push);
    }

    #[sqlx::test]
    async fn test_get_workflow_by_workflow_id(pool: PgPool) {
        let demo_step = CreateWorkflowStepRequest {
            step_order: 0,
            name: "Flutter Build".to_string(),
            command: "echo \"Hello World\"".to_string(),
        };
        let request = CreateWorkflowRequest {
            name: "workflow".to_string(),
            github_trigger_type: GitHubTriggerType::Push,
            steps: vec![demo_step],
        };
        let result = post_workflow(State(pool.clone()), Json(request)).await;
        assert!(result.is_ok());
        let workflow_id = result.unwrap().0.workflow.id;

        let workflow_result = get_workflow(State(pool), Path(workflow_id)).await;
        assert!(workflow_result.is_ok());

        let workflow_with_steps = workflow_result.unwrap().0;
        let workflow = workflow_with_steps.workflow;

        assert_eq!(workflow.id, 1);
        assert_eq!(workflow.name, "workflow");
        assert_eq!(workflow.github_trigger_type, GitHubTriggerType::Push);

        let step = &workflow_with_steps.steps[0];
        assert_eq!(step.step_order, 0);
        assert_eq!(step.command, "echo \"Hello World\"");
        assert_eq!(step.name, "Flutter Build");
    }

    #[sqlx::test]
    async fn test_patch_workflow(pool: PgPool) {
        let request = CreateWorkflowRequest {
            name: "workflow".to_string(),
            github_trigger_type: GitHubTriggerType::Push,
            steps: vec![],
        };
        let result = post_workflow(State(pool.clone()), Json(request)).await;
        assert!(result.is_ok());

        let workflow_id = result.unwrap().0.workflow.id;

        let patch_request = UpdateWorkflowRequest {
            name: Some("updated_workflow".to_string()),
            github_trigger_type: None,
        };
        let patch_result =
            patch_workflow(State(pool), Path(workflow_id), Json(patch_request)).await;

        assert_eq!(patch_result.unwrap().0.name, "updated_workflow")
    }

    #[sqlx::test]
    async fn test_delete_workflow(pool: PgPool) {
        let request = CreateWorkflowRequest {
            name: "workflow".to_string(),
            github_trigger_type: GitHubTriggerType::Push,
            steps: vec![],
        };
        let result = post_workflow(State(pool.clone()), Json(request)).await;
        assert!(result.is_ok());
        let workflow_id = result.unwrap().0.workflow.id;

        assert!(delete_workflow(State(pool.clone()), Path(workflow_id))
            .await
            .is_ok());

        assert!(get_workflow(State(pool), Path(workflow_id)).await.is_err());
    }
    #[sqlx::test]
    async fn test_delete_workflow_not_found(pool: PgPool) {
        let res = delete_workflow(State(pool), Path(999_999)).await;
        assert!(res.is_err());
        let (status, _msg) = res.err().unwrap();
        assert_eq!(status, StatusCode::NOT_FOUND);
    }
}

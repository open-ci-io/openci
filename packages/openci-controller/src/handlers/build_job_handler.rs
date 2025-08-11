use axum::{extract::State, http::StatusCode, Json};
use sqlx::PgPool;
use tracing::error;

use crate::models::build_job::{BuildJob, BuildStatus, CreateBuildJobRequest};

#[utoipa::path(
    get,
    path = "/build-jobs",
    responses(
        (status = 200, description = "List of build jobs", body = [BuildJob]),
       (status = 500, description = "Internal server error")
    )
)]
#[tracing::instrument(skip(pool))]
pub async fn get_build_jobs(
    State(pool): State<PgPool>,
) -> Result<Json<Vec<BuildJob>>, (StatusCode, String)> {
    let build_jobs = sqlx::query_as::<_, BuildJob>("SELECT * FROM build_jobs")
        .fetch_all(&pool)
        .await
        .map_err(|e| {
            error!("Failed to fetch build jobs: {:?}", e);
            error!("Error details: {}", e);
            (
                StatusCode::INTERNAL_SERVER_ERROR,
                format!("Failed to fetch build jobs: {}", e),
            )
        })?;

    Ok(Json(build_jobs))
}

#[utoipa::path(
    post,
    path = "/build-jobs",
    request_body = CreateBuildJobRequest,
    responses(
        (status = 201, description = "Build job created successfully", body = BuildJob),
        (status = 400, description = "Invalid request"),
        (status = 500, description = "Internal server error")
    )
)]
#[tracing::instrument(skip(pool))]
pub async fn post_build_job(
    State(pool): State<PgPool>,
    Json(request): Json<CreateBuildJobRequest>,
) -> Result<(StatusCode, Json<BuildJob>), (StatusCode, String)> {
    let build_job = sqlx::query_as::<_, BuildJob>(
        r#"
        INSERT INTO build_jobs (
            workflow_id,
            repository_id,
            workflow_name,
            workflow_config,
            build_status,
            commit_sha,
            build_branch,
            base_branch,
            commit_message,
            commit_author_name,
            commit_author_email,
            pr_number,
            pr_title,
            github_check_run_id,
            github_app_id,
            github_installation_id
        ) VALUES (
            $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16
        )
        RETURNING *
        "#,
    )
    .bind(request.workflow_id)
    .bind(request.repository_id)
    .bind(request.workflow_name)
    .bind(request.workflow_config)
    .bind(BuildStatus::Queued)
    .bind(request.commit_sha)
    .bind(request.build_branch)
    .bind(request.base_branch)
    .bind(request.commit_message)
    .bind(request.commit_author_name)
    .bind(request.commit_author_email)
    .bind(request.pr_number)
    .bind(request.pr_title)
    .bind(request.github_check_run_id)
    .bind(request.github_app_id)
    .bind(request.github_installation_id)
    .fetch_one(&pool)
    .await
    .map_err(|e| {
        error!("Failed to create build job: {:?}", e);
        match e {
            sqlx::Error::Database(db_err) => {
                if db_err.code() == Some(std::borrow::Cow::from("23503")) {
                    (
                        StatusCode::BAD_REQUEST,
                        format!("Invalid repository_id or workflow_id"),
                    )
                } else {
                    (
                        StatusCode::INTERNAL_SERVER_ERROR,
                        format!("Database error: {}", db_err),
                    )
                }
            }
            _ => (
                StatusCode::INTERNAL_SERVER_ERROR,
                format!("Failed to create build job: {}", e),
            ),
        }
    })?;

    Ok((StatusCode::CREATED, Json(build_job)))
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::models::build_job::BuildStatus;
    use axum::extract::State;
    use serde_json::json;
    use sqlx::PgPool;

    #[sqlx::test(fixtures("../../fixtures/users.sql", "../../fixtures/build-jobs.sql"))]
    async fn test_get_build_jobs_returns_all_jobs(pool: PgPool) {
        let result = get_build_jobs(State(pool)).await;
        assert!(
            result.is_ok(),
            "Failed to get build jobs: {:?}",
            result.err()
        );
        let build_jobs = result.unwrap().0;

        assert_eq!(build_jobs.len(), 5);

        let statuses: Vec<BuildStatus> = build_jobs
            .iter()
            .map(|job| job.build_status.clone())
            .collect();

        assert!(statuses.contains(&BuildStatus::Queued));
        assert!(statuses.contains(&BuildStatus::InProgress));
        assert!(statuses.contains(&BuildStatus::Success));
        assert!(statuses.contains(&BuildStatus::Failure));
        assert!(statuses.contains(&BuildStatus::Cancelled));
    }

    #[sqlx::test(fixtures("../../fixtures/users.sql"))]
    async fn test_post_build_job_creates_new_job(pool: PgPool) {
        let user_id = sqlx::query_scalar!("SELECT id FROM users ORDER BY id LIMIT 1")
            .fetch_one(&pool.clone())
            .await
            .unwrap();

        let repo_id = sqlx::query_scalar!(
            "INSERT INTO repositories (user_id, owner, name, full_name, github_id, default_branch, created_at) 
             VALUES ($1, $2, $3, $4, $5, $6, NOW()) 
             RETURNING id",
            user_id,  // user_id を追加
            "test-owner",
            "test-repo",
            "test-owner/test-repo",
            123456i64,
            "main"
        )
        .fetch_one(&pool.clone())
        .await
        .unwrap();

        let request = CreateBuildJobRequest {
            workflow_id: None,
            repository_id: repo_id,
            workflow_name: Some("Test Workflow".to_string()),
            workflow_config: Some(json!({"key": "value"})),
            commit_sha: "0123456789abcdef0123456789abcdef01234567".to_string(),
            build_branch: "feature/test".to_string(),
            base_branch: "main".to_string(),
            commit_message: Some("Test commit message".to_string()),
            commit_author_name: Some("Test Author".to_string()),
            commit_author_email: Some("test@example.com".to_string()),
            pr_number: Some(42),
            pr_title: Some("Test PR".to_string()),
            github_check_run_id: 789012,
            github_app_id: 123,
            github_installation_id: 456,
        };

        let result = post_build_job(State(pool.clone()), Json(request)).await;

        assert!(
            result.is_ok(),
            "Failed to create build job: {:?}",
            result.err()
        );

        let (status_code, build_job) = result.unwrap();
        assert_eq!(status_code, StatusCode::CREATED);

        let build_job = build_job.0;
        assert!(build_job.id > 0);
        assert_eq!(build_job.repository_id, repo_id);
        assert_eq!(build_job.build_status, BuildStatus::Queued);
        assert_eq!(
            build_job.commit_sha,
            "0123456789abcdef0123456789abcdef01234567"
        );
        assert_eq!(build_job.build_branch, "feature/test");
        assert_eq!(build_job.base_branch, "main");
    }

    #[sqlx::test(fixtures("../../fixtures/users.sql"))]
    async fn test_post_build_job_rejects_invalid_commit_sha(pool: PgPool) {
        let user_id = sqlx::query_scalar!("SELECT id FROM users ORDER BY id LIMIT 1")
            .fetch_one(&pool.clone())
            .await
            .unwrap();

        let repo_id = sqlx::query_scalar!(
            "INSERT INTO repositories (user_id, owner, name, full_name, github_id, default_branch, created_at)
             VALUES ($1, $2, $3, $4, $5, $6, NOW()) RETURNING id",
            user_id, "o", "n", "o/n", 1_i64, "main"
        ).fetch_one(&pool.clone()).await.unwrap();

        let bad = CreateBuildJobRequest {
            workflow_id: None,
            repository_id: repo_id,
            workflow_name: Some("w".into()),
            workflow_config: Some(serde_json::json!({"k":"v"})),
            commit_sha: "abc123".into(), // invalid
            build_branch: "feature/x".into(),
            base_branch: "main".into(),
            commit_message: None,
            commit_author_name: None,
            commit_author_email: None,
            pr_number: None,
            pr_title: None,
            github_check_run_id: 1,
            github_app_id: 1,
            github_installation_id: 1,
        };

        let res = post_build_job(State(pool.clone()), Json(bad)).await;
        assert!(res.is_err());
        let (code, _) = res.err().unwrap();
        assert_eq!(code, StatusCode::BAD_REQUEST);
    }

    #[sqlx::test(fixtures("../../fixtures/users.sql"))]
    async fn test_post_build_job_rejects_empty_branch(pool: PgPool) {
        let user_id = sqlx::query_scalar!("SELECT id FROM users ORDER BY id LIMIT 1")
            .fetch_one(&pool.clone())
            .await
            .unwrap();

        let repo_id = sqlx::query_scalar!(
            "INSERT INTO repositories (user_id, owner, name, full_name, github_id, default_branch, created_at)
             VALUES ($1, $2, $3, $4, $5, $6, NOW()) RETURNING id",
            user_id, "o", "n", "o/n", 1_i64, "main"
        ).fetch_one(&pool.clone()).await.unwrap();

        let bad = CreateBuildJobRequest {
            workflow_id: None,
            repository_id: repo_id,
            workflow_name: None,
            workflow_config: None,
            commit_sha: "0123456789abcdef0123456789abcdef01234567".into(),
            build_branch: "  ".into(), // empty after trim
            base_branch: "".into(),
            commit_message: None,
            commit_author_name: None,
            commit_author_email: None,
            pr_number: None,
            pr_title: None,
            github_check_run_id: 1,
            github_app_id: 1,
            github_installation_id: 1,
        };

        let res = post_build_job(State(pool.clone()), Json(bad)).await;
        assert!(res.is_err());
        let (code, _) = res.err().unwrap();
        assert_eq!(code, StatusCode::BAD_REQUEST);
    }
}

use crate::models::build_job::BuildJob;
use crate::models::build_job::BuildStatus;
use crate::models::workflow::Workflow;
use axum::extract::Path;
use axum::extract::State;
use axum::http::StatusCode;
use axum::Json;
use sqlx::Error;
use sqlx::PgPool;
use tracing::error;

#[utoipa::path(
    get,
    path = "/build-jobs/{build_job_id}",
    responses(
          (status = 200, description = "Get a Build Job successfully"),
          (status = 404, description = "Build job not found"),
    ),
    params(("build_job_id" = i32, Path, description = "Build job ID")),
)]
pub async fn get_build_job(
    Path(build_job_id): Path<i32>,
    State(pool): State<PgPool>,
) -> Result<Json<BuildJob>, (StatusCode, String)> {
    let result = sqlx::query_as!(
        BuildJob,
        r#"
      SELECT
          id,
          workflow_id,
          status as "status: BuildStatus",
          created_at,
          updated_at,
          commit_sha,
          github_delivery_id
      FROM build_jobs
      WHERE id = $1
      "#,
        build_job_id,
    )
    .fetch_one(&pool)
    .await
    .map_err(|e| {
        error!("Failed to get a build job: {}", e);
        match e {
            Error::RowNotFound => (StatusCode::NOT_FOUND, "Failed to find a build job".into()),
            _ => (
                StatusCode::INTERNAL_SERVER_ERROR,
                "Failed to get a build job".into(),
            ),
        }
    })?;

    Ok(Json(result))
}

#[utoipa::path(
    get,
    path = "/build-jobs",
    responses(
          (status = 200, description = "List build jobs successfully"),
          (status = 500, description = "Internal server error")
    ),
     tag = "build-jobs"
)]
pub async fn get_build_jobs(
    State(pool): State<PgPool>,
) -> Result<Json<Vec<BuildJob>>, (StatusCode, String)> {
    let result = sqlx::query_as!(
        BuildJob,
        r#"
    SELECT
          id,
          workflow_id,
          status as "status: BuildStatus",
          created_at,
          updated_at,
          commit_sha,
          github_delivery_id
    FROM build_jobs
    "#,
    )
    .fetch_all(&pool)
    .await
    .map_err(|e| {
        error!("Failed to get build jobs: {}", e);
        (
            StatusCode::INTERNAL_SERVER_ERROR,
            "Failed to get build jobs".into(),
        )
    })?;

    Ok(Json(result))
}

pub async fn post_build_job(
    workflow_id: i32,
    commit_sha: String,
    github_delivery_id: String,
    pool: &PgPool,
) -> Result<(), (StatusCode, String)> {
    sqlx::query!(
        r#"
INSERT INTO build_jobs (workflow_id, commit_sha, github_delivery_id)
VALUES ($1, $2, $3)
"#,
        workflow_id,
        commit_sha,
        github_delivery_id
    )
    .execute(pool)
    .await
    .map_err(|e| {
        error!("Failed to create build job: {}", e);
        (
            StatusCode::INTERNAL_SERVER_ERROR,
            "Failed to create build job".into(),
        )
    })?;

    Ok(())
}

pub async fn post_build_jobs(
    workflows: &Vec<Workflow>,
    commit_sha: &str,
    github_delivery_id: &str,
    pool: &PgPool,
) -> Result<(), (StatusCode, String)> {
    for w in workflows.iter() {
        post_build_job(
            w.id,
            commit_sha.to_string(),
            github_delivery_id.to_string(),
            pool,
        )
        .await
        .map_err(|e| {
            error!("Failed to create build job: {}", e.1);
            (
                StatusCode::INTERNAL_SERVER_ERROR,
                "Failed to create build job".to_string(),
            )
        })?;
    }

    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;

    mod test_get_build_jobs {
        use super::*;
        use crate::handlers::github_repository_handler::post_github_repository;
        use crate::handlers::workflow_handler::post_workflow;
        use crate::models::workflow::{CreateWorkflowRequest, GitHubTriggerType};
        use axum::{extract::State, Json};
        use sqlx::PgPool;

        #[sqlx::test]
        async fn test_get_build_jobs_ok(pool: PgPool) {
            let repo = post_github_repository(50_001, &pool).await.unwrap();

            let workflow = post_workflow(
                State(pool.clone()),
                Json(CreateWorkflowRequest {
                    name: "get-jobs-ok".into(),
                    github_trigger_type: GitHubTriggerType::Push,
                    steps: vec![],
                    base_branch: "main".into(),
                    github_repository_id: repo.id,
                }),
            )
            .await
            .unwrap()
            .0
            .workflow;

            let commit_sha_one = "0123456789abcdef0123456789abcdef01234567";
            let commit_sha_two = "fedcba9876543210fedcba9876543210fedcba98";
            let delivery_one = "delivery-list-1";
            let delivery_two = "delivery-list-2";

            post_build_job(
                workflow.id,
                commit_sha_one.into(),
                delivery_one.into(),
                &pool,
            )
            .await
            .unwrap();

            post_build_job(
                workflow.id,
                commit_sha_two.into(),
                delivery_two.into(),
                &pool,
            )
            .await
            .unwrap();

            let jobs = get_build_jobs(State(pool.clone())).await.unwrap().0;

            assert_eq!(jobs.len(), 2);

            let mut deliveries: Vec<String> = jobs
                .iter()
                .map(|job| job.github_delivery_id.clone())
                .collect();
            deliveries.sort();
            assert_eq!(
                deliveries,
                vec![delivery_one.to_string(), delivery_two.to_string()]
            );

            let mut commit_shas: Vec<String> =
                jobs.iter().map(|job| job.commit_sha.clone()).collect();
            commit_shas.sort();
            assert_eq!(
                commit_shas,
                vec![commit_sha_one.to_string(), commit_sha_two.to_string()]
            );
        }
    }

    mod test_get_build_job {
        use super::*;
        use crate::handlers::github_repository_handler::post_github_repository;
        use crate::handlers::workflow_handler::post_workflow;
        use crate::models::build_job::BuildStatus;
        use crate::models::workflow::{CreateWorkflowRequest, GitHubTriggerType};
        use axum::{
            extract::{Path, State},
            http::StatusCode,
            Json,
        };
        use sqlx::PgPool;

        #[sqlx::test]
        async fn test_get_build_job_ok(pool: PgPool) {
            const EXTERNAL_ID: i64 = 1;
            let repo = post_github_repository(EXTERNAL_ID, &pool).await.unwrap();
            let workflow = post_workflow(
                State(pool.clone()),
                Json(CreateWorkflowRequest {
                    name: "get-job-ok".into(),
                    github_trigger_type: GitHubTriggerType::Push,
                    steps: vec![],
                    base_branch: "develop".into(),
                    github_repository_id: repo.id,
                }),
            )
            .await
            .unwrap()
            .0
            .workflow;

            let commit_sha = "0123456789abcdef0123456789abcdef01234567";
            let delivery = "delivery-get-ok";

            super::post_build_job(workflow.id, commit_sha.into(), delivery.into(), &pool)
                .await
                .unwrap();

            let build_job_id = sqlx::query!(
                "SELECT id FROM build_jobs WHERE workflow_id = $1 AND github_delivery_id = $2",
                workflow.id,
                delivery
            )
            .fetch_one(&pool)
            .await
            .unwrap()
            .id;

            let job = get_build_job(Path(build_job_id), State(pool.clone()))
                .await
                .unwrap()
                .0;

            assert_eq!(job.id, build_job_id);
            assert_eq!(job.workflow_id, workflow.id);
            assert_eq!(job.commit_sha, commit_sha);
            assert_eq!(job.github_delivery_id, delivery);
            assert_eq!(job.status, BuildStatus::Queued);
        }

        #[sqlx::test]
        async fn test_get_build_job_not_found(pool: PgPool) {
            let err = get_build_job(Path(99999), State(pool)).await.unwrap_err();
            assert_eq!(err.0, StatusCode::NOT_FOUND);
            assert!(err.1.contains("Failed to find a build job"));
        }
    }

    mod test_post_build_job {
        use crate::handlers::github_repository_handler::post_github_repository;
        use crate::handlers::workflow_handler::post_workflow;
        use crate::models::workflow::{CreateWorkflowRequest, GitHubTriggerType};
        use axum::http::StatusCode;
        use axum::{extract::State, Json};
        use sqlx::PgPool;

        #[sqlx::test]
        async fn test_post_build_job_inserts_one(pool: PgPool) {
            let repo = post_github_repository(1001, &pool).await.unwrap();
            let req = CreateWorkflowRequest {
                name: "w1".into(),
                github_trigger_type: GitHubTriggerType::Push,
                steps: vec![],
                base_branch: "develop".into(),
                github_repository_id: repo.id,
            };
            let w = post_workflow(State(pool.clone()), Json(req))
                .await
                .unwrap()
                .0
                .workflow;

            let commit_sha = "0123456789abcdef0123456789abcdef01234567";
            let delivery = "delivery-ok";

            super::post_build_job(w.id, commit_sha.into(), delivery.into(), &pool)
                .await
                .unwrap();

            let row = sqlx::query!(
            "SELECT workflow_id, commit_sha, github_delivery_id, status FROM build_jobs WHERE workflow_id=$1 AND github_delivery_id=$2",
            w.id, delivery
        )
                .fetch_one(&pool)
                .await
                .unwrap();

            assert_eq!(row.workflow_id, w.id);
            assert_eq!(row.commit_sha, commit_sha);
            assert_eq!(row.github_delivery_id, delivery);
            assert_eq!(row.status, "queued");
        }

        #[sqlx::test]
        async fn test_post_build_job_duplicate_conflict(pool: PgPool) {
            let repo = post_github_repository(1002, &pool).await.unwrap();
            let req = CreateWorkflowRequest {
                name: "demo workflow".into(),
                github_trigger_type: GitHubTriggerType::Push,
                steps: vec![],
                base_branch: "develop".into(),
                github_repository_id: repo.id,
            };
            let w = post_workflow(State(pool.clone()), Json(req))
                .await
                .unwrap()
                .0
                .workflow;

            let commit_sha = "0123456789abcdef0123456789abcdef01234567";
            let delivery = "delivery-dup";

            super::post_build_job(w.id, commit_sha.into(), delivery.into(), &pool)
                .await
                .unwrap();

            let err = super::post_build_job(w.id, commit_sha.into(), delivery.into(), &pool)
                .await
                .unwrap_err();
            assert_eq!(err.0, StatusCode::INTERNAL_SERVER_ERROR);
            assert!(err.1.contains("Failed to create build job"));
        }

        #[sqlx::test]
        async fn test_post_build_job_fk_violation(pool: PgPool) {
            let commit_sha = "0123456789abcdef0123456789abcdef01234567";
            let delivery = "delivery-fk";
            let res =
                super::post_build_job(9_999_999, commit_sha.into(), delivery.into(), &pool).await;
            assert!(res.is_err());
            let (status, msg) = res.unwrap_err();
            assert_eq!(status, StatusCode::INTERNAL_SERVER_ERROR);
            assert!(msg.contains("Failed to create build job"));
        }
    }

    mod test_post_build_jobs {
        use crate::handlers::build_job_handler::post_build_jobs;
        use crate::handlers::github_repository_handler::post_github_repository;
        use crate::handlers::workflow_handler::post_workflow;
        use crate::models::workflow::{CreateWorkflowRequest, GitHubTriggerType};
        use axum::{extract::State, Json};
        use sqlx::PgPool;

        #[sqlx::test]
        async fn test_post_build_jobs_inserts_multiple(pool: PgPool) {
            let repo = post_github_repository(2001, &pool).await.unwrap();

            let req1 = CreateWorkflowRequest {
                name: "w1".into(),
                github_trigger_type: GitHubTriggerType::Push,
                steps: vec![],
                base_branch: "develop".into(),
                github_repository_id: repo.id,
            };
            let w1 = post_workflow(State(pool.clone()), Json(req1))
                .await
                .unwrap()
                .0
                .workflow;

            let req2 = CreateWorkflowRequest {
                name: "w2".into(),
                github_trigger_type: GitHubTriggerType::Push,
                steps: vec![],
                base_branch: "develop".into(),
                github_repository_id: repo.id,
            };
            let w2 = post_workflow(State(pool.clone()), Json(req2))
                .await
                .unwrap()
                .0
                .workflow;

            let workflows = vec![w1, w2];
            let commit_sha = "0123456789abcdef0123456789abcdef01234567";
            let delivery = "delivery-multi-ok";

            post_build_jobs(&workflows, commit_sha, delivery, &pool)
                .await
                .unwrap();

            let rows = sqlx::query!(
    "SELECT workflow_id, commit_sha, github_delivery_id FROM build_jobs WHERE github_delivery_id = $1 ORDER BY workflow_id",
    delivery
    )
            .fetch_all(&pool)
            .await
            .unwrap();

            assert_eq!(rows.len(), 2);
            assert_eq!(rows[0].commit_sha, commit_sha);
            assert_eq!(rows[0].github_delivery_id, delivery);
            assert_eq!(rows[1].commit_sha, commit_sha);
            assert_eq!(rows[1].github_delivery_id, delivery);
        }
    }
}

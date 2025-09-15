use crate::handlers::workflow_handler::get_workflows_by_github_trigger_type;
use crate::models::workflow::{GitHubTriggerType, Workflow};
use axum::extract::State;
use axum::{
    body::Bytes,
    http::{HeaderMap, StatusCode},
};
use octocrab::models::webhook_events::{WebhookEvent, WebhookEventType};
use serde_json::Value;
use sqlx::PgPool;
use tracing::error;
use uuid::Uuid;

#[utoipa::path(
    post,
    path = "/webhooks/github",
    responses(
          (status = 200, description = "Webhook processed successfully"),
          (status = 401, description = "Invalid signature"),
          (status = 500, description = "Internal server error")
    ),
    tag = "webhooks"
)]
pub async fn post_github_webhook_handler(
    State(pool): State<PgPool>,
    headers: HeaderMap,
    body: Bytes,
) -> Result<StatusCode, (StatusCode, String)> {
    let event_header = headers
        .get("x-github-event")
        .and_then(|v| v.to_str().ok())
        .ok_or((
            StatusCode::BAD_REQUEST,
            "Missing or invalid X-GitHub-Event header".to_string(),
        ))?;

    let event = WebhookEvent::try_from_header_and_body(event_header, &body).map_err(|e| {
        (
            StatusCode::BAD_REQUEST,
            format!("Failed to parse webhook event: {}", e),
        )
    })?;

    let trigger_type = match event.kind {
        WebhookEventType::Push => GitHubTriggerType::Push,
        WebhookEventType::PullRequest => GitHubTriggerType::PullRequest,
        _ => return Ok(StatusCode::OK),
    };

    let workflows = get_workflows_by_github_trigger_type(State(&pool), &trigger_type).await?;

    if workflows.is_empty() {
        return Ok(StatusCode::OK);
    }

    let github_delivery_id = github_delivery_id(&headers)?;

    let json_body: Value = serde_json::from_slice(&body).map_err(|e| {
        (
            StatusCode::BAD_REQUEST,
            format!("Failed to parse JSON body: {}", e),
        )
    })?;

    let commit_sha = commit_sha(trigger_type, &json_body)?;

    post_build_jobs(&workflows, commit_sha, github_delivery_id, &pool).await?;

    Ok(StatusCode::OK)
}

fn commit_sha(trigger_type: GitHubTriggerType, json: &Value) -> Result<&str, (StatusCode, String)> {
    let commit_sha = match trigger_type {
        GitHubTriggerType::PullRequest => json["pull_request"]["head"]["sha"].as_str(),
        GitHubTriggerType::Push => json["after"].as_str(),
    }
    .ok_or((
        StatusCode::BAD_REQUEST,
        "Missing or invalid commit SHA".to_string(),
    ))?;

    Ok(commit_sha)
}

async fn post_build_jobs(
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

fn github_delivery_id(headers: &HeaderMap) -> Result<&str, (StatusCode, String)> {
    const HDR_DELIVERY: &str = "x-github-delivery";

    let value = headers.get(HDR_DELIVERY).ok_or_else(|| {
        (
            StatusCode::BAD_REQUEST,
            "Missing or invalid X-GitHub-Delivery header".to_string(),
        )
    })?;

    let s = value.to_str().map_err(|e| {
        (
            StatusCode::BAD_REQUEST,
            format!("Failed to parse X-GitHub-Delivery header: {}", e),
        )
    })?;

    if Uuid::parse_str(s).is_err() {
        return Err((
            StatusCode::BAD_REQUEST,
            "Missing or invalid X-GitHub-Delivery header".to_string(),
        ));
    }

    Ok(s)
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

#[cfg(test)]
mod tests {
    use super::*;
    use axum::http::HeaderValue;

    const PR_PAYLOAD: &str = include_str!("../../tests/fixtures/github/pr_opened.json");
    const PUSH_PAYLOAD: &str = include_str!("../../tests/fixtures/github/push.json");
    const STAR_PAYLOAD: &str = include_str!("../../tests/fixtures/github/star.json");

    mod post_build_job {
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
                name: "wdup".into(),
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

    mod post_build_jobs {
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

            super::post_build_jobs(&workflows, commit_sha, delivery, &pool)
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

    mod test_commit_sha {
        use crate::handlers::github_webhook_handler::commit_sha;
        use crate::models::workflow::GitHubTriggerType;
        use axum::http::StatusCode;
        use serde_json::{json, Value};

        const DEMO_COMMIT_SHA: &str = "0123456789abcdef0123456789abcdef01234567";
        const WRONG_TYPE_COMMIT_SHA: i32 = 1234567890;
        const ERROR_MSG: &str = "Missing or invalid commit SHA";

        mod push {
            use super::*;
            use crate::handlers::github_webhook_handler::tests::PUSH_PAYLOAD;
            #[test]
            fn test_commit_sha_push_ok() {
                let v = json!({ "after": DEMO_COMMIT_SHA });
                let sha = commit_sha(GitHubTriggerType::Push, &v).unwrap();
                assert_eq!(sha, DEMO_COMMIT_SHA);
            }

            #[test]
            fn test_commit_sha_push_wrong_type() {
                let v = json!({ "after": WRONG_TYPE_COMMIT_SHA });
                let (status, msg) = commit_sha(GitHubTriggerType::Push, &v).unwrap_err();
                assert_eq!(status, StatusCode::BAD_REQUEST);
                assert!(msg.contains(ERROR_MSG));
            }

            #[test]
            fn test_commit_sha_push_failed() {
                let v = json!({});
                let (status, msg) = commit_sha(GitHubTriggerType::Push, &v).unwrap_err();
                assert_eq!(status, StatusCode::BAD_REQUEST);
                assert!(msg.contains(ERROR_MSG));
            }

            #[test]
            fn test_commit_sha_push_fixture_ok() {
                let v: Value = serde_json::from_str(PUSH_PAYLOAD).unwrap();
                let sha = commit_sha(GitHubTriggerType::Push, &v).unwrap();
                assert_eq!(sha.len(), 40);
                assert!(sha.chars().all(|c| c.is_ascii_hexdigit()));
            }
        }

        mod pull_request {
            use super::*;
            use crate::handlers::github_webhook_handler::tests::PR_PAYLOAD;

            #[test]
            fn test_commit_sha_pr_ok() {
                let v = json!({"pull_request":{
                    "head": {"sha":DEMO_COMMIT_SHA}
                }});
                let sha = commit_sha(GitHubTriggerType::PullRequest, &v).unwrap();
                assert_eq!(sha, DEMO_COMMIT_SHA);
            }
            #[test]
            fn test_commit_sha_pr_missing_sha() {
                let v = json!({"pull_request": { "head": {} }});
                let (status, msg) = commit_sha(GitHubTriggerType::PullRequest, &v).unwrap_err();
                assert_eq!(status, StatusCode::BAD_REQUEST);
                assert!(msg.contains(ERROR_MSG));
            }

            #[test]
            fn test_commit_sha_pr_wrong_type() {
                let v = json!({"pull_request": { "head": { "sha": WRONG_TYPE_COMMIT_SHA } }});
                let (status, msg) = commit_sha(GitHubTriggerType::PullRequest, &v).unwrap_err();
                assert_eq!(status, StatusCode::BAD_REQUEST);
                assert!(msg.contains(ERROR_MSG));
            }

            #[test]
            fn test_commit_sha_pr_failed() {
                let v = json!({});
                let (status, msg) = commit_sha(GitHubTriggerType::PullRequest, &v).unwrap_err();
                assert_eq!(status, StatusCode::BAD_REQUEST);
                assert!(msg.contains(ERROR_MSG));
            }

            #[test]
            fn test_commit_sha_pr_fixture_ok() {
                let v: Value = serde_json::from_str(PR_PAYLOAD).unwrap();
                let sha = commit_sha(GitHubTriggerType::PullRequest, &v).unwrap();
                assert_eq!(sha.len(), 40);
                assert!(sha.chars().all(|c| c.is_ascii_hexdigit()));
            }
        }
    }

    mod test_github_delivery_id {
        use crate::handlers::github_webhook_handler::github_delivery_id;
        use axum::http::{HeaderMap, HeaderValue, StatusCode};

        const HDR: &str = "x-github-delivery";

        #[test]
        fn ok_uuid() {
            let mut h = HeaderMap::new();
            let v = "123e4567-e89b-12d3-a456-426614174000";
            h.insert(HDR, HeaderValue::from_static(v));
            assert_eq!(github_delivery_id(&h).unwrap(), v);
        }

        #[test]
        fn missing() {
            let h = HeaderMap::new();
            let (st, _) = github_delivery_id(&h).unwrap_err();
            assert_eq!(st, StatusCode::BAD_REQUEST);
        }

        #[test]
        fn non_utf8() {
            let mut h = HeaderMap::new();
            h.insert(HDR, HeaderValue::from_bytes(b"\xFF\xFE").unwrap());
            let (st, _) = github_delivery_id(&h).unwrap_err();
            assert_eq!(st, StatusCode::BAD_REQUEST);
        }

        #[test]
        fn empty_or_whitespace() {
            let mut h = HeaderMap::new();
            h.insert(HDR, HeaderValue::from_static(""));
            assert_eq!(
                github_delivery_id(&h).unwrap_err().0,
                StatusCode::BAD_REQUEST
            );

            let mut h2 = HeaderMap::new();
            h2.insert(HDR, HeaderValue::from_static("   "));
            assert_eq!(
                github_delivery_id(&h2).unwrap_err().0,
                StatusCode::BAD_REQUEST
            );
        }

        #[test]
        fn too_long() {
            let mut h = HeaderMap::new();
            let long = "a".repeat(65);
            h.insert(HDR, HeaderValue::from_str(&long).unwrap());
            assert_eq!(
                github_delivery_id(&h).unwrap_err().0,
                StatusCode::BAD_REQUEST
            );
        }
    }

    mod test_post_github_webhook_handler {
        use super::*;
        use crate::handlers::github_repository_handler::post_github_repository;
        use crate::handlers::workflow_handler::post_workflow;
        use crate::models::workflow::{CreateWorkflowRequest, GitHubTriggerType};
        use axum::Json;

        fn new_delivery_id() -> HeaderValue {
            HeaderValue::from_str(&Uuid::new_v4().to_string()).unwrap()
        }

        #[sqlx::test]
        async fn push_event_creates_build_job(pool: PgPool) {
            let repo = post_github_repository(1001, &pool).await.unwrap();
            let req = CreateWorkflowRequest {
                name: "wf-push".into(),
                github_trigger_type: GitHubTriggerType::Push,
                steps: vec![],
                base_branch: "main".into(),
                github_repository_id: repo.id,
            };
            let _ = post_workflow(State(pool.clone()), Json(req)).await.unwrap();

            let mut headers = HeaderMap::new();
            headers.insert("x-github-event", HeaderValue::from_static("push"));
            let delivery = new_delivery_id();
            headers.insert("x-github-delivery", delivery.clone());

            let body = Bytes::from(PUSH_PAYLOAD);
            let res = post_github_webhook_handler(State(pool.clone()), headers, body).await;
            assert_eq!(res.unwrap(), StatusCode::OK);

            let row = sqlx::query!(
                "SELECT count(*) as count FROM build_jobs WHERE github_delivery_id = $1",
                delivery.to_str().unwrap()
            )
            .fetch_one(&pool)
            .await
            .unwrap();
            assert_eq!(row.count.unwrap_or(0), 1);
        }

        #[sqlx::test]
        async fn pull_request_event_creates_build_job(pool: PgPool) {
            let repo = post_github_repository(2002, &pool).await.unwrap();
            let req = CreateWorkflowRequest {
                name: "wf-pr".into(),
                github_trigger_type: GitHubTriggerType::PullRequest,
                steps: vec![],
                base_branch: "main".into(),
                github_repository_id: repo.id,
            };
            let _ = post_workflow(State(pool.clone()), Json(req)).await.unwrap();

            let mut headers = HeaderMap::new();
            headers.insert("x-github-event", HeaderValue::from_static("pull_request"));
            let delivery = new_delivery_id();
            headers.insert("x-github-delivery", delivery.clone());

            let body = Bytes::from(PR_PAYLOAD);
            let res = post_github_webhook_handler(State(pool.clone()), headers, body).await;
            assert_eq!(res.unwrap(), StatusCode::OK);

            let row = sqlx::query!(
                "SELECT count(*) as count FROM build_jobs WHERE github_delivery_id = $1",
                delivery.to_str().unwrap()
            )
            .fetch_one(&pool)
            .await
            .unwrap();
            assert_eq!(row.count.unwrap_or(0), 1);
        }

        #[sqlx::test]
        async fn duplicate_delivery_id_returns_error(pool: PgPool) {
            let repo = post_github_repository(3003, &pool).await.unwrap();
            let req = CreateWorkflowRequest {
                name: "wf-push-dup".into(),
                github_trigger_type: GitHubTriggerType::Push,
                steps: vec![],
                base_branch: "main".into(),
                github_repository_id: repo.id,
            };
            let _ = post_workflow(State(pool.clone()), Json(req)).await.unwrap();

            let mut headers = HeaderMap::new();
            headers.insert("x-github-event", HeaderValue::from_static("push"));
            let delivery = new_delivery_id();
            headers.insert("x-github-delivery", delivery.clone());
            let body = Bytes::from(PUSH_PAYLOAD);

            let ok =
                post_github_webhook_handler(State(pool.clone()), headers.clone(), body.clone())
                    .await;
            assert_eq!(ok.unwrap(), StatusCode::OK);

            let err = post_github_webhook_handler(State(pool.clone()), headers, body).await;
            assert!(err.is_err());
            let (st, _msg) = err.err().unwrap();
            assert_eq!(st, StatusCode::INTERNAL_SERVER_ERROR);
        }
    }

    #[sqlx::test]
    async fn test_missing_event_header(pool: PgPool) {
        let headers = HeaderMap::new();
        let body = Bytes::from("{}");
        let result = post_github_webhook_handler(State(pool), headers, body).await;

        assert!(result.is_err());
        let (status, msg) = result.unwrap_err();
        assert_eq!(status, StatusCode::BAD_REQUEST);
        assert!(msg.contains("X-GitHub-Event"));
    }

    #[sqlx::test]
    async fn test_push_event(pool: PgPool) {
        let mut headers = HeaderMap::new();
        headers.insert("x-github-event", HeaderValue::from_static("push"));

        let body = Bytes::from(PUSH_PAYLOAD);
        let result = post_github_webhook_handler(State(pool), headers, body).await;
        assert_eq!(result.unwrap(), StatusCode::OK);
    }

    #[sqlx::test]
    async fn test_pull_request_event(pool: PgPool) {
        let mut headers = HeaderMap::new();
        headers.insert("x-github-event", HeaderValue::from_static("pull_request"));

        let body = Bytes::from(PR_PAYLOAD);
        let result = post_github_webhook_handler(State(pool), headers, body).await;
        assert_eq!(result.unwrap(), StatusCode::OK);
    }

    #[sqlx::test]
    async fn test_unknown_event(pool: PgPool) {
        let mut headers = HeaderMap::new();
        headers.insert("x-github-event", HeaderValue::from_static("star"));

        let body = Bytes::from(STAR_PAYLOAD);

        let result = post_github_webhook_handler(State(pool), headers, body).await;
        assert_eq!(result.unwrap(), StatusCode::OK);
    }

    #[sqlx::test]
    async fn test_invalid_header_encoding(pool: PgPool) {
        let mut headers = HeaderMap::new();
        let body = Bytes::from("{}");

        headers.insert(
            "x-github-event",
            HeaderValue::from_bytes(b"\xFF\xFE").unwrap(),
        );

        let result = post_github_webhook_handler(State(pool), headers, body).await;
        assert!(result.is_err());
    }

    #[sqlx::test]
    async fn test_invalid_json_body(pool: PgPool) {
        let mut headers = HeaderMap::new();
        headers.insert("x-github-event", HeaderValue::from_static("push"));

        let body = Bytes::from("not json");

        let result = post_github_webhook_handler(State(pool), headers, body).await;
        assert!(result.is_err());
        let (status, msg) = result.unwrap_err();
        assert_eq!(status, StatusCode::BAD_REQUEST);
        assert!(msg.contains("Failed to parse"));
    }
}

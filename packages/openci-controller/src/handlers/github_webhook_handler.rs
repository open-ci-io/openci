use crate::handlers::workflow_handler::get_workflows_by_github_trigger_type;
use crate::models::workflow::GitHubTriggerType;
use axum::extract::State;
use axum::{
    body::Bytes,
    http::{HeaderMap, StatusCode},
};
use octocrab::models::webhook_events::{WebhookEvent, WebhookEventType};
use sqlx::PgPool;
use tracing::error;

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

    let workflows = get_workflows_by_github_trigger_type(State(&pool), &trigger_type)
        .await
        .map_err(|e| {
            error!("Database error: {}", e.1);
            (
                StatusCode::INTERNAL_SERVER_ERROR,
                "Failed to fetch workflows".to_string(),
            )
        })?;

    if workflows.is_empty() {
        return Ok(StatusCode::OK);
    }

    let github_delivery_id = headers
        .get("x-github-delivery")
        .ok_or_else(|| {
            (
                StatusCode::BAD_REQUEST,
                "Missing or invalid X-GitHub-Delivery header".to_string(),
            )
        })?
        .to_str()
        .map_err(|e| {
            (
                StatusCode::BAD_REQUEST,
                format!("Failed to parse X-GitHub-Delivery header: {}", e),
            )
        })?
        .to_string();

    let json_body: serde_json::Value = serde_json::from_slice(&body)
        .map_err(|e| (StatusCode::BAD_REQUEST, format!("Invalid JSON: {}", e)))?;

    let commit_sha = match trigger_type {
        GitHubTriggerType::PullRequest => &json_body["pull_request"]["head"]["sha"],
        GitHubTriggerType::Push => &json_body["after"],
    };

    for w in workflows.iter() {
        post_build_job(
            w.id,
            commit_sha.to_string(),
            github_delivery_id.clone(),
            &pool,
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

    Ok(StatusCode::OK)
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

use axum::{
    body::Bytes,
    http::{HeaderMap, StatusCode},
};
use octocrab::models::webhook_events::{WebhookEvent, WebhookEventType};

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

    match event.kind {
        WebhookEventType::Push => {}
        WebhookEventType::PullRequest => {}
        // ...
        _ => {}
    };
    Ok(StatusCode::OK)
}

#[cfg(test)]
mod tests {
    use super::*;
    use axum::http::HeaderValue;

    const PR_PAYLOAD: &str = include_str!("../../tests/fixtures/github/pr_opened.json");
    const PUSH_PAYLOAD: &str = include_str!("../../tests/fixtures/github/push.json");
    const STAR_PAYLOAD: &str = include_str!("../../tests/fixtures/github/star.json");

    #[tokio::test]
    async fn test_missing_event_header() {
        let headers = HeaderMap::new();
        let body = Bytes::from("{}");
        let result = post_github_webhook_handler(headers, body).await;

        assert!(result.is_err());
        let (status, msg) = result.unwrap_err();
        assert_eq!(status, StatusCode::BAD_REQUEST);
        assert!(msg.contains("X-GitHub-Event"));
    }

    #[tokio::test]
    async fn test_push_event() {
        let mut headers = HeaderMap::new();
        headers.insert("x-github-event", HeaderValue::from_static("push"));

        let body = Bytes::from(PUSH_PAYLOAD);
        let result = post_github_webhook_handler(headers, body).await;
        assert_eq!(result.unwrap(), StatusCode::OK);
    }

    #[tokio::test]
    async fn test_pull_request_event() {
        let mut headers = HeaderMap::new();
        headers.insert("x-github-event", HeaderValue::from_static("pull_request"));

        let body = Bytes::from(PR_PAYLOAD);
        let result = post_github_webhook_handler(headers, body).await;
        assert_eq!(result.unwrap(), StatusCode::OK);
    }

    #[tokio::test]
    async fn test_unknown_event() {
        let mut headers = HeaderMap::new();
        headers.insert("x-github-event", HeaderValue::from_static("star"));

        let body = Bytes::from(STAR_PAYLOAD);

        let result = post_github_webhook_handler(headers, body).await;
        assert_eq!(result.unwrap(), StatusCode::OK);
    }

    #[tokio::test]
    async fn test_invalid_header_encoding() {
        let mut headers = HeaderMap::new();
        let body = Bytes::from("{}");

        headers.insert(
            "x-github-event",
            HeaderValue::from_bytes(b"\xFF\xFE").unwrap(),
        );

        let result = post_github_webhook_handler(headers, body).await;
        assert!(result.is_err());
    }

    #[tokio::test]
    async fn test_invalid_json_body() {
        let mut headers = HeaderMap::new();
        headers.insert("x-github-event", HeaderValue::from_static("push"));

        // 不正なJSON
        let body = Bytes::from("not json");

        let result = post_github_webhook_handler(headers, body).await;
        assert!(result.is_err());
        let (status, msg) = result.unwrap_err();
        assert_eq!(status, StatusCode::BAD_REQUEST);
        assert!(msg.contains("Failed to parse"));
    }
}

use axum::http::{HeaderMap, StatusCode};

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
) -> Result<StatusCode, (StatusCode, String)> {
    let event_type = headers
        .get("x-github-event")
        .and_then(|v| v.to_str().ok())
        .ok_or((
            StatusCode::BAD_REQUEST,
            "Missing or invalid X-GitHub-Event header".to_string(),
        ))?;

    match event_type {
        "push" => {}
        "pull_request" => {}
        _ => return Ok(StatusCode::OK),
    }
    Ok(StatusCode::OK)
}

#[cfg(test)]
mod tests {
    use super::*;
    use axum::http::HeaderValue;

    #[tokio::test]
    async fn test_missing_event_header() {
        let headers = HeaderMap::new();
        let result = post_github_webhook_handler(headers).await;

        assert!(result.is_err());
        let (status, msg) = result.unwrap_err();
        assert_eq!(status, StatusCode::BAD_REQUEST);
        assert!(msg.contains("X-GitHub-Event"));
    }

    #[tokio::test]
    async fn test_push_event() {
        let mut headers = HeaderMap::new();
        headers.insert("x-github-event", HeaderValue::from_static("push"));

        let result = post_github_webhook_handler(headers).await;
        assert_eq!(result.unwrap(), StatusCode::OK);
    }

    #[tokio::test]
    async fn test_pull_request_event() {
        let mut headers = HeaderMap::new();
        headers.insert("x-github-event", HeaderValue::from_static("pull_request"));

        let result = post_github_webhook_handler(headers).await;
        assert_eq!(result.unwrap(), StatusCode::OK);
    }

    #[tokio::test]
    async fn test_unknown_event() {
        let mut headers = HeaderMap::new();
        headers.insert("x-github-event", HeaderValue::from_static("star"));

        let result = post_github_webhook_handler(headers).await;
        assert_eq!(result.unwrap(), StatusCode::OK);
    }

    #[tokio::test]
    async fn test_invalid_header_encoding() {
        let mut headers = HeaderMap::new();
        headers.insert(
            "x-github-event",
            HeaderValue::from_bytes(b"\xFF\xFE").unwrap(),
        );

        let result = post_github_webhook_handler(headers).await;
        assert!(result.is_err());
    }
}

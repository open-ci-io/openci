use axum::http::StatusCode;

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
pub async fn post_github_webhook_handler() -> Result<StatusCode, (StatusCode, String)> {
    Ok(StatusCode::OK)
}

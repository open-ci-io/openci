mod github;

use crate::github::verify_hmac_signature;
use axum::extract::State;
use axum::http::HeaderMap;
use axum::routing::post;
use axum::{routing::get, Router};
use tower_service::Service;
use worker::*;

#[derive(Clone)]
pub struct AppState {
    github_webhook_secret: String,
}

fn router(state: AppState) -> Router<()> {
    Router::new()
        .route("/", get(root))
        .route("/github/webhook", post(github_webhook))
        .with_state(state)
}

#[event(fetch)]
async fn fetch(
    req: HttpRequest,
    _env: Env,
    _ctx: Context,
) -> Result<axum::http::Response<axum::body::Body>> {
    let state = AppState {
        github_webhook_secret: _env.secret("GITHUB_APP_WEBHOOK_SECRET")?.to_string(),
    };

    let mut app = router(state);
    Ok(app.call(req).await?)
}

pub async fn root() -> &'static str {
    "ようこそ、OpenCIランナーへ!"
}

pub async fn github_webhook(
    State(state): State<AppState>,
    headers: HeaderMap,
    body: String,
) -> HeaderMap {
    console_log!("github_webhook header = {:?}", headers);

    let github_webhook_signature = &headers["X-Hub-Signature-256"];
    console_log!("github_webhook_signature = {:?}", github_webhook_signature);

    let is_valid_signature = verify_hmac_signature(
        github_webhook_signature.as_bytes(),
        state.github_webhook_secret,
        body.as_bytes(),
    );
    console_log!("is_valid_signature = {:?}", is_valid_signature);

    headers
}

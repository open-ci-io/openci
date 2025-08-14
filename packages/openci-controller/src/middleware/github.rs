use axum::{
    body::to_bytes, extract::Request, http::StatusCode, middleware::Next, response::Response,
};
use hmac::{Hmac, Mac};
use sha2::Sha256;
use std::env;

const MAX_WEBHOOK_SIZE: usize = 1_048_576; // 1 MiB

type HmacSha256 = Hmac<Sha256>;

pub async fn verify_github_webhook(request: Request, next: Next) -> Result<Response, StatusCode> {
    let (parts, body) = request.into_parts();
    let headers = &parts.headers;

    let signature = match headers
        .get("X-Hub-Signature-256")
        .and_then(|s| s.to_str().ok())
    {
        Some(s) => s,
        None => return Err(StatusCode::UNAUTHORIZED),
    };

    let body_bytes = to_bytes(body, MAX_WEBHOOK_SIZE)
        .await
        .map_err(|_| StatusCode::PAYLOAD_TOO_LARGE)?;

    if verify_signature(signature, &body_bytes).is_err() {
        return Err(StatusCode::UNAUTHORIZED);
    }

    let request = Request::from_parts(parts, axum::body::Body::from(body_bytes));
    Ok(next.run(request).await)
}

fn verify_signature(signature: &str, body: &[u8]) -> Result<(), ()> {
    let secret = env::var("GITHUB_WEBHOOK_SECRET").map_err(|_| ())?;
    let mut mac = HmacSha256::new_from_slice(secret.as_bytes()).map_err(|_| ())?;
    mac.update(body);

    let expected_signature = format!("sha256={}", hex::encode(mac.finalize().into_bytes()));

    if signature != expected_signature {
        return Err(());
    }

    Ok(())
}

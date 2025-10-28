use axum::extract::State;
use axum::http::HeaderMap;
use axum::{routing::get, Router};
use sha2::Sha256;
use tower_service::Service;
use worker::*;

use hmac::{Hmac, Mac};

#[derive(Clone)]
pub struct AppState {
    github_webhook_secret: String,
}

fn router(state: AppState) -> Router<()> {
    Router::new()
        .route("/", get(root))
        .route("/github/webhook", get(github_webhook))
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

type HmacSha256 = Hmac<Sha256>;

fn verify_hmac_signature(signature: &[u8], secret: String, body: &[u8]) -> bool {
    let mut mac = match HmacSha256::new_from_slice(secret.as_bytes()) {
        Ok(mac) => mac,
        Err(_) => return false,
    };

    mac.update(body);

    mac.verify_slice(signature).is_ok()
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn verify_signature_accepts_matching_payload() {
        let secret = "demo_secret".to_string();
        let payload = br#"{"hello":"world"}"#;

        let mut mac = HmacSha256::new_from_slice(secret.as_bytes()).unwrap();
        mac.update(payload);
        let signature = mac.finalize().into_bytes();

        assert!(verify_hmac_signature(&signature, secret.clone(), payload));
    }

    #[test]
    fn verify_signature_rejects_tampered_payload() {
        let secret = "demo_secret".to_string();
        let payload = br#"{"hello":"world"}"#;

        let mut mac = HmacSha256::new_from_slice(secret.as_bytes()).unwrap();
        mac.update(payload);
        let signature = mac.finalize().into_bytes();

        let tampered_payload = br#"{"hello":"mars"}"#;
        assert!(!verify_hmac_signature(
            &signature,
            secret.clone(),
            tampered_payload
        ));
    }

    #[test]
    fn verify_signature_rejects_tampered_secret() {
        let secret = "demo_secret".to_string();
        let payload = br#"{"hello":"world"}"#;

        let mut mac = HmacSha256::new_from_slice(secret.as_bytes()).unwrap();
        mac.update(payload);
        let signature = mac.finalize().into_bytes();

        let tampered_secret = "fake_secret".to_string();
        assert!(!verify_hmac_signature(&signature, tampered_secret, payload));
    }
}

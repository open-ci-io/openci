use axum::{
    body::Bytes,
    http::{HeaderMap, StatusCode},
};
use hmac::{Hmac, Mac};
use sha2::Sha256;

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
    verify_github_signature(&headers, &body)?;

    Ok(StatusCode::OK)
}

fn verify_github_signature(headers: &HeaderMap, body: &Bytes) -> Result<(), (StatusCode, String)> {
    let github_signature = extract_github_signature(headers)?;
    let webhook_secret = get_webhook_secret()?;
    let calculated_signature = calculate_hmac_signature(&webhook_secret, body);

    if github_signature != calculated_signature {
        return Err((StatusCode::UNAUTHORIZED, "Invalid signature".to_string()));
    }

    Ok(())
}

fn extract_github_signature(headers: &HeaderMap) -> Result<&str, (StatusCode, String)> {
    headers
        .get("x-hub-signature-256")
        .and_then(|v| v.to_str().ok())
        .ok_or((StatusCode::UNAUTHORIZED, "Missing signature".to_string()))
}

fn get_webhook_secret() -> Result<String, (StatusCode, String)> {
    std::env::var("GITHUB_WEBHOOK_SECRET").map_err(|_| {
        (
            StatusCode::INTERNAL_SERVER_ERROR,
            "Webhook secret not configured".to_string(),
        )
    })
}

fn calculate_hmac_signature(secret: &str, body: &Bytes) -> String {
    let mut mac =
        Hmac::<Sha256>::new_from_slice(secret.as_bytes()).expect("HMAC can take key of any size");
    mac.update(body);
    format!("sha256={}", hex::encode(mac.finalize().into_bytes()))
}

#[cfg(test)]
mod tests {
    use super::*;

    const EXPECTED_SIGNATURE_LENGTH: usize = 71;
    const SIGNATURE_PREFIX: &str = "sha256=";

    mod hmac_signature {
        use super::*;
        #[test]
        fn test_calculate_hmac_signature_with_known_values() {
            let secret = "It's a Secret to Everybody";
            let body = Bytes::from("Hello, World!");

            let signature = calculate_hmac_signature(secret, &body);
            let pre_calculated_signature =
                "sha256=757107ea0eb2509fc211221cce984b8a37570b6d7586c22c46f4379c8b043e17";
            assert_eq!(signature, pre_calculated_signature);
        }

        #[test]
        fn test_calculate_hmac_signature_format() {
            let secret = "test_secret";
            let body = Bytes::from("test body");

            let signature = calculate_hmac_signature(secret, &body);

            assert!(signature.starts_with(SIGNATURE_PREFIX));
            assert_eq!(signature.len(), EXPECTED_SIGNATURE_LENGTH);

            let hex_part = &signature[7..];
            assert!(hex_part.chars().all(|c| c.is_ascii_hexdigit()));
        }

        #[test]
        fn test_calculate_hmac_signature_empty_body() {
            let secret = "test_secret";
            let body = Bytes::from("");

            let signature = calculate_hmac_signature(secret, &body);

            assert!(signature.starts_with(SIGNATURE_PREFIX));

            assert_eq!(signature.len(), EXPECTED_SIGNATURE_LENGTH);

            let signature2 = calculate_hmac_signature(secret, &body);
            assert_eq!(signature, signature2);
        }

        #[test]
        fn test_calculate_hmac_signature_different_inputs() {
            let body = Bytes::from("same body");

            let sig1 = calculate_hmac_signature("secret1", &body);
            let sig2 = calculate_hmac_signature("secret2", &body);
            assert_ne!(sig1, sig2);

            let secret = "same_secret";
            let sig3 = calculate_hmac_signature(secret, &Bytes::from("body1"));
            let sig4 = calculate_hmac_signature(secret, &Bytes::from("body2"));
            assert_ne!(sig3, sig4);
        }

        #[test]
        fn test_calculate_hmac_signature_large_body() {
            let secret = "test_secret";
            let large_body = Bytes::from(vec![b'a'; 1024 * 1024]);

            let signature = calculate_hmac_signature(secret, &large_body);

            assert!(signature.starts_with(SIGNATURE_PREFIX));
            assert_eq!(signature.len(), EXPECTED_SIGNATURE_LENGTH);
        }
    }
}

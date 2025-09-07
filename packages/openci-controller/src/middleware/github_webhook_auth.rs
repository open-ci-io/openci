use axum::{
    body::Bytes,
    extract::Request,
    http::{HeaderMap, StatusCode},
    middleware::Next,
    response::Response,
};
use hmac::{Hmac, Mac};
use sha2::Sha256;

pub async fn github_webhook_auth_middleware(
    mut request: Request,
    next: Next,
) -> Result<Response, (StatusCode, String)> {
    const MAX_BODY_SIZE: usize = 1024 * 1024;
    let headers = request.headers().clone();

    let (parts, body) = request.into_parts();
    let bytes = axum::body::to_bytes(body, MAX_BODY_SIZE)
        .await
        .map_err(|_| (StatusCode::BAD_REQUEST, "Failed to read body".to_string()))?;

    verify_github_signature(&headers, &bytes)?;

    request = Request::from_parts(parts, axum::body::Body::from(bytes));
    Ok(next.run(request).await)
}

fn verify_github_signature(headers: &HeaderMap, body: &Bytes) -> Result<(), (StatusCode, String)> {
    let webhook_secret = extract_github_signature(headers)?;
    verify_github_signature_with_secret(headers, body, &webhook_secret)
}

fn verify_github_signature_with_secret(
    headers: &HeaderMap,
    body: &Bytes,
    secret: &str,
) -> Result<(), (StatusCode, String)> {
    let github_signature = extract_github_signature(headers)?;
    let sig_bytes = parse_sha256_signature(github_signature)?;
    verify_hmac_signature(secret, body, &sig_bytes)
}


fn extract_github_signature(headers: &HeaderMap) -> Result<&str, (StatusCode, String)> {
    headers
        .get("x-hub-signature-256")
        .and_then(|v| v.to_str().ok())
        .ok_or((
            StatusCode::UNAUTHORIZED,
            "Missing or invalid signature".to_string(),
        ))
}

fn get_webhook_secret() -> Result<String, (StatusCode, String)> {
    let secret = std::env::var("GITHUB_WEBHOOK_SECRET").map_err(|_| {
        (
            StatusCode::INTERNAL_SERVER_ERROR,
            "Webhook secret not configured".to_string(),
        )
    })?;

    if secret.is_empty() {
        return Err((
            StatusCode::INTERNAL_SERVER_ERROR,
            "Webhook secret cannot be empty".to_string(),
        ));
    }

    Ok(secret)
}

fn parse_sha256_signature(signature: &str) -> Result<Vec<u8>, (StatusCode, String)> {
    if !signature.starts_with("sha256=") {
        return Err((
            StatusCode::UNAUTHORIZED,
            "Invalid signature format".to_string(),
        ));
    }

    let hex_part = &signature[7..];
    hex::decode(hex_part).map_err(|_| {
        (
            StatusCode::UNAUTHORIZED,
            "Invalid signature encoding".to_string(),
        )
    })
}

fn verify_hmac_signature(
    secret: &str,
    body: &Bytes,
    expected_signature: &[u8],
) -> Result<(), (StatusCode, String)> {
    let mut mac = Hmac::<Sha256>::new_from_slice(secret.as_bytes()).map_err(|_| {
        (
            StatusCode::INTERNAL_SERVER_ERROR,
            "HMAC init failed".to_string(),
        )
    })?;
    mac.update(body);
    mac.verify_slice(expected_signature)
        .map_err(|_| (StatusCode::UNAUTHORIZED, "Invalid signature".to_string()))
}

#[cfg(test)]
mod tests {
    use hmac::{Hmac, Mac};

    use super::*;

    fn calculate_test_signature(secret: &str, body: &Bytes) -> String {
        let mut mac = Hmac::<Sha256>::new_from_slice(secret.as_bytes())
            .expect("HMAC can take key of any size");
        mac.update(body);
        format!("sha256={}", hex::encode(mac.finalize().into_bytes()))
    }

    mod extract_github_signature {
        use axum::http::HeaderValue;

        const GITHUB_WEBHOOK_HEADER: &str = "x-hub-signature-256";
        const DEMO_SIGNATURE: &str = "sha256=abcd1234";

        use super::*;
        #[test]
        fn test_extract_github_signature_success() {
            let mut headers = HeaderMap::new();
            headers.insert(
                GITHUB_WEBHOOK_HEADER,
                HeaderValue::from_static(DEMO_SIGNATURE),
            );

            let result = extract_github_signature(&headers);
            assert_eq!(result.unwrap(), DEMO_SIGNATURE);
        }

        #[test]
        fn test_extract_github_signature_wrong_header() {
            let mut headers = HeaderMap::new();

            headers.insert("wrong_header", HeaderValue::from_static(DEMO_SIGNATURE));
            let result = extract_github_signature(&headers);
            assert!(result.is_err());
            let (status, _) = result.unwrap_err();

            assert_eq!(status, StatusCode::UNAUTHORIZED);
        }
    }

    mod get_webhook_secret {
        use serial_test::serial;
        use std::env;

        use super::*;
        #[test]
        #[serial]
        fn test_get_webhook_secret_success() {
            env::set_var("GITHUB_WEBHOOK_SECRET", "test_secret_123");

            let result = get_webhook_secret();
            assert!(result.is_ok());
            assert_eq!(result.unwrap(), "test_secret_123");

            env::remove_var("GITHUB_WEBHOOK_SECRET");
        }

        #[test]
        #[serial]
        fn test_get_webhook_secret_missing_env_var() {
            env::remove_var("GITHUB_WEBHOOK_SECRET");

            let result = get_webhook_secret();
            assert!(result.is_err());
            let (status, message) = result.unwrap_err();
            assert_eq!(status, StatusCode::INTERNAL_SERVER_ERROR);
            assert_eq!(message, "Webhook secret not configured");
        }

        #[test]
        #[serial]
        fn test_get_webhook_secret_empty_value() {
            env::set_var("GITHUB_WEBHOOK_SECRET", "");

            let result = get_webhook_secret();
            assert!(result.is_err());

            env::remove_var("GITHUB_WEBHOOK_SECRET");
        }
    }

    mod parse_sha256_signature {
        use super::*;

        #[test]
        fn test_parse_sha256_signature_success() {
            let signature = "sha256=abcd1234ef567890";

            let result = parse_sha256_signature(signature);
            assert!(result.is_ok());

            let expected_bytes = hex::decode("abcd1234ef567890").unwrap();
            assert_eq!(result.unwrap(), expected_bytes);
        }

        #[test]
        fn test_parse_sha256_signature_full_length() {
            let signature =
                "sha256=757107ea0eb2509fc211221cce984b8a37570b6d7586c22c46f4379c8b043e17";

            let result = parse_sha256_signature(signature);
            assert!(result.is_ok());
            assert_eq!(result.unwrap().len(), 32);
        }

        #[test]
        fn test_parse_sha256_signature_missing_prefix() {
            let signature = "abcd1234ef567890";

            let result = parse_sha256_signature(signature);
            assert!(result.is_err());
            let (status, message) = result.unwrap_err();
            assert_eq!(status, StatusCode::UNAUTHORIZED);
            assert_eq!(message, "Invalid signature format");
        }

        #[test]
        fn test_parse_sha256_signature_wrong_prefix() {
            let signature = "sha1=abcd1234ef567890";

            let result = parse_sha256_signature(signature);
            assert!(result.is_err());
            let (status, message) = result.unwrap_err();
            assert_eq!(status, StatusCode::UNAUTHORIZED);
            assert_eq!(message, "Invalid signature format");
        }

        #[test]
        fn test_parse_sha256_signature_invalid_hex() {
            let signature = "sha256=xyz123";

            let result = parse_sha256_signature(signature);
            assert!(result.is_err());
            let (status, message) = result.unwrap_err();
            assert_eq!(status, StatusCode::UNAUTHORIZED);
            assert_eq!(message, "Invalid signature encoding");
        }

        #[test]
        fn test_parse_sha256_signature_empty_hex() {
            let signature = "sha256=";

            let result = parse_sha256_signature(signature);
            assert!(result.is_ok());
            assert_eq!(result.unwrap(), Vec::<u8>::new());
        }

        #[test]
        fn test_parse_sha256_signature_odd_length_hex() {
            let signature = "sha256=abc";

            let result = parse_sha256_signature(signature);
            assert!(result.is_err());
            let (status, message) = result.unwrap_err();
            assert_eq!(status, StatusCode::UNAUTHORIZED);
            assert_eq!(message, "Invalid signature encoding");
        }
    }

    mod verify_hmac_signature {
        use super::*;

        #[test]
        fn test_verify_hmac_signature_success() {
            let secret = "test_secret";
            let body = Bytes::from("test_body");

            let expected_signature = calculate_test_signature(secret, &body);
            let signature_bytes = parse_sha256_signature(&expected_signature).unwrap();

            let result = verify_hmac_signature(secret, &body, &signature_bytes);
            assert!(result.is_ok());
        }

        #[test]
        fn test_verify_hmac_signature_wrong_signature() {
            let secret = "test_secret";
            let body = Bytes::from("test_body");
            let wrong_signature = vec![0u8; 32];

            let result = verify_hmac_signature(secret, &body, &wrong_signature);
            assert!(result.is_err());
            let (status, message) = result.unwrap_err();
            assert_eq!(status, StatusCode::UNAUTHORIZED);
            assert_eq!(message, "Invalid signature");
        }

        #[test]
        fn test_verify_hmac_signature_wrong_secret() {
            let body = Bytes::from("test_body");

            let expected_signature = calculate_test_signature("correct_secret", &body);
            let signature_bytes = parse_sha256_signature(&expected_signature).unwrap();

            let result = verify_hmac_signature("wrong_secret", &body, &signature_bytes);
            assert!(result.is_err());
            let (status, message) = result.unwrap_err();
            assert_eq!(status, StatusCode::UNAUTHORIZED);
            assert_eq!(message, "Invalid signature");
        }

        #[test]
        fn test_verify_hmac_signature_wrong_body() {
            let secret = "test_secret";

            let original_body = Bytes::from("original_body");

            let expected_signature = calculate_test_signature("test_secret", &original_body);
            let signature_bytes = parse_sha256_signature(&expected_signature).unwrap();

            let wrong_body = Bytes::from("wrong_body");
            let result = verify_hmac_signature(secret, &wrong_body, &signature_bytes);
            assert!(result.is_err());
            let (status, message) = result.unwrap_err();
            assert_eq!(status, StatusCode::UNAUTHORIZED);
            assert_eq!(message, "Invalid signature");
        }

        #[test]
        fn test_verify_hmac_signature_empty_body() {
            let secret = "test_secret";
            let body = Bytes::from("");

            let expected_signature = calculate_test_signature(secret, &body);
            let signature_bytes = parse_sha256_signature(&expected_signature).unwrap();

            let result = verify_hmac_signature(secret, &body, &signature_bytes);
            assert!(result.is_ok());
        }

        #[test]
        fn test_verify_hmac_signature_invalid_length() {
            let secret = "test_secret";
            let body = Bytes::from("test_body");
            let short_signature = vec![0u8; 16];

            let result = verify_hmac_signature(secret, &body, &short_signature);
            assert!(result.is_err());
            let (status, message) = result.unwrap_err();
            assert_eq!(status, StatusCode::UNAUTHORIZED);
            assert_eq!(message, "Invalid signature");
        }
    }

    mod verify_github_signature {
        use super::*;
        use axum::http::HeaderValue;

        const TEST_SECRET: &str = "test_secret";
        const TEST_BODY: &str = "test_body";
        const DIFFERENT_BODY: &str = "different_body";
        const TEST_HEADER_KEY: &str = "x-hub-signature-256";

        #[test]
        fn test_verify_github_signature_success() {
            let body = Bytes::from(TEST_BODY);
            let mut headers = HeaderMap::new();

            let signature = calculate_test_signature(TEST_SECRET, &body);
            headers.insert(
                TEST_HEADER_KEY,
                HeaderValue::from_str(&signature).unwrap(),
            );

            let result = verify_github_signature_with_secret(&headers, &body, TEST_SECRET);
            assert!(result.is_ok());
        }

        #[test]
        fn test_verify_github_signature_wrong_signature() {
            let body = Bytes::from(TEST_BODY);
            let mut headers = HeaderMap::new();

            let signature = calculate_test_signature(TEST_SECRET, &Bytes::from(DIFFERENT_BODY));
            headers.insert(
                TEST_HEADER_KEY,
                HeaderValue::from_str(&signature).unwrap(),
            );

            let result = verify_github_signature(&headers, &body);
            assert!(result.is_err());
        }
    }
}

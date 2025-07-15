use rand::Rng;
use sha2::{Digest, Sha256};
use sqlx::PgPool;

const API_KEY_PREFIX: &str = "opnci_";
const API_KEY_BODY_LENGTH: usize = 32;

pub fn generate_api_key_body() -> String {
    let charset: &[u8] = b"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    let mut rng = rand::rng();

    (0..API_KEY_BODY_LENGTH)
        .map(|_| {
            let idx = rng.random_range(0..charset.len());
            charset[idx] as char
        })
        .collect()
}

pub fn hash_api_key(api_key: &str) -> String {
    let mut hasher = Sha256::new();
    hasher.update(api_key.as_bytes());
    format!("{:x}", hasher.finalize())
}

pub async fn validate_api_key<R: ApiKeyRepository>(repo: &R, api_key: &str) -> Option<i32> {
    if api_key.is_empty() {
        return None;
    }
    if !api_key.starts_with(API_KEY_PREFIX) {
        return None;
    }

    let hashed_key = hash_api_key(api_key);
    match repo.update_and_get_user_id(&hashed_key).await {
        Ok(user_id) => user_id,
        Err(e) => {
            eprintln!("API key validation database error: {}", e);
            None
        }
    }
}

pub fn create_full_api_key(api_key_body: &str) -> String {
    format!("{}{}", API_KEY_PREFIX, api_key_body)
}

pub fn get_api_key_prefix() -> &'static str {
    API_KEY_PREFIX
}

#[cfg_attr(test, mockall::automock)]
#[async_trait::async_trait]
pub trait ApiKeyRepository {
    async fn update_and_get_user_id(&self, hashed_key: &str) -> Result<Option<i32>, sqlx::Error>;
}

#[async_trait::async_trait]
impl ApiKeyRepository for PgPool {
    async fn update_and_get_user_id(&self, hashed_key: &str) -> Result<Option<i32>, sqlx::Error> {
        let record = sqlx::query!(
            r#"
            UPDATE api_keys
            SET last_used_at = NOW()
            WHERE hashed_key = $1
            RETURNING user_id
            "#,
            hashed_key
        )
        .fetch_optional(self)
        .await?;

        Ok(record.map(|r| r.user_id))
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use mockall::predicate::*;

    #[tokio::test]
    async fn test_validate_api_key_with_valid_key() {
        let api_key = "opnci_validkey123";
        let hashed_key = hash_api_key(api_key);

        let mut mock_repo = MockApiKeyRepository::new();
        mock_repo
            .expect_update_and_get_user_id()
            .with(eq(hashed_key))
            .times(1)
            .returning(|_| Ok(Some(42)));

        let result = validate_api_key(&mock_repo, api_key).await;
        assert_eq!(result, Some(42));
    }

    #[tokio::test]
    async fn test_validate_api_key_with_nonexistent_key() {
        let api_key = "opnci_nonexistentkey123";
        let hashed_key = hash_api_key(api_key);

        let mut mock_repo = MockApiKeyRepository::new();
        mock_repo
            .expect_update_and_get_user_id()
            .with(eq(hashed_key))
            .returning(|_| Ok(None));

        let result = validate_api_key(&mock_repo, api_key).await;
        assert_eq!(result, None);
    }

    #[tokio::test]
    async fn test_validate_api_key_with_empty_key() {
        let mock_repo = MockApiKeyRepository::new();
        let result = validate_api_key(&mock_repo, "").await;
        assert_eq!(result, None);
    }

    #[tokio::test]
    async fn test_validate_api_key_with_invalid_prefix() {
        let mock_repo = MockApiKeyRepository::new();
        let result = validate_api_key(&mock_repo, "invalid_prefix_key").await;
        assert_eq!(result, None);
    }

    #[tokio::test]
    async fn test_validate_api_key_with_database_error() {
        let api_key = "opnci_errorkey123";
        let hashed_key = hash_api_key(api_key);

        let mut mock_repo = MockApiKeyRepository::new();
        mock_repo
            .expect_update_and_get_user_id()
            .with(eq(hashed_key))
            .returning(|_| Err(sqlx::Error::RowNotFound));

        let result = validate_api_key(&mock_repo, api_key).await;
        assert_eq!(result, None);
    }

    #[test]
    fn test_hash_api_key_consistency() {
        let api_key = "opnci_test123456789";
        let hash1 = hash_api_key(api_key);
        let hash2 = hash_api_key(api_key);
        assert_eq!(hash1, hash2);
    }

    #[test]
    fn test_hash_api_key_different_inputs() {
        let api_key1 = "opnci_test123456789";
        let api_key2 = "opnci_test987654321";
        let hash1 = hash_api_key(api_key1);
        let hash2 = hash_api_key(api_key2);
        assert_ne!(hash1, hash2);
    }

    #[test]
    fn test_empty_api_key_hash() {
        let empty_hash = hash_api_key("");
        assert_eq!(
            empty_hash,
            "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"
        );
    }

    #[test]
    fn test_generate_api_key_body_length() {
        let api_key_body = generate_api_key_body();
        assert_eq!(api_key_body.len(), API_KEY_BODY_LENGTH);
    }

    #[test]
    fn test_generate_api_key_body_charset() {
        let api_key_body = generate_api_key_body();
        let valid_charset = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

        for c in api_key_body.chars() {
            assert!(
                valid_charset.contains(c),
                "Generated character '{}' is not in the valid charset",
                c
            );
        }
    }

    #[test]
    fn test_generate_api_key_body_randomness() {
        let mut keys = std::collections::HashSet::new();
        let iterations = 100;

        for _ in 0..iterations {
            keys.insert(generate_api_key_body());
        }

        assert_eq!(
            keys.len(),
            iterations,
            "Generated duplicate API keys, which suggests poor randomness"
        );
    }

    #[test]
    fn test_generate_api_key_body_not_empty() {
        let api_key_body = generate_api_key_body();
        assert!(!api_key_body.is_empty());
    }

    #[test]
    fn test_full_api_key_format() {
        let api_key_body = generate_api_key_body();
        let full_api_key = create_full_api_key(&api_key_body);

        assert!(full_api_key.starts_with(API_KEY_PREFIX));
        assert_eq!(
            full_api_key.len(),
            API_KEY_PREFIX.len() + API_KEY_BODY_LENGTH
        );
    }
}

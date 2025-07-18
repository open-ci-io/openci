use crate::services::api_key_service;
use sqlx::PgPool;
use std::env;
use tracing::{debug, info};
use validator::ValidateEmail;

#[derive(Debug, Clone)]
struct InitialAdminConfig {
    pub name: String,
    pub email: String,
}

fn load_initial_admin_config() -> Option<InitialAdminConfig> {
    match (
        env::var("OPENCI_INITIAL_ADMIN_NAME").ok(),
        env::var("OPENCI_INITIAL_ADMIN_EMAIL").ok(),
    ) {
        (Some(name), Some(email)) => {
            if !email.validate_email() {
                info!(
                    "Invalid email format in OPENCI_INITIAL_ADMIN_EMAIL: {}",
                    email
                );
                return None;
            }
            Some(InitialAdminConfig { name, email })
        }
        _ => None,
    }
}

async fn check_users_exist(pool: &PgPool) -> Result<bool, sqlx::Error> {
    sqlx::query_scalar::<_, bool>("SELECT EXISTS(SELECT 1 FROM users LIMIT 1)")
        .fetch_one(pool)
        .await
}

async fn create_admin_user(pool: &PgPool, config: &InitialAdminConfig) -> Result<i32, sqlx::Error> {
    let record = sqlx::query!(
        r#"
        INSERT INTO users (name, email, role)
        VALUES ($1, $2, 'admin')
        RETURNING id
        "#,
        config.name,
        config.email
    )
    .fetch_one(pool)
    .await?;

    Ok(record.id)
}

pub async fn create_initial_api_key(pool: &PgPool, user_id: i32) -> Result<String, sqlx::Error> {
    let api_key_body = api_key_service::generate_api_key_body();
    let full_api_key = api_key_service::create_full_api_key(&api_key_body);
    let hashed_key = api_key_service::hash_api_key(&full_api_key);

    sqlx::query!(
        r#"
        INSERT INTO api_keys (user_id, name, hashed_key, prefix)
        VALUES ($1, 'Initial Admin Key', $2, $3)
        "#,
        user_id,
        hashed_key,
        api_key_service::get_api_key_prefix(),
    )
    .execute(pool)
    .await?;

    Ok(full_api_key)
}

pub fn display_api_key_info(api_key: &str) {
    println!("\n");
    println!("========================================");
    println!("Initial Admin Setup Completed!");
    println!("");
    println!("API Key: {}", api_key);
    println!("");
    println!("IMPORTANT: Save this key securely!");
    println!("This is the only time it will be shown.");
    println!("========================================");
    println!("\n");
}

pub async fn setup_initial_admin(pool: &PgPool) -> Result<(), Box<dyn std::error::Error>> {
    if check_users_exist(pool).await? {
        debug!("Users already exist, skipping initial setup");
        return Ok(());
    }

    let config = match load_initial_admin_config() {
        Some(config) => config,
        None => {
            info!("No initial admin configured. You can create users via API.");
            return Ok(());
        }
    };

    info!("Creating initial admin user: {}", config.email);

    let user_id = create_admin_user(pool, &config).await?;

    let api_key = create_initial_api_key(pool, user_id).await?;

    display_api_key_info(&api_key);
    info!("Initial admin user and API key created successfully");

    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;
    use sqlx::PgPool;
    use std::env;

    fn setup_env_vars() {
        env::set_var("OPENCI_INITIAL_ADMIN_NAME", "Test Admin");
        env::set_var("OPENCI_INITIAL_ADMIN_EMAIL", "admin@test.com");
    }

    fn cleanup_env_vars() {
        env::remove_var("OPENCI_INITIAL_ADMIN_NAME");
        env::remove_var("OPENCI_INITIAL_ADMIN_EMAIL");
    }
    #[test]
    fn test_load_initial_admin_config_with_valid_env() {
        setup_env_vars();

        let config = load_initial_admin_config();

        assert!(config.is_some());
        let config = config.unwrap();
        assert_eq!(config.name, "Test Admin");
        assert_eq!(config.email, "admin@test.com");

        cleanup_env_vars();
    }

    #[test]
    fn test_load_initial_admin_config_missing_name() {
        env::set_var("OPENCI_INITIAL_ADMIN_EMAIL", "admin@test.com");

        let config = load_initial_admin_config();

        assert!(config.is_none());

        env::remove_var("OPENCI_INITIAL_ADMIN_EMAIL");
    }

    #[test]
    fn test_load_initial_admin_config_missing_email() {
        env::set_var("OPENCI_INITIAL_ADMIN_NAME", "Test Admin");

        let config = load_initial_admin_config();

        assert!(config.is_none());

        env::remove_var("OPENCI_INITIAL_ADMIN_NAME");
    }

    #[test]
    fn test_load_initial_admin_config_no_env() {
        cleanup_env_vars();

        let config = load_initial_admin_config();

        assert!(config.is_none());
    }

    #[test]
    fn test_load_initial_admin_config_invalid_email() {
        env::set_var("OPENCI_INITIAL_ADMIN_NAME", "Test Admin");
        env::set_var("OPENCI_INITIAL_ADMIN_EMAIL", "invalid-email");

        let config = load_initial_admin_config();

        assert!(config.is_none());

        cleanup_env_vars();
    }

    #[test]
    fn test_load_initial_admin_config_valid_email_formats() {
        env::set_var("OPENCI_INITIAL_ADMIN_NAME", "Test Admin");

        let valid_emails = vec![
            "user@example.com",
            "user.name@example.com",
            "user+tag@example.co.jp",
            "user_name@sub.example.com",
        ];

        for email in valid_emails {
            env::set_var("OPENCI_INITIAL_ADMIN_EMAIL", email);
            let config = load_initial_admin_config();
            assert!(config.is_some(), "Email {} should be valid", email);
        }

        let invalid_emails = vec![
            "@example.com",
            "user@",
            "user",
            "user@@example.com",
            "user@.com",
            "",
            "user @example.com",
            "user@example..com",
            "user<>@example.com",
            "user@example,com",
            "user@",
            "plainaddress",
            "@",
        ];

        for email in invalid_emails {
            env::set_var("OPENCI_INITIAL_ADMIN_EMAIL", email);
            let config = load_initial_admin_config();
            assert!(config.is_none(), "Email {} should be invalid", email);
        }

        cleanup_env_vars();
    }

    #[sqlx::test]
    async fn test_check_users_exist_empty_table(pool: PgPool) {
        let exists = check_users_exist(&pool).await.unwrap();
        assert!(!exists);
    }

    #[sqlx::test]
    async fn test_check_users_exist_with_users(pool: PgPool) {
        sqlx::query!(
            "INSERT INTO users (name, email, role) VALUES ($1, $2, $3)",
            "Test User",
            "test@example.com",
            "member"
        )
        .execute(&pool)
        .await
        .unwrap();

        let exists = check_users_exist(&pool).await.unwrap();
        assert!(exists);
    }

    #[sqlx::test]
    async fn test_create_admin_user(pool: PgPool) {
        let config = InitialAdminConfig {
            name: "Test Admin".to_string(),
            email: "admin@test.com".to_string(),
        };

        let user_id = create_admin_user(&pool, &config).await.unwrap();
        assert!(user_id > 0);

        let user = sqlx::query!("SELECT name, email, role FROM users WHERE id = $1", user_id)
            .fetch_one(&pool)
            .await
            .unwrap();

        assert_eq!(user.name, "Test Admin");
        assert_eq!(user.email, "admin@test.com");
        assert_eq!(user.role, "admin");
    }

    #[sqlx::test]
    async fn test_create_initial_api_key(pool: PgPool) {
        let user_id = sqlx::query_scalar!(
            "INSERT INTO users (name, email, role) VALUES ($1, $2, $3) RETURNING id",
            "Test User",
            "test@example.com",
            "admin"
        )
        .fetch_one(&pool)
        .await
        .unwrap();

        let api_key = create_initial_api_key(&pool, user_id).await.unwrap();

        assert!(api_key.starts_with("openci_"));
        assert!(api_key.len() > 20);

        let key_count =
            sqlx::query_scalar!("SELECT COUNT(*) FROM api_keys WHERE user_id = $1", user_id)
                .fetch_one(&pool)
                .await
                .unwrap()
                .unwrap_or(0);

        assert_eq!(key_count, 1);
    }

    #[sqlx::test]
    async fn test_setup_initial_admin_full_flow(pool: PgPool) {
        setup_env_vars();

        let result = setup_initial_admin(&pool).await;
        assert!(result.is_ok());

        let user_count = sqlx::query_scalar!(
            "SELECT COUNT(*) FROM users WHERE email = $1",
            "admin@test.com"
        )
        .fetch_one(&pool)
        .await
        .unwrap()
        .unwrap_or(0);

        assert_eq!(user_count, 1);

        let result = setup_initial_admin(&pool).await;
        assert!(result.is_ok());

        let user_count_after = sqlx::query_scalar!("SELECT COUNT(*) FROM users")
            .fetch_one(&pool)
            .await
            .unwrap()
            .unwrap_or(0);

        assert_eq!(user_count_after, 1);

        cleanup_env_vars();
    }

    #[sqlx::test]
    async fn test_setup_initial_admin_no_config(pool: PgPool) {
        cleanup_env_vars();

        let result = setup_initial_admin(&pool).await;
        assert!(result.is_ok());

        let user_count = sqlx::query_scalar!("SELECT COUNT(*) FROM users")
            .fetch_one(&pool)
            .await
            .unwrap()
            .unwrap_or(0);

        assert_eq!(user_count, 0);
    }
}

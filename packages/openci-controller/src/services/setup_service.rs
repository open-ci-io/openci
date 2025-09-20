use crate::services::api_key_service;
use serde_email::is_valid_email;
use sqlx::{PgPool, Postgres, Transaction};
use std::borrow::Cow;
use std::env;
use tracing::{debug, info, warn};

#[derive(Debug, Clone)]
pub struct InitialAdminConfig {
    pub name: String,
    pub email: String,
}

pub trait ConfigLoader {
    fn load_initial_admin_config(&self) -> Option<InitialAdminConfig>;
}

pub struct EnvConfigLoader;
impl ConfigLoader for EnvConfigLoader {
    fn load_initial_admin_config(&self) -> Option<InitialAdminConfig> {
        match (
            env::var("OPENCI_INITIAL_ADMIN_NAME").ok(),
            env::var("OPENCI_INITIAL_ADMIN_EMAIL").ok(),
        ) {
            (Some(name), Some(email)) => {
                if !is_valid_email(&email) {
                    warn!(
                        "Invalid OPENCI_INITIAL_ADMIN_EMAIL format; ignoring initial admin config"
                    );
                    return None;
                }
                Some(InitialAdminConfig { name, email })
            }
            _ => None,
        }
    }
}

async fn check_users_exist(pool: &PgPool) -> Result<bool, sqlx::Error> {
    sqlx::query_scalar::<_, bool>(
        r#"
SELECT EXISTS(SELECT 1 FROM users LIMIT 1)
    "#,
    )
    .fetch_one(pool)
    .await
}

async fn create_admin_user_tx(
    tx: &mut Transaction<'_, Postgres>,
    config: &InitialAdminConfig,
) -> Result<i32, sqlx::Error> {
    let name = config.name.trim();
    let email = config.email.trim();

    if name.is_empty() {
        return Err(sqlx::Error::Protocol(
            "Name cannot be empty".to_string().into(),
        ));
    }

    let record = sqlx::query!(
        r#"
        INSERT INTO users (name, email, role)
        VALUES ($1, $2, 'admin')
        RETURNING id
        "#,
        name,
        email
    )
    .fetch_one(&mut **tx)
    .await
    .map_err(|e| {
        if let sqlx::Error::Database(db_err) = &e {
            if db_err.code() == Some(Cow::from("23505")) {
                tracing::info!("Email already exists: {}", email);
            }
        }
        e
    })?;

    Ok(record.id)
}

async fn create_initial_api_key_tx(
    tx: &mut Transaction<'_, Postgres>,
    user_id: i32,
) -> Result<String, sqlx::Error> {
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
    .execute(&mut **tx)
    .await?;

    Ok(full_api_key)
}

pub fn display_api_key_info(api_key: &str) {
    let message = format!(
        "\n========================================\n\
         Initial Admin Setup Completed!\n\n\
         API Key: {}\n\n\
         IMPORTANT: Save this key securely!\n\
         This is the only time it will be shown.\n\
         ========================================\n",
        api_key
    );

    println!("{}", message);
    info!("Initial admin API key displayed to console");
}

pub async fn setup_initial_admin(
    pool: &PgPool,
    config_loader: &impl ConfigLoader,
) -> Result<(), Box<dyn std::error::Error>> {
    if check_users_exist(pool).await? {
        debug!("Users already exist, skipping initial setup");
        return Ok(());
    }

    let config = match config_loader.load_initial_admin_config() {
        Some(config) => config,
        None => {
            info!("No initial admin configured");
            return Ok(());
        }
    };

    info!("Creating initial admin user: {}", config.email);

    let mut tx = pool.begin().await?;

    let user_id = create_admin_user_tx(&mut tx, &config).await?;
    let api_key = create_initial_api_key_tx(&mut tx, user_id).await?;

    tx.commit().await?;

    display_api_key_info(&api_key);
    info!("Initial admin user and API key created successfully");

    Ok(())
}

#[cfg(test)]
pub struct MockConfigLoader {
    config: Option<InitialAdminConfig>,
}

#[cfg(test)]
impl MockConfigLoader {
    pub fn new(config: Option<InitialAdminConfig>) -> Self {
        Self { config }
    }
}

#[cfg(test)]
impl ConfigLoader for MockConfigLoader {
    fn load_initial_admin_config(&self) -> Option<InitialAdminConfig> {
        self.config.clone()
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use sqlx::PgPool;

    #[test]
    fn test_load_initial_admin_config_with_valid_env() {
        let loader = MockConfigLoader::new(Some(InitialAdminConfig {
            name: "Test Admin".to_string(),
            email: "admin@test.com".to_string(),
        }));

        let config = loader.load_initial_admin_config();

        assert!(config.is_some());
        let config = config.unwrap();
        assert_eq!(config.name, "Test Admin");
        assert_eq!(config.email, "admin@test.com");
    }

    #[test]
    fn test_load_initial_admin_config_missing_env() {
        let loader = MockConfigLoader::new(None);

        let config = loader.load_initial_admin_config();

        assert!(config.is_none());
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
    async fn test_create_admin_user_tx(pool: PgPool) {
        let config = InitialAdminConfig {
            name: "Test Admin".to_string(),
            email: "admin@test.com".to_string(),
        };

        let mut tx = pool.begin().await.unwrap();

        let user_id = create_admin_user_tx(&mut tx, &config).await.unwrap();
        assert!(user_id > 0);

        tx.commit().await.unwrap();

        let user = sqlx::query!("SELECT name, email, role FROM users WHERE id = $1", user_id)
            .fetch_one(&pool)
            .await
            .unwrap();

        assert_eq!(user.name, "Test Admin");
        assert_eq!(user.email, "admin@test.com");
        assert_eq!(user.role, "admin");
    }

    #[sqlx::test]
    async fn test_create_initial_api_key_tx(pool: PgPool) {
        let user_id = sqlx::query_scalar!(
            "INSERT INTO users (name, email, role) VALUES ($1, $2, $3) RETURNING id",
            "Test User",
            "test@example.com",
            "admin"
        )
        .fetch_one(&pool)
        .await
        .unwrap();

        let mut tx = pool.begin().await.unwrap();

        let api_key = create_initial_api_key_tx(&mut tx, user_id).await.unwrap();

        tx.commit().await.unwrap();

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
        let loader = MockConfigLoader::new(Some(InitialAdminConfig {
            name: "Test Admin".to_string(),
            email: "admin@test.com".to_string(),
        }));

        let result = setup_initial_admin(&pool, &loader).await;
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

        let result = setup_initial_admin(&pool, &loader).await;
        assert!(result.is_ok());

        let user_count_after = sqlx::query_scalar!("SELECT COUNT(*) FROM users")
            .fetch_one(&pool)
            .await
            .unwrap()
            .unwrap_or(0);

        assert_eq!(user_count_after, 1);
    }
}

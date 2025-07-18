use crate::services::api_key_service;
use sqlx::PgPool;
use std::env;
use tracing::{debug, info};

#[derive(Debug, Clone)]
pub struct InitialAdminConfig {
    pub name: String,
    pub email: String,
}

fn load_initial_admin_config() -> Option<InitialAdminConfig> {
    match (
        env::var("OPENCI_INITIAL_ADMIN_NAME").ok(),
        env::var("OPENCI_INITIAL_ADMIN_EMAIL").ok(),
    ) {
        (Some(name), Some(email)) => Some(InitialAdminConfig { name, email }),
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

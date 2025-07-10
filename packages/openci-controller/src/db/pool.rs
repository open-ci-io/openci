use crate::config::app::AppConfig;
use sqlx::{postgres::PgPoolOptions, PgPool};

pub async fn create_pool(config: &AppConfig) -> Result<PgPool, sqlx::Error> {
    PgPoolOptions::new()
        .max_connections(config.max_connections)
        .connect(&config.database_url)
        .await
}

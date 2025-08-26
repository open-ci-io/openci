use dotenvy::dotenv;
use tracing_subscriber::{layer::SubscriberExt, util::SubscriberInitExt};

use crate::services::setup_service::{setup_initial_admin, EnvConfigLoader};

mod api;
mod config;
mod db;
mod handlers;
mod middleware;
mod models;
mod server;
mod services;

#[tokio::main(flavor = "current_thread")]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    dotenv().ok();

    tracing_subscriber::registry()
        .with(
            tracing_subscriber::EnvFilter::try_from_default_env().unwrap_or_else(|_| "info".into()),
        )
        .with(tracing_subscriber::fmt::layer().json())
        .init();

    let config = config::app::AppConfig::from_env()?;

    let pool = db::pool::create_pool(&config).await?;

    setup_initial_admin(&pool, &EnvConfigLoader).await?;

    let app = api::routes::create_routes(pool);

    server::startup::run(app, &config.server_addr()).await?;

    Ok(())
}

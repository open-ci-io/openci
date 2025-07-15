use std::{env, error::Error, fmt, num::ParseIntError};

#[derive(Debug)]
pub enum ConfigError {
    Var(env::VarError),
    ParseInt(ParseIntError),
    InvalidPort(u16),
    InvalidConnections(u32),
}

impl fmt::Display for ConfigError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            ConfigError::Var(e) => write!(f, "Environment variable error: {}", e),
            ConfigError::ParseInt(e) => write!(f, "Failed to parse integer: {}", e),
            ConfigError::InvalidPort(port) => {
                write!(f, "Invalid server port: {}. Port cannot be 0.", port)
            }
            ConfigError::InvalidConnections(conn) => write!(
                f,
                "Invalid database connections: {}. Connections must be greater than 0.",
                conn
            ),
        }
    }
}

impl Error for ConfigError {
    fn source(&self) -> Option<&(dyn Error + 'static)> {
        match self {
            ConfigError::Var(e) => Some(e),
            ConfigError::ParseInt(e) => Some(e),
            _ => None,
        }
    }
}

impl From<env::VarError> for ConfigError {
    fn from(err: env::VarError) -> Self {
        ConfigError::Var(err)
    }
}

#[derive(Debug, Clone)]
pub struct AppConfig {
    pub database_url: String,
    pub server_host: String,
    pub server_port: u16,
    pub max_connections: u32,
}

impl AppConfig {
    pub fn from_env() -> Result<Self, ConfigError> {
        Ok(Self {
            database_url: env::var("DATABASE_URL")?,
            server_host: env::var("SERVER_HOST").unwrap_or_else(|_| "0.0.0.0".to_string()),
            server_port: {
                let port_str = env::var("SERVER_PORT").unwrap_or_else(|_| "8080".to_string());
                let port_num: u32 = port_str.parse().map_err(ConfigError::ParseInt)?;
                if port_num == 0 || port_num > 65535 {
                    return Err(ConfigError::InvalidPort(port_num as u16));
                }
                port_num as u16
            },
            max_connections: {
                let conn_str =
                    env::var("DATABASE_MAX_CONNECTIONS").unwrap_or_else(|_| "5".to_string());
                let conn: u32 = conn_str.parse().map_err(ConfigError::ParseInt)?;
                if conn == 0 {
                    return Err(ConfigError::InvalidConnections(conn));
                }
                conn
            },
        })
    }

    pub fn server_addr(&self) -> String {
        format!("{}:{}", self.server_host, self.server_port)
    }
}

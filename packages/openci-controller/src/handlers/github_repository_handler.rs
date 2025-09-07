use crate::models::github_repository::GitHubRepository;
use axum::http::StatusCode;
use sqlx::PgPool;
use tracing::error;

#[allow(dead_code)]
pub async fn post_github_repository(external_id: i64, pool: &PgPool) -> Result<GitHubRepository, (StatusCode, String)> {
    if external_id <= 0 {
        return Err((StatusCode::BAD_REQUEST, "external_id must be positive".to_string()));
    }
    let result = sqlx::query_as!(
        GitHubRepository,
        r#"
INSERT INTO github_repositories (external_id) VALUES ($1) RETURNING id, external_id
"#, external_id).fetch_one(pool).await.map_err(|e| {
        error!("Failed to insert github repository: {}", e);
        (
            StatusCode::INTERNAL_SERVER_ERROR,
            "Failed to insert github repository".to_string(),
        )
    })?;


    Ok(result)
}

#[allow(dead_code)]
pub async fn get_github_repository_by_external_id(external_id: i64, pool: &PgPool) -> Result<GitHubRepository, (StatusCode, String)> {
    if external_id <= 0 {
        return Err((StatusCode::BAD_REQUEST, "external_id must be positive".to_string()));
    }
    let result = sqlx::query_as!(
        GitHubRepository,
        r#"
SELECT id, external_id FROM github_repositories WHERE external_id = $1
"#,
        external_id
    ).fetch_one(pool).await.map_err(|e| {
        error!("Failed to fetch github repository: {}", e);
        (
            StatusCode::INTERNAL_SERVER_ERROR,
            "Failed to fetch github repository".to_string(),
        )
    })?;

    Ok(result)
}

#[cfg(test)]
mod github_repository_handler_tests {
    use super::*;
    use sqlx::PgPool;

    #[sqlx::test]
    async fn test_post_github_repository(pool: PgPool) {
        const EXTERNAL_ID: i64 = 1;
        let result = post_github_repository(EXTERNAL_ID, &pool).await;
        assert!(result.is_ok());
        let github_repository = result.unwrap();
        assert!(github_repository.id > 0);
        assert_eq!(github_repository.external_id, EXTERNAL_ID);

        let result = get_github_repository_by_external_id(EXTERNAL_ID, &pool).await;
        assert!(result.is_ok());
        let repository = result.unwrap();
        assert_eq!(repository.external_id, EXTERNAL_ID);
    }
}
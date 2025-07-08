use crate::models::user::User;
use axum::{extract::State, Json};
use sqlx::PgPool;

#[utoipa::path(
    get,
    path = "/users",
    responses(
        (status = 200, description = "List of users", body = [User]),
        (status = 500, description = "Internal server error. Note: current implementation panics.")
    )
)]
pub async fn get_users(State(pool): State<PgPool>) -> Json<Vec<User>> {
    let users = sqlx::query_as::<_, User>("SELECT * FROM users")
        .fetch_all(&pool)
        .await
        .expect("Failed to fetch users");

    Json(users)
}

#[cfg(test)]
mod tests {
    use super::*;
    use sqlx::PgPool;

    #[sqlx::test(fixtures("../../fixtures/users.sql"))]
    async fn test_get_users(pool: PgPool) {
        let response = get_users(State(pool)).await;
        assert!(!response.0.is_empty());
    }

    #[sqlx::test(fixtures("../../fixtures/users.sql"))]
    async fn test_get_users_returns_correct_data(pool: PgPool) {
        let response = get_users(State(pool)).await;
        let users = response.0;

        assert_eq!(users.len(), 3);

        let user_names: Vec<String> = users.iter().map(|u| u.name.clone()).collect();
        assert!(user_names.contains(&"John Doe".to_string()));
        assert!(user_names.contains(&"Jane Smith".to_string()));
    }

    #[sqlx::test]
    async fn test_get_users_empty_database(pool: PgPool) {
        let response = get_users(State(pool)).await;
        assert!(response.0.is_empty());
    }
}

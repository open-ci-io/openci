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

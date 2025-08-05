use axum::{extract::State, http::StatusCode, Json};
use sqlx::PgPool;
use tracing::error;

use crate::models::build_job::BuildJob;

#[utoipa::path(
    get,
    path = "/build-jobs",
    responses(
        (status = 200, description = "List of build jobs", body = [BuildJob]),
        (status = 500, description = "Internal server error. Note: current implementation panics.")
    )
)]
#[tracing::instrument(skip(pool))]
pub async fn get_build_jobs(
    State(pool): State<PgPool>,
) -> Result<Json<Vec<BuildJob>>, (StatusCode, String)> {
    let build_jobs = sqlx::query_as::<_, BuildJob>("SELECT * FROM build_jobs")
        .fetch_all(&pool)
        .await
        .map_err(|e| {
            error!("Failed to fetch build jobs: {:?}", e);
            error!("Error details: {}", e);
            (
                StatusCode::INTERNAL_SERVER_ERROR,
                format!("Failed to fetch build jobs: {}", e),
            )
        })?;

    Ok(Json(build_jobs))
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::models::build_job::BuildStatus;
    use axum::extract::State;
    use sqlx::PgPool;

    #[sqlx::test(fixtures("../../fixtures/users.sql", "../../fixtures/build-jobs.sql"))]
    async fn test_get_build_jobs_returns_all_jobs(pool: PgPool) {
        let result = get_build_jobs(State(pool)).await;

        match &result {
            Ok(_) => println!("Success!"),
            Err((status, message)) => {
                eprintln!("Error occurred: Status={:?}, Message={}", status, message);
            }
        }

        assert!(
            result.is_ok(),
            "Failed to get build jobs: {:?}",
            result.err()
        );
        let build_jobs = result.unwrap().0;

        assert_eq!(build_jobs.len(), 5);

        let statuses: Vec<&BuildStatus> = build_jobs.iter().map(|job| &job.build_status).collect();

        assert!(statuses.contains(&&BuildStatus::Queued));
        assert!(statuses.contains(&&BuildStatus::InProgress));
        assert!(statuses.contains(&&BuildStatus::Success));
        assert!(statuses.contains(&&BuildStatus::Failure));
        assert!(statuses.contains(&&BuildStatus::Cancelled));
    }
}

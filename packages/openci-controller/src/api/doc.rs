use crate::handlers::api_key_handler;
use crate::handlers::build_job_handler;
use crate::handlers::user_handler;
use crate::models::{
    api_key::{CreateApiKeyRequest, CreateApiKeyResponse},
    build_job::{BuildJob, BuildStatus},
    error_response::ErrorResponse,
    user::User,
};
use utoipa::OpenApi;

#[derive(OpenApi)]
#[openapi(
    info(
        title = "OpenCI API",
        version = "0.1.0",
        description = "OpenCI Controller API Documentation"
    ),
    paths(
        user_handler::get_users,
        api_key_handler::create_api_key,
        build_job_handler::get_build_jobs
    ),
    components(schemas(
        User,
        ErrorResponse,
        CreateApiKeyRequest,
        CreateApiKeyResponse,
        BuildJob,
        BuildStatus
    )),
    tags(
        (name = "users", description = "User management endpoints"),
        (name = "api-keys", description = "API key management endpoints"),
        (name = "build-jobs", description = "Build job management endpoints")
    )
)]
pub struct ApiDoc;

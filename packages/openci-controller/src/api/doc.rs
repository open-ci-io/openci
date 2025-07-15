use crate::handlers::api_key_handler;
use crate::handlers::user_handler;
use crate::models::{
    api_key::{CreateApiKeyRequest, CreateApiKeyResponse},
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
        api_key_handler::create_api_key
    ),
    components(schemas(
        User,
        ErrorResponse,
        CreateApiKeyRequest,
        CreateApiKeyResponse
    )),
    tags(
        (name = "users", description = "User management endpoints"),
        (name = "api-keys", description = "API key management endpoints")
    )
)]
pub struct ApiDoc;

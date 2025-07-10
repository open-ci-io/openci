use crate::handlers::user_handler;
use crate::models::{error_response::ErrorResponse, user::User};
use utoipa::OpenApi;

#[derive(OpenApi)]
#[openapi(
    info(
        title = "OpenCI API",
        version = "0.1.0",
        description = "OpenCI Controller API Documentation"
    ),
    paths(user_handler::get_users),
    components(schemas(User, ErrorResponse)),
    tags(
        (name = "users", description = "User management endpoints")
    )
)]
pub struct ApiDoc;

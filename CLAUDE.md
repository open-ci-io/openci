# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

OpenCI is an open-source, self-hostable CI/CD platform focused on Flutter/mobile development with extremely fast setup and execution. The project follows a vision of being accessible to everyone while contributing positively to the Flutter ecosystem.

**Key Goals**: Super fast dashboards, extremely easy setup, free/low-cost basic usage, self-hostable, open-source, accessibility, fast CI/CD processes.

## Architecture

This is a **monorepo** managed with **Melos** containing multiple interconnected components:

### Core Components

1. **openci-controller** (Rust) - Main REST API backend
   - Location: `/packages/openci-controller/`
   - Tech: Axum web framework, PostgreSQL with SQLx, authentication via API keys
   - Purpose: Handles build jobs, workflows, users, GitHub webhook processing

2. **dashboard** (Flutter) - Cross-platform admin interface  
   - Location: `/apps/dashboard/`
   - Tech: Flutter with Riverpod state management, Firebase integration
   - Purpose: Web/mobile UI for managing CI/CD workflows and monitoring builds

3. **openci_runner** (Dart CLI) - Build execution worker
   - Location: `/apps/openci_runner/`  
   - Purpose: Pulls build jobs from API, clones repos, executes Flutter builds, reports status

4. **openci_cli** (Dart CLI) - Apple App Store Connect tooling
   - Location: `/apps/openci_cli/`
   - Purpose: Certificate management, provisioning profiles, App Store operations

5. **docs** (Mintlify) - Documentation site
   - Location: `/apps/docs/`
   - Supports English and Japanese localization

### Database Architecture

PostgreSQL with comprehensive schema covering:
- **Users & Authentication**: Users table with API key-based auth
- **Repositories**: GitHub repository metadata and webhook configuration  
- **Workflows**: CI/CD pipeline definitions with Flutter-specific config
- **Build Jobs**: Individual build executions with status tracking
- **Command Logs**: Detailed build output and command execution logs
- **GitHub Events**: Webhook event processing and build triggering
- **Secrets**: Encrypted secret management with owner-based access

### Key Architectural Patterns

- **Event-driven**: GitHub webhooks → Build job creation → Worker processing
- **Microservices**: Separate concerns between API, UI, worker, and tooling
- **API-first**: RESTful API with OpenAPI/Swagger documentation
- **Security**: HMAC webhook verification, API key authentication, encrypted secrets
- **Scalability**: Worker-pool model for build execution, horizontal scaling ready

## Technology Stack

### Backend (openci-controller)
- **Language**: Rust (edition 2021)
- **Web Framework**: Axum 0.8.x with JSON responses
- **Database**: PostgreSQL via SQLx with migrations
- **Authentication**: API key middleware (X-API-Key header)
- **Security**: GitHub webhook HMAC verification, bcrypt password hashing
- **Documentation**: utoipa for OpenAPI generation
- **Logging**: tracing with structured JSON output
- **Validation**: validator crate with derive macros

### Frontend (dashboard)  
- **Framework**: Flutter 3.6+ with Material Design
- **State Management**: Riverpod with hooks
- **Backend**: Firebase (Firestore, Auth) + OpenCI REST API
- **UI Components**: Adaptive scaffolding, modal sheets, timelines
- **Platform Support**: Web, macOS, iOS, Android

### CLI Tools
- **Language**: Dart 3.6+
- **openci_runner**: Build worker with GitHub API, SSH, process execution
- **openci_cli**: App Store Connect API client for iOS deployment

### Infrastructure
- **Containerization**: Docker with multi-stage builds
- **Database**: PostgreSQL 16 Alpine
- **Deployment**: Docker Compose with environment-based configuration
- **Monorepo**: Melos for workspace management and publishing

## Development Workflow

### Getting Started
1. **Prerequisites**: Rust, Dart SDK 3.6+, Docker, PostgreSQL
2. **Setup**: `make ensure-env` (generates `.env` with random ports/passwords)
3. **Development**: `make up-dev` (starts PostgreSQL, runs migrations, starts API)
4. **Testing**: `make test` (runs Rust test suite)

### Key Commands

**Rust Backend (openci-controller)**:
```bash
cd packages/openci-controller
make up-dev          # Start development environment
make test           # Run tests  
make clean          # Clean up containers and build artifacts
make build          # Build Docker image
make db-schema      # Generate schema.sql from running database
```

**Monorepo Management (from root)**:
```bash
melos pub get       # Install all package dependencies
melos run ff        # Deploy Firebase functions  
melos publish       # Publish packages to pub.dev
```

**Database Operations**:
```bash
sqlx migrate add <name>    # Create new migration
sqlx migrate run           # Apply pending migrations  
cargo sqlx prepare         # Generate offline query metadata
```

### Environment Configuration

The openci-controller uses environment-based configuration with automatic `.env` generation:

**Required Variables**:
- `DATABASE_URL`: PostgreSQL connection string
- `GITHUB_WEBHOOK_SECRET`: For webhook HMAC verification
- `SERVER_HOST/SERVER_PORT`: API server binding

**Generated Variables** (via `make ensure-env`):
- Random PostgreSQL and API ports (49152-65535 range)
- Strong random PostgreSQL password
- Initial admin user configuration

### Code Organization Patterns

**Rust Backend Structure**:
```
src/
├── api/           # Route definitions and OpenAPI docs  
├── config/        # Environment configuration
├── db/            # Database connection pooling
├── handlers/      # Request handlers (thin layer)
├── middleware/    # Auth, GitHub webhook verification
├── models/        # Database models and DTOs
├── server/        # Application startup
└── services/      # Business logic
```

**Error Handling**: Custom error types with proper HTTP status mapping
**Validation**: Request DTOs with validator derive macros  
**Authentication**: Middleware-based with user ID injection
**Database**: SQLx with compile-time query verification

### Testing Strategy

- **Unit Tests**: Services and models with mockall for database mocking
- **Integration Tests**: Full request/response cycle testing
- **Database Tests**: Against real PostgreSQL in CI/testing
- **CLI Tests**: Dart test framework with mocktail for API mocking

### Security Considerations

- **API Authentication**: Bearer token style via X-API-Key header
- **GitHub Webhooks**: HMAC-SHA256 signature verification  
- **Secrets Management**: Encrypted storage with owner-based access control
- **Input Validation**: Comprehensive request validation with proper error responses
- **SQL Injection**: Protected via SQLx compile-time query verification

### Flutter/Dart Conventions

- **State Management**: Riverpod with code generation (`riverpod_generator`)
- **Code Generation**: `build_runner` for serialization and providers
- **Linting**: `pedantic_mono` for consistent code style
- **Architecture**: Feature-driven structure in `/src/features/`

### Key Integration Points

- **GitHub Integration**: Webhook processing → Build job creation → Status updates
- **Firebase Integration**: Dashboard authentication and real-time updates  
- **App Store Integration**: Certificate and provisioning profile management
- **Worker Communication**: REST API polling for build job assignment

### Branch Strategy

- **Main Branch**: `main` (production deployments)
- **Development Branch**: `develop` (default for PRs, uses development environment)
- **Feature Branches**: Short-lived branches for individual features
- **Current Branch**: `OP-185` (working branch for workflow handler implementation)

## Common Development Tasks

### Adding New API Endpoints
1. Add route in `src/api/routes.rs`
2. Create handler in appropriate `src/handlers/` module  
3. Define models in `src/models/`
4. Add OpenAPI documentation with `utoipa` macros
5. Run `make up-dev` to test with Swagger UI at `/docs`

### Database Schema Changes
1. `sqlx migrate add descriptive_name`
2. Write up/down migrations in generated files
3. `make up-dev` applies migrations automatically
4. `cargo sqlx prepare` for offline query compilation

### Adding New Flutter Features  
1. Create feature modules in `apps/dashboard/src/features/`
2. Use Riverpod providers for state management
3. Follow adaptive design patterns for cross-platform support
4. Run `melos run dashboard-runner` for hot reload during development

### Worker Job Processing
1. Extend `build_job` model for new job types
2. Add processing logic in `openci_runner` 
3. Update status reporting back to controller API
4. Test against local controller instance

This architecture enables rapid development while maintaining security, scalability, and code quality across the entire OpenCI platform.

# Our requests
Please tell me the architecture details rather than just the implementation specifics.
# Repository Guidelines

## Project Structure & Module Organization

- `src/api`: Routes and OpenAPI (`utoipa`), Swagger at `/docs`.
- `src/handlers`: Axum handlers for users, API keys, workflows, webhooks.
- `src/middleware`: Auth and GitHub webhook signature verification.
- `src/models`: DTOs and DB models; request/response types.
- `src/services`: Business logic (setup, API keys, etc.).
- `src/db`: Database pool and helpers (`sqlx`).
- `src/config`: App/env configuration.
- `migrations/`: SQLx migrations; `fixtures/`: seed SQL; `tests/fixtures/`: JSON payloads.
- Tooling: `Makefile`, `Dockerfile`, `docker-compose*.yml`.

## Build, Test, and Development Commands

- `make up-dev`: Start Postgres, run migrations, `cargo sqlx prepare`, then `cargo run` (serves on `:${OPENCI_PORT}`).
- `make test`: Ensure `.env`, then run `cargo test` with env loaded.
- `make db-schema`: Dump running DB schema to `schema.sql`.
- `make build` / `make rebuild`: Build Docker image (optionally no cache).
- `make down`: Stop and remove containers/volumes.
- Direct run: `cargo run` (ensure `.env` and DB are ready).

## Coding Style & Naming Conventions

- Rust 2021. Format and lint before pushing: `cargo fmt --all` and `cargo clippy --all-targets -- -D warnings`.
- Files/modules: `snake_case`; types/traits: `PascalCase`; functions/vars: `snake_case`.
- Use `tracing` for structured JSON logs; avoid `println!`.
- Prefer `Result<T, E>` and `?`; validate inputs with `validator`.

## Testing Guidelines

- Unit tests are colocated (`mod tests { ... }`); async via `#[tokio::test]`.
- DB-backed tests use `#[sqlx::test]`; run with `make test` to ensure env and DB.
- Keep reusable payloads in `tests/fixtures/**`.
- Aim for coverage of handlers, services, and middleware happy/error paths.

## Commit & Pull Request Guidelines

- Conventional Commits: `feat(scope): message`, `fix(scope): message` and reference issues like `(#391)`.
- PRs include: clear description, linked issues, test steps, migration notes, and API doc updates.
- Update OpenAPI in `src/api/doc.rs` when adding/changing endpoints.

## Security & Configuration

- Do not commit secrets. Configure via `.env` (see `.env.example`).
- Key vars: `DATABASE_URL`, `OPENCI_PORT`, `RUST_LOG`, and `GITHUB_WEBHOOK_SECRET` for webhook verification.

## Prompt

Reply in Japanese

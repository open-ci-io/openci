# Repository Guidelines

## Project Structure & Module Organization
- `packages/openci-controller/` hosts the Axum API; keep handlers in `src/handlers`, services in `src/services`, SQLx migrations in `migrations/`, fixtures for seeded data, and integration tests in `tests/`.
- `packages/openci-worker/` exposes the runner CLI in `src/main.rs` and supporting modules; place worker-specific configs under `configs/` if needed.
- `github-apps/` contains the GitHub App service with `src/` for webhook handlers, `test/` for Vitest suites, and deployment settings in `app.yml`.
- `apps/docs/` ships the documentation site; edit MDX in `apps/docs/pages/` and shared UI assets under `apps/docs/components/`. Shared tooling (e.g., `biome.jsonc`, `Makefile`, `README.md`) lives at the repo root.

## Build, Test, and Development Commands
- `cargo build --workspace` compiles controller and worker crates together.
- `make up-dev` starts PostgreSQL, runs SQLx migrations, and boots the controller with live reloading.
- `make test` loads `.env` and runs `cargo nextest run`.
- `make test-with-codecov` mirrors CI coverage via `cargo llvm-cov nextest`.
- `npm install && npm run dev --workspace=github-apps` boots the GitHub App sandbox; use `npm test --workspace=github-apps` for Vitest.
- `cargo fmt --all` and `cargo clippy --workspace --all-targets` enforce style and lint rules.

## Coding Style & Naming Conventions
- Rust modules follow Rust 2021 defaults: four-space indentation, `snake_case` filenames (e.g., `job_runner.rs`), and modules mirroring directory names.
- TypeScript in `github-apps` uses Biome for formatting and linting; prefer `camelCase` for variables and `PascalCase` React components.
- MDX documents should pass Biome lint checks; keep frontmatter minimal and group screenshots in `/apps/docs/public/`.
- Treat clippy warnings as errors via `cargo clippy -- -D warnings`.

## Testing Guidelines
- Add controller integration cases in `packages/openci-controller/tests/`; scope unit tests beside source files with `#[cfg(test)]`.
- Seed DB-dependent tests with fixtures and wrap them in SQLx transactions for isolation.
- Run Vitest suites (`npm test --workspace=github-apps`) against webhook handlers, using `test/__fixtures__/` payloads.
- Before PRs, execute `make test-with-codecov` to confirm coverage parity with CI.

## Commit & Pull Request Guidelines
- Write imperative commit titles under ~60 characters, appending issue numbers like `Add workflow job endpoint (#432)`.
- PRs should summarize scope, list verification steps (`make test`, `cargo fmt`, `npm test --workspace=github-apps`), flag schema or migration changes, and attach UI screenshots when docs change.
- Request reviewers from the appropriate domain (controller, worker, GitHub App) and link related RFCs or issues.

## Security & Configuration Tips
- Store `APP_ID`, `PRIVATE_KEY`, and database credentials in `.env` or the deployment secret manager; never commit secrets.
- Validate GitHub webhook signatures using `X-Hub-Signature-256` and log delivery IDs for replay handling.
- Rotate GitHub App tokens proactively; the worker should request fresh runner registration tokens before provisioning each job.

## Misc
Always reply in Japanese

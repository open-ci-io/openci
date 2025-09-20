# Repository Guidelines

## Project Structure & Module Organization
- `packages/openci-controller/` hosts the Axum-based API; use `src/` for handlers and services, `migrations/` for SQLx migrations, `fixtures/` for test data, and `tests/` for integration suites.
- `packages/openci-worker/` contains the worker CLI entry point (`src/main.rs`) that orchestrates build execution.
- `apps/docs/` holds the public documentation site; update MDX and UI assets here.
- Shared tooling lives at the repository root (`biome.jsonc`, `Makefile`, `README.md`) for cross-package conventions.

## Build, Test, and Development Commands
- `cargo build --workspace` compiles the controller and worker crates together.
- `make up-dev` provisions PostgreSQL, applies SQLx migrations, and runs the controller locally.
- `make test` loads `.env` and executes `cargo nextest run` for the controller test suite.
- `make test-with-codecov` runs coverage via `cargo llvm-cov nextest` to mirror CI expectations.
- `cargo fmt --all` and `cargo clippy --workspace --all-targets` format and lint Rust sources before committing.

## Coding Style & Naming Conventions
- Follow Rust 2021 defaults: four-space indentation and `snake_case` for modules, functions, and file names (e.g., `src/services/job_runner.rs`).
- Group feature flags and shared helpers under dedicated modules; match module names to their directory paths.
- Run `cargo fmt` prior to each commit and treat clippy warnings as errors (`cargo clippy -- -D warnings`).
- For documentation UI changes, obey Biome lint settings in `biome.jsonc` when editing TypeScript or MDX within `apps/docs`.

## Testing Guidelines
- Place integration cases in `packages/openci-controller/tests/`; keep unit tests alongside source files using `#[cfg(test)] mod tests` blocks.
- Choose descriptive test names such as `handles_duplicate_delivery_id` to clarify intent and failure output.
- Seed database-dependent tests through `fixtures/` and rely on SQLx test transactions for isolation.
- Capture coverage deltas locally with `make test-with-codecov` before opening pull requests.

## Commit & Pull Request Guidelines
- Write imperative, concise commit titles (~60 chars) and append related issue numbers in parentheses, e.g., `Add build job retrieval endpoint (#432)`.
- Squash WIP commits and ensure diffs stay clean after running formatters and linters.
- Pull requests must describe scope, list verification steps (`make test`, `cargo fmt`), flag schema or migration changes, and attach screenshots for docs or UI tweaks.
- Link GitHub issues or RFCs and request review from domain owners (controller vs. worker) as needed.

Reply in Japanese

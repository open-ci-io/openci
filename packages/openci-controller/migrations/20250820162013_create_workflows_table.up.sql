CREATE TABLE
workflows
(
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    base_branch VARCHAR(255) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    github_trigger_type VARCHAR(50) NOT NULL CHECK (
        github_trigger_type IN ('push', 'pull_request')
    ),
    github_repository_id INTEGER NOT NULL REFERENCES github_repositories (
        id
    ) ON DELETE CASCADE
);

CREATE TABLE
workflow_steps
(
    id SERIAL PRIMARY KEY,
    workflow_id INTEGER NOT NULL REFERENCES workflows (id) ON DELETE CASCADE,
    step_order INTEGER NOT NULL,
    name VARCHAR(255) NOT NULL,
    command VARCHAR(255) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (workflow_id, step_order)
);

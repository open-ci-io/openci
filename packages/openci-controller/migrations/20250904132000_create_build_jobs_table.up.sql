CREATE TABLE build_jobs
(
    id                 SERIAL PRIMARY KEY,
    workflow_id        INTEGER     NOT NULL REFERENCES workflows (id) ON DELETE CASCADE,
    repository_id      INTEGER     NOT NULL REFERENCES github_repositories (id) ON DELETE CASCADE,
    status             VARCHAR(32) NOT NULL DEFAULT 'queued' CHECK (status IN (
                                                                               'queued', 'running', 'success', 'failed',
                                                                               'cancelled',
                                                                               'timed_out', 'skipped'
        )),
    commit_sha         VARCHAR(64) NOT NULL,
    github_delivery_id VARCHAR(64) NOT NULL,
    created_at         TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at         TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (github_delivery_id, workflow_id)
);

CREATE INDEX idx_build_jobs_workflow_id ON build_jobs (workflow_id);
CREATE INDEX idx_build_jobs_repository_id ON build_jobs (repository_id);
CREATE INDEX idx_build_jobs_status ON build_jobs (status);
CREATE INDEX idx_build_jobs_commit_sha ON build_jobs (commit_sha);


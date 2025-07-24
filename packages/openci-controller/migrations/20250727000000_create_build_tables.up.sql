CREATE TABLE repositories (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    github_id BIGINT NOT NULL UNIQUE,
    full_name VARCHAR(255) NOT NULL UNIQUE,
    name VARCHAR(255) NOT NULL,
    owner VARCHAR(255) NOT NULL,
    node_id VARCHAR(255),
    private BOOLEAN NOT NULL DEFAULT false,
    default_branch VARCHAR(255) NOT NULL DEFAULT 'main',
    webhook_secret VARCHAR(255),
    installation_id BIGINT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE TABLE workflows (
    id SERIAL PRIMARY KEY,
    repository_id INTEGER NOT NULL REFERENCES repositories(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    current_working_directory VARCHAR(255) NOT NULL DEFAULT '',
    flutter_config JSONB NOT NULL,
    trigger_type VARCHAR(50) NOT NULL CHECK (trigger_type IN ('push', 'pullRequest')),
    base_branch VARCHAR(255) NOT NULL DEFAULT 'main',
    owners JSONB NOT NULL,
    steps JSONB NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE TABLE build_jobs (
    id SERIAL PRIMARY KEY,
    workflow_id INTEGER REFERENCES workflows(id) ON DELETE
    SET NULL,
        repository_id INTEGER NOT NULL REFERENCES repositories(id) ON DELETE CASCADE,
        workflow_name VARCHAR(255),
        workflow_config JSONB,
        build_status VARCHAR(50) NOT NULL DEFAULT 'queued' CHECK (
            build_status IN (
                'queued',
                'inProgress',
                'failure',
                'success',
                'cancelled'
            )
        ),
        commit_sha VARCHAR(40) NOT NULL,
        build_branch VARCHAR(255) NOT NULL,
        base_branch VARCHAR(255) NOT NULL,
        commit_message TEXT,
        commit_author_name VARCHAR(255),
        commit_author_email VARCHAR(255),
        pr_number INTEGER,
        pr_title TEXT,
        github_check_run_id BIGINT NOT NULL,
        github_app_id INTEGER NOT NULL,
        github_installation_id BIGINT NOT NULL,
        started_at TIMESTAMPTZ,
        finished_at TIMESTAMPTZ,
        worker_id VARCHAR(255),
        exit_code INTEGER,
        created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE TABLE command_logs (
    id SERIAL PRIMARY KEY,
    build_job_id INTEGER NOT NULL REFERENCES build_jobs(id) ON DELETE CASCADE,
    command TEXT NOT NULL,
    log_stdout TEXT NOT NULL DEFAULT '',
    log_stderr TEXT NOT NULL DEFAULT '',
    exit_code INTEGER NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE TABLE github_events (
    id SERIAL PRIMARY KEY,
    repository_id INTEGER REFERENCES repositories(id) ON DELETE CASCADE,
    event_type VARCHAR(50) NOT NULL,
    action VARCHAR(50),
    delivery_id VARCHAR(255) NOT NULL UNIQUE,
    payload JSONB NOT NULL,
    processed BOOLEAN NOT NULL DEFAULT FALSE,
    build_job_id INTEGER REFERENCES build_jobs(id),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE TABLE secrets (
    id SERIAL PRIMARY KEY,
    key VARCHAR(255) NOT NULL,
    encrypted_value TEXT NOT NULL,
    owners JSONB NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(key, owners) -- Assuming a key should be unique per owner set for better integrity
);
CREATE INDEX idx_repositories_user_id ON repositories(user_id);
CREATE INDEX idx_workflows_repository_id ON workflows(repository_id);
CREATE INDEX idx_build_jobs_workflow_id ON build_jobs(workflow_id)
WHERE workflow_id IS NOT NULL;
CREATE INDEX idx_build_jobs_repository_id ON build_jobs(repository_id);
CREATE INDEX idx_build_jobs_build_status ON build_jobs(build_status);
CREATE INDEX idx_command_logs_build_job_id ON command_logs(build_job_id);
CREATE INDEX idx_github_events_processed ON github_events(processed);
CREATE OR REPLACE FUNCTION update_updated_at_column() RETURNS TRIGGER AS $$ BEGIN NEW.updated_at = NOW();
RETURN NEW;
END;
$$ language 'plpgsql';
CREATE TRIGGER update_repositories_updated_at BEFORE
UPDATE ON repositories FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_workflows_updated_at BEFORE
UPDATE ON workflows FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_secrets_updated_at BEFORE
UPDATE ON secrets FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
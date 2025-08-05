INSERT INTO repositories (
        user_id,
        github_id,
        full_name,
        name,
        owner,
        default_branch
    )
SELECT u.id,
    123456 + ROW_NUMBER() OVER (
        ORDER BY u.id
    ),
    'test-org/test-repo-' || u.id,
    'test-repo-' || u.id,
    'test-org',
    'main'
FROM users u
LIMIT 1;
INSERT INTO build_jobs (
        workflow_id,
        repository_id,
        workflow_name,
        build_status,
        commit_sha,
        build_branch,
        base_branch,
        commit_message,
        commit_author_name,
        commit_author_email,
        pr_number,
        pr_title,
        github_check_run_id,
        github_app_id,
        github_installation_id,
        started_at,
        finished_at,
        exit_code
    )
SELECT NULL,
    r.id,
    'Test Workflow',
    status.value,
    'abc123def456' || status.idx,
    CASE
        WHEN status.idx % 2 = 0 THEN 'feature/test-' || status.idx
        ELSE 'main'
    END,
    'main',
    'Test commit message ' || status.idx,
    'Test Author',
    'test@example.com',
    CASE
        WHEN status.idx % 3 = 0 THEN status.idx
        ELSE NULL
    END,
    CASE
        WHEN status.idx % 3 = 0 THEN 'Test PR ' || status.idx
        ELSE NULL
    END,
    1000000 + status.idx,
    12345,
    67890,
    CASE
        WHEN status.value IN ('inProgress', 'success', 'failure', 'cancelled') THEN NOW() - INTERVAL '1 hour'
        ELSE NULL
    END,
    CASE
        WHEN status.value IN ('success', 'failure', 'cancelled') THEN NOW() - INTERVAL '30 minutes'
        ELSE NULL
    END,
    CASE
        WHEN status.value = 'success' THEN 0
        WHEN status.value = 'failure' THEN 1
        ELSE NULL
    END
FROM repositories r
    CROSS JOIN (
        SELECT 'queued' as value,
            1 as idx
        UNION ALL
        SELECT 'inProgress',
            2
        UNION ALL
        SELECT 'success',
            3
        UNION ALL
        SELECT 'failure',
            4
        UNION ALL
        SELECT 'cancelled',
            5
    ) status;
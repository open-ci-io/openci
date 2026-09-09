GenuineCI command-line tools.

Run `genuineci dev start` from the OpenCI checkout to start local services and the
Mac Orchard worker. The existing Docker Compose credentials and `base-macos` VM
must be configured first.

To also queue one build job, add `--seed` and specify the target repository,
full commit SHA, Dart workflow, and GitHub App installation ID:

```sh
genuineci dev start --seed \
  --repo=openci-org/openci \
  --commit-sha='COMMIT_SHA' \
  --workflow='WORKFLOW.dart' \
  --installation-id='INSTALLATION_ID' \
  --branch=develop
```

Replace the uppercase placeholders with real values. The commit must be pushed to
GitHub and accessible to the configured GitHub App. `--workflow` is relative to
`genuine_ci/` at that commit; for `genuine_ci/worker_smoke.dart`, pass
`--workflow=worker_smoke.dart`. `--branch` records the branch name and defaults to
`main`; checkout uses `--commit-sha`.

This submits one job directly through the seed API using the local `test-team`
and `macos-latest` runner. It exercises the build job worker; webhook reception
and planning are separate. Options for a job require `--seed`, and missing or
invalid values exit with code 64 before services start.

Press Ctrl+C to stop the Mac Orchard worker. Docker containers keep running.

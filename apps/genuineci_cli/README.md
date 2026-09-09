# GenuineCI CLI

Start the local Docker services and foreground Orchard worker from the OpenCI checkout:

```sh
genuineci dev start
```

To submit one real build job, provide all seed options:

```sh
genuineci dev start --seed \
  --seed-repository=OWNER/REPO \
  --seed-sha=FULL_40_CHARACTER_COMMIT_SHA \
  --seed-workflow=worker_smoke.dart \
  --seed-installation-id=GITHUB_APP_INSTALLATION_ID \
  --seed-branch=BRANCH
```

The workflow must exist under `genuine_ci/` at that pushed commit. The configured
GitHub App must have access to the repository. Existing Compose credentials and
local Tart/Orchard setup are required. Each invocation with `--seed` creates a new
job in the local test team; it does not send a webhook or exercise the planner.
Ctrl+C stops the foreground worker; Docker services remain running.

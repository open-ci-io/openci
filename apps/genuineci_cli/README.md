GenuineCI command-line tools.

Run `genuineci dev start` from the OpenCI checkout to start local services and the
Mac Orchard worker. The existing Docker Compose credentials and `base-macos` VM
must be configured first.

To also queue the default smoke-test build job:

```sh
genuineci dev start --seed
```

The server seeds `test-team` and one `macos-latest` job for
`openci-org/openci`'s `genuine_ci/worker_smoke.dart`, pinned to commit
`b6ab255a62ca0c5216ec67c4b251c7b1732bd290` on `test/build-job-worker-smoke`.
The workflow checks macOS and Flutter versions and runs the worker's unit tests.
It uses this fixed fixture, not uncommitted files in your local checkout.

The server resolves the installation ID using the GitHub App already configured
in Docker Compose. That App must have access to `openci-org/openci`.
Webhook reception and planning are separate from this smoke test.

Press Ctrl+C to stop the Mac Orchard worker. Docker containers keep running.

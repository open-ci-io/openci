# GenuineCI server

Serverpod `4.0.0-rc.2` API. The first endpoint returns `Hello world` and runs
without PostgreSQL or Redis.

## Run locally

From the repository root:

```sh
flutter pub get --enforce-lockfile
cd apps/genuineci_server
dart run bin/main.dart
```

In another terminal, from the repository root:

```sh
dart run packages/genuineci_api_client/example/hello.dart
# Hello world
```

The generated client calls `client.greeting.hello()` at `http://localhost:8180/`.
Stop the server with Ctrl+C.

## Test

From `apps/genuineci_server`:

```sh
dart test integration_test
```

The test starts the API on an available port and calls it over HTTP using the
generated client.

## Regenerate the API client

From the repository root:

```sh
dart pub global activate serverpod_cli 4.0.0-rc.2
dart pub global run serverpod_cli:serverpod_cli --no-analytics --no-interactive generate --directory apps/genuineci_server --force
```

Commit the generated server and client files together with endpoint changes.
CI checks generation, formatting, static analysis, and the HTTP integration test.

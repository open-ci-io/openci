# PostgreSQL tests

These tests use PostgreSQL 16, matching `docker-compose.yml`. Each test creates
and removes its own schema. Use a disposable database with permission to create
schemas.

Start a local test database (the password below is only a test fixture):

```sh
docker run --detach --rm --name openci-server-test-db \
  --env POSTGRES_DB=openci_test \
  --env POSTGRES_USER=openci_test \
  --env POSTGRES_PASSWORD=openci_test \
  --publish 127.0.0.1:55432:5432 postgres:16-alpine
docker exec openci-server-test-db pg_isready -U openci_test -d openci_test
```

After PostgreSQL reports that it accepts connections, run from
`apps/openci_server`:

```sh
export TEST_DATABASE_URL='postgres://openci_test:openci_test@127.0.0.1:55432/openci_test?sslmode=disable'
dart test integration_test
```

To collect unit and integration coverage, including Dart Frog's `routes/`, use
the same commands as CI:

```sh
rm -rf coverage/raw
dart test test integration_test --coverage=coverage/raw
dart run coverage:format_coverage --lcov --in=coverage/raw --out=coverage/lcov.info --report-on=lib --report-on=routes --base-directory=.
```

Stop the disposable database when finished:

```sh
docker stop openci-server-test-db
```

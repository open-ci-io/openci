FROM dart:3.12.2 AS build

WORKDIR /app
COPY pubspec.lock ./
COPY packages/openci_shared/pubspec.yaml ./packages/openci_shared/
COPY packages/openci_shared/lib/ ./packages/openci_shared/lib/
COPY apps/build_job_worker/pubspec.yaml ./apps/build_job_worker/
COPY apps/build_job_worker/lib/ ./apps/build_job_worker/lib/
COPY apps/build_job_worker/bin/ ./apps/build_job_worker/bin/

# Resolve only the worker and its shared package as a Dart workspace.
RUN printf 'name: worker_container\nenvironment:\n  sdk: ^3.12.2\nworkspace:\n  - packages/openci_shared\n  - apps/build_job_worker\n' > pubspec.yaml
RUN dart pub get
RUN dart compile exe apps/build_job_worker/bin/main.dart -o /app/worker

FROM scratch
COPY --from=build /runtime/ /
COPY --from=build /app/worker /app/worker
USER 10001:10001
ENTRYPOINT ["/app/worker"]

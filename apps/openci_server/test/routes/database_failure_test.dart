import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_test/dart_frog_test.dart';
import 'package:openci_server/build_job/build_job_mapper.dart';
import 'package:openci_server/database.dart';
import 'package:openci_shared/openci_shared.dart';
import 'package:test/test.dart';

import '../../routes/builds/[id]/index.dart' as build;
import '../../routes/builds/[id]/runs/[runId]/index.dart' as run;
import '../../routes/builds/[id]/runs/index.dart' as runs;
import '../../routes/builds/index.dart' as builds;
import '../../routes/devices/[id].dart' as device;
import '../../routes/devices/index.dart' as devices;
import '../../routes/teams/[id]/index.dart' as team;
import '../../routes/teams/[id]/github/repositories/index.dart' as repositories;
import '../../routes/teams/[id]/github/repositories/[owner]/[repo]/branches.dart'
    as branches;
import '../../routes/teams/[id]/repositories/[repo]/genuine-ci-files.dart'
    as workflow_files;
import '../../routes/teams/[id]/udid-requests.dart' as udid_requests;
import '../../routes/teams/index.dart' as teams;
import '../../routes/workers/heartbeat.dart' as heartbeat;
import '../../routes/workers/index.dart' as workers;

class _UnavailableDatabase implements AppDatabase {
  var accesses = 0;

  @override
  dynamic noSuchMethod(Invocation invocation) {
    accesses++;
    throw StateError('private database connection detail');
  }
}

class _Endpoint {
  const _Endpoint(
    this.path,
    this.method,
    this.handle, {
    this.body = '{}',
    this.uid = 'user-1',
  });

  final String path;
  final HttpMethod method;
  final FutureOr<Response> Function(RequestContext) handle;
  final String body;
  final String uid;
}

void main() {
  final job = DriftBuildJob(
    id: 'job-1',
    status: BuildJobStatus.QUEUED,
    owner: 'owner',
    repo: 'repo',
    workflowName: 'build',
    workflowFileName: 'build.dart',
    teamId: 'team-1',
    createdAt: DateTime.utc(2026),
    updatedAt: DateTime.utc(2026),
  );
  final endpoints = [
    _Endpoint('/teams', HttpMethod.get, teams.onRequest),
    _Endpoint(
      '/teams',
      HttpMethod.post,
      teams.onRequest,
      body: '{"name":"New team"}',
    ),
    _Endpoint(
      '/teams/team-1',
      HttpMethod.patch,
      (c) => team.onRequest(c, 'team-1'),
    ),
    _Endpoint(
      '/teams/team-1',
      HttpMethod.delete,
      (c) => team.onRequest(c, 'team-1'),
    ),
    _Endpoint('/builds?teamId=team-1', HttpMethod.get, builds.onRequest),
    _Endpoint(
      '/builds',
      HttpMethod.post,
      builds.onRequest,
      body: jsonEncode(job.toShared().toJson()),
      uid: 'system-job-processor',
    ),
    _Endpoint(
      '/builds/job-1',
      HttpMethod.patch,
      (c) => build.onRequest(c, 'job-1'),
    ),
    _Endpoint(
      '/builds/job-1/runs',
      HttpMethod.get,
      (c) => runs.onRequest(c, 'job-1'),
    ),
    _Endpoint(
      '/builds/job-1/runs',
      HttpMethod.post,
      (c) => runs.onRequest(c, 'job-1'),
      body: '{"id":"run-1"}',
    ),
    _Endpoint(
      '/builds/job-1/runs/run-1',
      HttpMethod.get,
      (c) => run.onRequest(c, 'job-1', 'run-1'),
    ),
    _Endpoint(
      '/builds/job-1/runs/run-1',
      HttpMethod.patch,
      (c) => run.onRequest(c, 'job-1', 'run-1'),
      body: '{"status":"completed"}',
    ),
    _Endpoint('/workers', HttpMethod.get, workers.onRequest),
    _Endpoint(
      '/workers/heartbeat',
      HttpMethod.post,
      heartbeat.onRequest,
      body: '{"workerId":"worker-1"}',
    ),
    _Endpoint('/devices', HttpMethod.get, devices.onRequest),
    _Endpoint(
      '/devices/device-1',
      HttpMethod.delete,
      (c) => device.onRequest(c, 'device-1'),
    ),
    _Endpoint(
      '/teams/team-1/github/repositories',
      HttpMethod.get,
      (c) => repositories.onRequest(c, 'team-1'),
    ),
    _Endpoint(
      '/teams/team-1/github/repositories/owner/repo/branches',
      HttpMethod.get,
      (c) => branches.onRequest(c, 'team-1', 'owner', 'repo'),
    ),
    _Endpoint(
      '/teams/team-1/repositories/repo/genuine-ci-files',
      HttpMethod.get,
      (c) => workflow_files.onRequest(c, 'team-1', 'repo'),
    ),
    _Endpoint(
      '/teams/team-1/udid-requests',
      HttpMethod.get,
      (c) => udid_requests.onRequest(c, 'team-1'),
    ),
    _Endpoint(
      '/teams/team-1/udid-requests',
      HttpMethod.post,
      (c) => udid_requests.onRequest(c, 'team-1'),
      body: '{"udid":"device-1"}',
    ),
  ];

  final checkedPaths = <String>{};
  for (final endpoint in endpoints) {
    test(
      '${endpoint.method} ${endpoint.path} hides database failures',
      () async {
        final database = _UnavailableDatabase();
        final context = TestRequestContext(
          path: endpoint.path,
          method: endpoint.method,
          body: endpoint.body,
        );
        context.provide<AppDatabase>(database);
        context.provide<String?>(endpoint.uid);
        context.provide<DriftBuildJob>(job);

        final response = await endpoint.handle(context.context);

        expect(database.accesses, greaterThan(0));
        expect(response.statusCode, HttpStatus.internalServerError);
        expect(await response.json(), {
          'success': false,
          'error': 'Internal server error',
        });
      },
    );

    if (checkedPaths.add(Uri.parse(endpoint.path).path)) {
      test(
        'PUT ${endpoint.path} is rejected before accessing the database',
        () async {
          final database = _UnavailableDatabase();
          final context = TestRequestContext(
            path: endpoint.path,
            method: HttpMethod.put,
          );
          context.provide<AppDatabase>(database);

          final response = await endpoint.handle(context.context);

          expect(response.statusCode, HttpStatus.methodNotAllowed);
          expect(database.accesses, 0);
        },
      );
    }
  }
}

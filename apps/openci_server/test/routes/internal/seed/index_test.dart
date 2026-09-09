import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_test/dart_frog_test.dart';
import 'package:drift/native.dart';
import 'package:openci_server/database.dart';
import 'package:openci_shared/openci_shared.dart';
import 'package:test/test.dart';

import '../../../../routes/internal/seed/index.dart' as route;

void main() {
  late AppDatabase db;

  setUp(() => db = AppDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());

  Future<Response> seed(Map<String, Object?> body) {
    final context = TestRequestContext(
      path: '/internal/seed',
      method: HttpMethod.post,
      body: jsonEncode(body),
    )..provide<AppDatabase>(db);
    return route.onRequest(context.context);
  }

  test(
    'creates one queued job and associates its installation with the team',
    () async {
      final response = await seed({
        'owner': 'example',
        'repo': 'mobile',
        'commitSha': '0123456789abcdef0123456789abcdef01234567',
        'workflowName': 'checks/smoke.dart',
        'workflowFileName': 'checks/smoke.dart',
        'installationId': '42',
        'branch': 'feature/worker',
      });

      expect(response.statusCode, HttpStatus.ok);
      final body = await response.json() as Map<String, dynamic>;
      expect(body['success'], isTrue);
      final jobs = await db.buildJobDao.getQueuedJobs();
      expect(jobs, hasLength(1));
      final job = jobs.single;
      expect(job.id, body['jobId']);
      expect(job.status, BuildJobStatus.QUEUED);
      expect(job.owner, 'example');
      expect(job.repo, 'mobile');
      expect(job.commitSha, '0123456789abcdef0123456789abcdef01234567');
      expect(job.workflowName, 'checks/smoke.dart');
      expect(job.workflowFileName, 'checks/smoke.dart');
      expect(job.branch, 'feature/worker');
      expect(job.installationId, '42');
      expect(job.runsOn, 'macos-latest');
      expect((await db.teamDao.getTeam(job.teamId!))!.installationIds, [42]);
    },
  );

  test('adds the installation without replacing an existing team', () async {
    await db.seedDao.ensureTestTeam(installationId: 11);

    final response = await seed({'installationId': '42'});

    expect(response.statusCode, HttpStatus.ok);
    expect((await db.teamDao.getTeam('test-team'))!.installationIds, [11, 42]);
    expect((await db.buildJobDao.getQueuedJobs()).single.installationId, '42');
  });

  test(
    'preserves the installation default for existing seed callers',
    () async {
      final response = await seed({});

      expect(response.statusCode, HttpStatus.ok);
      expect((await db.teamDao.getTeam('test-team'))!.installationIds, [
        12345678,
      ]);
      expect(
        (await db.buildJobDao.getQueuedJobs()).single.installationId,
        '12345678',
      );
    },
  );

  for (final installationId in ['', 'abc', '0', '-1']) {
    test(
      'rejects installation ID "$installationId" before writing data',
      () async {
        final response = await seed({'installationId': installationId});

        expect(response.statusCode, HttpStatus.badRequest);
        expect((await response.json())['success'], isFalse);
        expect(await db.teamDao.getTeam('test-team'), isNull);
        expect(await db.buildJobDao.getQueuedJobs(), isEmpty);
      },
    );
  }
}

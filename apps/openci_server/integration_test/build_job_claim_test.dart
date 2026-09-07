import 'dart:async';
import 'dart:io';

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift_postgres/drift_postgres.dart';
import 'package:openci_server/database.dart';
import 'package:openci_shared/openci_shared.dart';
import 'package:postgres/postgres.dart' as pg;
import 'package:test/test.dart';

void main() {
  final databaseUrl = Platform.environment['TEST_DATABASE_URL'];
  if (databaseUrl == null || databaseUrl.isEmpty) {
    throw StateError('Set TEST_DATABASE_URL to run the PostgreSQL tests.');
  }

  late pg.Connection admin;
  late String schema;
  late AppDatabase db;

  setUpAll(() {
    // Each worker deliberately uses its own PostgreSQL connection.
    final previous = driftRuntimeOptions.dontWarnAboutMultipleDatabases;
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    addTearDown(
      () => driftRuntimeOptions.dontWarnAboutMultipleDatabases = previous,
    );
  });

  Future<AppDatabase> openDatabase() async {
    final connection = await pg.Connection.openFromUrl(databaseUrl);
    addTearDown(connection.close);
    await connection.execute('SET search_path TO "$schema"');
    final database = AppDatabase(PgDatabase.opened(connection));
    addTearDown(database.close);
    await database.customSelect('SELECT 1').get();
    return database;
  }

  setUp(() async {
    admin = await pg.Connection.openFromUrl(databaseUrl);
    addTearDown(admin.close);
    schema = 'claim_test_${DateTime.now().microsecondsSinceEpoch}';
    await admin.execute('CREATE SCHEMA "$schema"');
    addTearDown(() => admin.execute('DROP SCHEMA "$schema" CASCADE'));
    await admin.execute('SET search_path TO "$schema"');
    db = await openDatabase();
  });

  group('BuildJobDao.claimNextJob on PostgreSQL', () {
    test('returns null when no jobs are queued', () async {
      expect(await db.buildJobDao.claimNextJob(), isNull);
      for (final status in BuildJobStatus.values.where(
        (s) => s != BuildJobStatus.QUEUED,
      )) {
        await db.buildJobDao.insertBuildJob(_job(status.name, status: status));
      }

      expect(await db.buildJobDao.claimNextJob(), isNull);
    });

    test('claims the oldest job and persists the worker assignment', () async {
      final oldest = _job('oldest');
      await db.buildJobDao.insertBuildJob(_job('newer', minute: 1));
      await db.buildJobDao.insertBuildJob(oldest);
      final before = DateTime.now().toUtc();

      final claimed = (await db.buildJobDao.claimNextJob(
        vmName: 'vm-a',
        workerHost: 'host-a',
      ))!;

      expect(claimed.id, 'oldest');
      expect(claimed.status, BuildJobStatus.IN_PROGRESS);
      expect(claimed.vmName, 'vm-a');
      expect(claimed.workerHost, 'host-a');
      expect(claimed.createdAt.toUtc(), oldest.createdAt);
      expect(claimed.updatedAt.isBefore(before), isFalse);
      final stored = (await db.buildJobDao.getBuildJob('oldest'))!;
      expect(stored.status, claimed.status);
      expect(stored.vmName, claimed.vmName);
      expect(stored.workerHost, claimed.workerHost);
      expect((await db.buildJobDao.getQueuedJobs()).single.id, 'newer');
    });

    test('counts only active jobs assigned to the requested host', () async {
      await db.buildJobDao.insertBuildJob(
        _job(
          'active',
          status: BuildJobStatus.IN_PROGRESS,
          workerHost: 'host-a',
        ),
      );
      await db.buildJobDao.insertBuildJob(
        _job('completed', status: BuildJobStatus.SUCCESS, workerHost: 'host-b'),
      );
      await db.buildJobDao.insertBuildJob(_job('queued'));

      expect(
        await db.buildJobDao.claimNextJob(
          workerHost: 'host-a',
          maxConcurrentJobs: 1,
        ),
        isNull,
      );
      expect(
        (await db.buildJobDao.getBuildJob('queued'))!.status,
        BuildJobStatus.QUEUED,
      );
      expect(
        (await db.buildJobDao.claimNextJob(
          workerHost: 'host-b',
          maxConcurrentJobs: 1,
        ))?.id,
        'queued',
      );
    });

    test('claims without a host or concurrency limit', () async {
      await db.buildJobDao.insertBuildJob(_job('queued'));

      final claimed = (await db.buildJobDao.claimNextJob())!;

      expect(claimed.id, 'queued');
      expect(claimed.vmName, isNull);
      expect(claimed.workerHost, isNull);
      expect(await db.buildJobDao.claimNextJob(), isNull);
    });

    test('skips a locked job and leaves it available after rollback', () async {
      await db.buildJobDao.insertBuildJob(_job('locked'));
      await db.buildJobDao.insertBuildJob(_job('available', minute: 1));
      await admin.execute('BEGIN');
      try {
        await admin.execute(
          "SELECT * FROM build_jobs WHERE id = 'locked' FOR UPDATE",
        );

        expect((await db.buildJobDao.claimNextJob())?.id, 'available');
        expect(await db.buildJobDao.claimNextJob(), isNull);
      } finally {
        await admin.execute('ROLLBACK');
      }

      expect((await db.buildJobDao.claimNextJob())?.id, 'locked');
    });

    test('independent workers cannot claim the same job', () async {
      await db.buildJobDao.insertBuildJob(_job('only-job'));
      final other = await openDatabase();

      final results = await Future.wait([
        db.buildJobDao.claimNextJob(workerHost: 'host-a'),
        other.buildJobDao.claimNextJob(workerHost: 'host-b'),
      ]);

      expect(results.whereType<DriftBuildJob>().map((job) => job.id), [
        'only-job',
      ]);
      expect(results.where((job) => job == null), hasLength(1));
      expect(
        (await db.buildJobDao.getBuildJob('only-job'))!.status,
        BuildJobStatus.IN_PROGRESS,
      );
    });

    test(
      'simultaneous claims respect the concurrency limit for one host',
      () async {
        await db.buildJobDao.insertBuildJob(_job('first'));
        await db.buildJobDao.insertBuildJob(_job('second', minute: 1));
        final other = await openDatabase();
        final workerPids = [
          (await db.customSelect('SELECT pg_backend_pid() AS pid').getSingle())
              .read<int>('pid'),
          (await other
                  .customSelect('SELECT pg_backend_pid() AS pid')
                  .getSingle())
              .read<int>('pid'),
        ];

        // Hold updates until both claim transactions have reached a lock. This
        // reproduces overlapping claims without relying on scheduler timing.
        final gate = DateTime.now().microsecondsSinceEpoch;
        await admin.execute('''
        CREATE FUNCTION hold_claim_update() RETURNS trigger AS \$\$
        BEGIN
          PERFORM pg_advisory_xact_lock($gate);
          RETURN NEW;
        END;
        \$\$ LANGUAGE plpgsql
      ''');
        await admin.execute('''
        CREATE TRIGGER hold_claim_update BEFORE UPDATE ON build_jobs
        FOR EACH ROW EXECUTE FUNCTION hold_claim_update()
      ''');
        await admin.execute('SELECT pg_advisory_lock($gate)');
        final claims = Future.wait([
          db.buildJobDao.claimNextJob(
            workerHost: 'shared-host',
            maxConcurrentJobs: 1,
          ),
          other.buildJobDao.claimNextJob(
            workerHost: 'shared-host',
            maxConcurrentJobs: 1,
          ),
        ]);
        // Register a listener immediately so setup failures cannot leave an
        // unhandled asynchronous error while the gate is being released.
        unawaited(
          claims.then<void>((_) {}, onError: (Object _, StackTrace _) {}),
        );
        try {
          await _waitForBlockedWorkers(admin, workerPids);
        } finally {
          await admin.execute('SELECT pg_advisory_unlock($gate)');
        }

        final results = await claims;
        expect(results.whereType<DriftBuildJob>(), hasLength(1));
        expect((await db.buildJobDao.getQueuedJobs()).map((job) => job.id), [
          'second',
        ]);
      },
    );
  });
}

Future<void> _waitForBlockedWorkers(pg.Connection admin, List<int> pids) async {
  final deadline = DateTime.now().add(const Duration(seconds: 5));
  while (DateTime.now().isBefore(deadline)) {
    final result = await admin.execute('''
      SELECT COUNT(*) FROM pg_stat_activity
      WHERE pid IN (${pids.join(',')}) AND wait_event_type = 'Lock'
    ''');
    if (result.single.single == pids.length) return;
    await Future<void>.delayed(const Duration(milliseconds: 10));
  }
  fail('Both claim transactions did not reach a lock in time.');
}

DriftBuildJob _job(
  String id, {
  BuildJobStatus status = BuildJobStatus.QUEUED,
  String? workerHost,
  int minute = 0,
}) => DriftBuildJob(
  id: id,
  status: status,
  owner: 'openci-org',
  repo: 'openci',
  workflowName: 'CI',
  workflowFileName: 'ci.dart',
  workerHost: workerHost,
  createdAt: DateTime.utc(2026, 9, 1, 0, minute),
  updatedAt: DateTime.utc(2026, 9, 1, 0, minute),
);

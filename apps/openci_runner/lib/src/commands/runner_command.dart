import 'dart:async';

import 'package:args/command_runner.dart';
import 'package:dart_firebase_admin/firestore.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:openci_models/openci_models.dart';
import 'package:openci_runner/src/features/clone_vm.dart';
import 'package:openci_runner/src/features/get_build_jobs.dart';
import 'package:openci_runner/src/features/get_github_access_token.dart';
import 'package:openci_runner/src/features/get_workflow.dart';
import 'package:openci_runner/src/features/run_vm.dart';
import 'package:openci_runner/src/features/update_build_status.dart';
import 'package:openci_runner/src/features/vm_name.dart';
import 'package:openci_runner/src/firebase/firebase_admin.dart';
import 'package:openci_runner/src/features/get_vm_ip.dart';

/// {@template sample_command}
///
/// `openci_runner sample`
/// A [Command] to exemplify a sub command
/// {@endtemplate}
class RunnerCommand extends Command<int> {
  /// {@macro sample_command}
  RunnerCommand({
    required Logger logger,
  }) : _logger = logger {
    argParser.addFlag(
      'cyan',
      abbr: 'c',
      help: 'Prints the same joke, but in cyan',
      negatable: false,
    );
  }

  @override
  String get description => 'OpenCI Runner command';

  @override
  String get name => 'runner';

  final Logger _logger;

  void _loggerWithTimestamp(String message) {
    _logger.info('[${DateTime.now().toIso8601String()}]: $message');
  }

  Future<BuildJob?> _tryGetBuildJob(Firestore firestore) async {
    final buildJob = await getBuildJob(firestore);
    if (buildJob == null) {
      _loggerWithTimestamp(
        'No build jobs found. Waiting 1 second before retrying.',
      );
      await Future<void>.delayed(const Duration(seconds: 1));
    }
    return buildJob;
  }

  @override
  Future<int> run() async {
    final admin = await initializeFirebaseAdminApp(
      'open-ci-release',
      'service_account.json',
    );
    final firestore = Firestore(admin);

    while (true) {
      final buildJob = await _tryGetBuildJob(firestore);
      if (buildJob == null) continue;
      _loggerWithTimestamp('Found ${buildJob.toJson()} build jobs');

      await updateBuildStatus(
        jobId: buildJob.id,
        status: OpenCIGitHubChecksStatus.inProgress,
      );

      await Future<void>.delayed(const Duration(seconds: 100));
      // final workflow = await getWorkflowModel(firestore, buildJob.workflowId);
      // if (workflow == null) {
      //   _loggerWithTimestamp('Workflow not found');
      //   throw Exception('Workflow not found');
      // }
      // final token = await getGithubAccessToken(
      //   buildJob.github.installationId,
      // );

      // final vmName = getVMName();

      // await cloneVM(vmName);
      // unawaited(runVM(vmName));
      // final vmIp = await getVMIp(vmName, _logger);
      // print('VM IP: $vmIp');
    }
  }
}

// ignore_for_file: unnecessary_string_escapes

import 'package:dart_firebase_admin/firestore.dart';
import 'package:dartssh2/dartssh2.dart';
import 'package:runner/src/features/job/domain/job_data.dart';
import 'package:runner/src/features/job/domain/job_data_v2.dart';
import 'package:runner/src/services/build_job/build_common_commands.dart';
import 'package:runner/src/services/build_job/organization/organization_model.dart';
import 'package:runner/src/services/firebase/firestore/firestore_path.dart';
import 'package:runner/src/services/github_service.dart';
import 'package:runner/src/services/shell/ssh_shell_service.dart';
import 'package:runner/src/services/vm_service.dart';

enum ChecksStatus {
  inProgress,
  failure,
  success,
}

class BuildUtilityService {
  BuildUtilityService(
    this._firestore,
    this._vmService,
  );
  final Firestore _firestore;
  final VMService _vmService;

  GitHubService get _gitHubService => GitHubService();

  Future<void> handleJobFailure(
    String jobDocumentId,
    String workingVMName,
  ) async {
    await _vmService.stopVM(workingVMName);
    await _markJobAsFailed(jobDocumentId);
  }

  Future<void> _markJobAsFailed(String jobDocumentId) async {
    await _gitHubService.updateChecksStatus({
      'jobId': jobDocumentId,
      'checksStatus': ChecksStatus.failure.name,
    });
  }

  Future<void> markBuildAsStarted(String jobDocumentId) async {
    print('processing');
    await _gitHubService.updateChecksStatus({
      'jobId': jobDocumentId,
      'checksStatus': ChecksStatus.inProgress.name,
    });
  }

  Future<void> markJobAsSuccess(
    String jobDocumentId,
  ) async {
    await _gitHubService.updateChecksStatus({
      'jobId': jobDocumentId,
      'checksStatus': ChecksStatus.success.name,
    });
  }

  Future<void> importServiceAccountJson(
    String serviceAccountJsonPath,
    SSHShellService sshShellService,
    SSHClient sshClient,
    String jobId,
    String workingVMName,
    String appName,
    String downloadUrl,
  ) async {
    await sshShellService.executeCommand(
      '${BuildCommonCommands.navigateToAppDirectory(appName)} && curl -L -o "service_account.json" "$downloadUrl"',
      sshClient,
      jobId,
      workingVMName,
    );
  }

  Future<void> cloneRepository(
    SSHShellService sshShellService,
    SSHClient sshClient,
    BuildModel buildModel,
    String jobId,
    String workingVMName,
    String installationToken,
  ) async {
    await sshShellService.executeCommand(
      'cd ~/Downloads && git clone -b ${buildModel.branch.buildBranch} https://x-access-token:$installationToken@github.com/${buildModel.github.owner}/${buildModel.github.repositoryName}.git',
      sshClient,
      jobId,
      workingVMName,
    );
  }

  Future<void> incrementBuildNumber(
    String organizationId,
    BuildNumber previousBuildNumber,
    TargetPlatform platform,
  ) async {
    final docRef = _firestore
        .collection(FirestorePath.organizationDomain)
        .doc(organizationId);
    switch (platform) {
      case TargetPlatform.ios:
        await docRef.update({
          'buildNumber.ios': previousBuildNumber.ios + 1,
        });
      case TargetPlatform.android:
        await docRef.update({
          'buildNumber.android': previousBuildNumber.android + 1,
        });
    }
  }

  String get loadZshrc => 'source ~/.zshrc';
}

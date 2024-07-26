// ignore_for_file: unnecessary_string_escapes

import 'package:dartssh2/dartssh2.dart';
import 'package:openci_models/openci_models.dart';
import 'package:runner/src/services/build_job/build_common_commands.dart';
import 'package:runner/src/services/github_service.dart';
import 'package:runner/src/services/shell/ssh_shell_service.dart';
import 'package:signals_core/signals_core.dart';

enum ChecksStatus {
  inProgress,
  failure,
  success,
}

final buildUtilityServiceSignal = signal(BuildUtilityService());

class BuildUtilityService {
  BuildUtilityService();

  GitHubService get _gitHubService => GitHubService();

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
      'cd ~/Downloads && git clone -b ${buildModel.branch.baseBranch} https://x-access-token:$installationToken@github.com/${buildModel.github.owner}/${buildModel.github.repositoryName}.git',
      sshClient,
      jobId,
      workingVMName,
    );
  }

  String get loadZshrc => 'source ~/.zshrc';
}

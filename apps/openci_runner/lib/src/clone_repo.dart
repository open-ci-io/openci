import 'package:dartssh2/dartssh2.dart';
import 'package:openci_models/openci_models.dart';
import 'package:openci_runner/src/log.dart';
import 'package:openci_runner/src/run_command.dart';
import 'package:openci_runner/src/service/github/clone_command.dart';
import 'package:openci_runner/src/service/github/get_github_installation_token.dart';

Future<void> cloneRepo(
  BuildJob buildJob,
  String logId,
  SSHClient client,
  String pem,
) async {
  final repoUrl = buildJob.github.repositoryUrl;
  final token = await getGitHubInstallationToken(
    installationId: buildJob.github.installationId,
    appId: buildJob.github.appId,
    privateKey: pem,
  );
  log('Successfully got GitHub access token: $token', isSuccess: true);
  await runCommand(
    logId: logId,
    client: client,
    command: cloneCommand(repoUrl, buildJob.github.buildBranch, token),
    currentWorkingDirectory: null,
    jobId: buildJob.id,
  );
}

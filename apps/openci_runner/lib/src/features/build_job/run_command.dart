import 'package:runner/src/commands/signals.dart';
import 'package:runner/src/features/build_job/update_checks.dart';

Future<void> executeStepCommands(
  List<String> commands,
  int installationId,
) async {
  final githubAccessToken = await getGithubAccessToken(
    installationId: installationId,
  );
  for (final command in commands) {
    var expandedCommand = command;
    if (command.contains('githubAccessToken')) {
      expandedCommand =
          command.replaceAll(r'${githubAccessToken}', githubAccessToken);
    }
    await sshSignal.executeCommandV2(expandedCommand);
  }
}

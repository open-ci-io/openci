import 'package:dartssh2/dartssh2.dart';
import 'package:runner/src/features/job/domain/job_data.dart';
import 'package:runner/src/services/build_job/build_common_commands.dart';
import 'package:runner/src/services/shell/ssh_shell_service.dart';

class BuildDistributionService {
  BuildDistributionService(
    this._sshShellService,
    this._sshClient,
    this._jobId,
    this._workingVMName,
    this._appName,
  );
  final SSHShellService _sshShellService;
  final SSHClient _sshClient;
  final String _jobId;
  final String _workingVMName;
  final String _appName;

  Future<void> uploadBuildToFirebaseAppDistribution(
    String? firebaseAppId,
    List<String>? testerGroups,
    TargetPlatform platform,
  ) async {
    if (firebaseAppId == null) {
      throw Exception('Firebase App ID is required');
    }
    if (testerGroups == null) {
      throw Exception('tester groups are required');
    }
    String path;
    if (platform == TargetPlatform.android) {
      path = await appBundlePath();
    } else if (platform == TargetPlatform.ios) {
      path = await ipaPath();
    } else {
      throw Exception('Platform is required');
    }

    await _sshShellService.executeCommand(
      """
${BuildCommonCommands.loadZshrc} && ${BuildCommonCommands.navigateToAppDirectory(_appName)};
export GOOGLE_APPLICATION_CREDENTIALS="/Users/admin/Downloads/$_appName/service_account.json";
firebase appdistribution:distribute "$path" --app "$firebaseAppId" --groups "${testerGroups.join(', ')}"; 
""",
      _sshClient,
      _jobId,
      _workingVMName,
    );
  }

  Future<String> appBundlePath() async {
    final result = await _sshShellService.executeCommand(
      'find "/Users/admin/Downloads/$_appName/build/app/outputs/flutter-apk" -type f -name "*.apk"',
      _sshClient,
      _jobId,
      _workingVMName,
    );
    final filePath = result.sessionResult.sessionStdout;
    return filePath.replaceAll('\n', '');
  }

  Future<String> ipaPath() async {
    final result = await _sshShellService.executeCommand(
      'find "/Users/admin/Downloads/$_appName/build/ios/ipa" -type f -name "*.ipa"',
      _sshClient,
      _jobId,
      _workingVMName,
    );
    final filePath = result.sessionResult.sessionStdout;
    return filePath.replaceAll('\n', '');
  }
}

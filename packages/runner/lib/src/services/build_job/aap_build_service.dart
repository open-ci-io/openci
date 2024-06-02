import 'package:dartssh2/dartssh2.dart';
import 'package:runner/src/services/build_job/build_common_commands.dart';
import 'package:runner/src/services/shell/ssh_shell_service.dart';

class AabBuildService {
  AabBuildService(
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

  Future<void> downloadKeyJks(
    String? downloadUrl,
  ) async {
    if (downloadUrl == null) {
      throw Exception('Download URL is required');
    }
    const fileName = 'key.jks';

    await _sshShellService.executeCommand(
      '${BuildCommonCommands.navigateToAppDirectory(_appName)}/android/app && curl -L -o $fileName "$downloadUrl"',
      _sshClient,
      _jobId,
      _workingVMName,
    );
  }

  Future<void> downloadKeyProperties(
    String? downloadUrl,
  ) async {
    if (downloadUrl == null) {
      throw Exception('Download URL is required');
    }
    const fileName = 'key.properties';

    await _sshShellService.executeCommand(
      '${BuildCommonCommands.navigateToAppDirectory(_appName)}/android/ && curl -L -o $fileName "$downloadUrl"',
      _sshClient,
      _jobId,
      _workingVMName,
    );
  }

  Future<void> buildApk(int buildNumber, String flavor) async {
    await _sshShellService.executeCommand(
      '${BuildCommonCommands.loadZshrc} && ${BuildCommonCommands.navigateToAppDirectory(_appName)} && $pathAndroidSDK && flutter clean && flutter pub get && flutter build apk ${_flavorArgument(flavor)} --build-number=$buildNumber;',
      _sshClient,
      _jobId,
      _workingVMName,
    );
  }

  String _flavorArgument(String flavor) {
    var flavorArgument = '';
    if (flavor != 'none') {
      flavorArgument = '--flavor $flavor';
    }
    return flavorArgument;
  }

  Future<void> buildShorebirdAppBundle(
    int buildNumber,
    String? shorebirdToken,
    String flutterVersion,
    List<String>? dartDefines,
    String flavor,
  ) async {
    if (shorebirdToken == null) {
      throw Exception('Shorebird token is required');
    }
    var flutterVersionArgument = '--flutter-version=$flutterVersion';
    if (int.parse(flutterVersion.replaceAll('.', '')) < 3195) {
      flutterVersionArgument = '';
    }
    await _sshShellService.executeCommand(
      '''
${BuildCommonCommands.loadZshrc};
${BuildCommonCommands.navigateToAppDirectory(_appName)};
$pathAndroidSDK;
export SHOREBIRD_TOKEN=$shorebirdToken;
export CI=true;
shorebird release android ${_flavorArgument(flavor)} $flutterVersionArgument -- --build-number=$buildNumber ${BuildCommonCommands.generateDartDefines(dartDefines)}; 

''',
      _sshClient,
      _jobId,
      _workingVMName,
    );
  }

  String get pathAndroidSDK =>
      'export ANDROID_SDK_ROOT=/Users/admin/android-sdk';
}

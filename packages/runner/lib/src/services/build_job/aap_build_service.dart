import 'package:dartssh2/dartssh2.dart';
import 'package:openci_models/openci_models.dart';
import 'package:runner/src/services/build_job/build_common_commands.dart';
import 'package:runner/src/services/build_job/flavor_service.dart';
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
    WorkflowAndroidConfig androidConfig,
  ) async {
    final downloadUrl = androidConfig.jks;
    if (downloadUrl == null) {
      throw Exception('Download URL is required');
    }
    final keyJksName = androidConfig.jksName;
    if (keyJksName == null) {
      throw Exception('Key JKS name is required');
    }
    final jksDirectory = androidConfig.jksDirectory;

    if (jksDirectory == null) {
      throw Exception('Key JKS directory is required');
    }
    final fileName = '$keyJksName.jks';

    await _sshShellService.executeCommand(
      '${BuildCommonCommands.navigateToAppDirectory(_appName)}/$jksDirectory && curl -L -o $fileName "$downloadUrl"',
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

  Future<void> runCustomScripts() async {
    await _sshShellService.executeCommand(
      '''
${BuildCommonCommands.loadZshrc};
cd Downloads/$_appName;
flutter pub cache repair;
flutter clean;
flutter pub get;
''',
      _sshClient,
      _jobId,
      _workingVMName,
    );
  }

  Future<void> buildApk(
    int buildNumber,
    WorkflowFlutterConfig flutterConfig,
  ) async {
    await _sshShellService.executeCommand(
      '${BuildCommonCommands.loadZshrc} && ${BuildCommonCommands.navigateToAppDirectory(_appName)} && $pathAndroidSDK && flutter clean && flutter pub get && flutter build apk ${FlavorService.flavorArgument(flutterConfig)} --build-number=$buildNumber;',
      _sshClient,
      _jobId,
      _workingVMName,
    );
  }

  Future<void> buildShorebirdAppBundle(
    int buildNumber,
    String? shorebirdToken,
    WorkflowFlutterConfig flutterConfig,
  ) async {
    if (shorebirdToken == null) {
      throw Exception('Shorebird token is required');
    }
    var flutterVersionArgument = '--flutter-version=${flutterConfig.version}';
    if (int.parse(flutterConfig.version.replaceAll('.', '')) < 3195) {
      flutterVersionArgument = '';
    }
    await _sshShellService.executeCommand(
      '''
${BuildCommonCommands.loadZshrc};
${BuildCommonCommands.navigateToAppDirectory(_appName)};
$pathAndroidSDK;
export SHOREBIRD_TOKEN=$shorebirdToken;
export CI=true;
shorebird release android ${FlavorService.flavorArgument(flutterConfig)} $flutterVersionArgument -- --build-number=$buildNumber ${BuildCommonCommands.generateDartDefines(flutterConfig.dartDefine)}; 

''',
      _sshClient,
      _jobId,
      _workingVMName,
    );
  }

  String get pathAndroidSDK =>
      'export ANDROID_SDK_ROOT=/Users/admin/android-sdk';
}

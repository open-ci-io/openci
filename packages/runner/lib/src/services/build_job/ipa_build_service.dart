import 'dart:convert';

import 'package:dartssh2/dartssh2.dart';
import 'package:runner/src/services/build_job/build_common_commands.dart';
import 'package:runner/src/services/build_job/flavor_service.dart';
import 'package:runner/src/services/macos/directory_paths.dart';
import 'package:runner/src/services/shell/shell_result.dart';
import 'package:runner/src/services/shell/ssh_shell_service.dart';

import 'package:openci_models/src/workflow/model/workflow_model.dart';

import 'package:http/http.dart' as http;

class IpaBuildService {
  IpaBuildService(
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

  Future<void> downloadExportOptionsPlist(
    String? downloadUrl,
  ) async {
    if (downloadUrl == null) {
      throw Exception('Download URL is required');
    }
    const fileName = 'openCIexportOptions.plist';

    await _sshShellService.executeCommand(
      '${BuildCommonCommands.navigateToAppDirectory(_appName)}/ios/ && curl -L -o $fileName "$downloadUrl"',
      _sshClient,
      _jobId,
      _workingVMName,
    );
  }

  Future<void> createCertificateDirectory() async {
    await _sshShellService.executeCommand(
      'mkdir $certificateDirectory;',
      _sshClient,
      _jobId,
      _workingVMName,
    );
  }

  Future<void> downloadP12Certificate(
    String? downloadUrl,
  ) async {
    if (downloadUrl == null) {
      throw Exception('Download URL is required');
    }
    const fileName = 'build_certificate.p12';
    await _sshShellService.executeCommand(
      'cd $certificateDirectory && curl -L -o $fileName "$downloadUrl"',
      _sshClient,
      _jobId,
      _workingVMName,
    );
  }

  Future<void> downloadMobileProvisioningProfile(
    String? downloadUrl,
  ) async {
    if (downloadUrl == null) {
      throw Exception('Download URL is required');
    }
    const fileName = 'build_pp.mobileprovision';
    await _sshShellService.executeCommand(
      'cd $certificateDirectory && curl -L -o $fileName "$downloadUrl"',
      _sshClient,
      _jobId,
      _workingVMName,
    );
  }

  Future<void> importCertificates() async {
    const icloudKeychainPassword = 'mementomori';

    await _sshShellService.executeCommand(
      '''
cd ~/Downloads/certificates;
security create-keychain -p $icloudKeychainPassword $keychainPath;
security default-keychain -s $keychainPath;
security unlock-keychain -p $icloudKeychainPassword $keychainPath;
security set-keychain-settings -lut 21600 $keychainPath;
security import $p12 -P $icloudKeychainPassword -A -t cert -f pkcs12 -k $keychainPath;
security list-keychain -d user -s $keychainPath;
mkdir -p ~/Library/MobileDevice/Provisioning\\ Profiles;
cp $mobileprovisionPath ~/Library/MobileDevice/Provisioning\\ Profiles;
''',
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
flutter pub get;
cd ios;
rm Podfile.lock;
rm -rf Pods;
pod --version;
pod repo update;
pod install;
''',
      _sshClient,
      _jobId,
      _workingVMName,
    );
  }

  Future<void> buildIpa(
    int iosBuildNumber,
    WorkflowFlutterConfig flutterConfig,
  ) async {
    final command =
        '${BuildCommonCommands.loadZshrc} && ${BuildCommonCommands.navigateToAppDirectory(_appName)} && flutter build ipa ${FlavorService.flavorArgument(flutterConfig)} ${BuildCommonCommands.generateDartDefines(flutterConfig.dartDefine)} --build-number=$iosBuildNumber --export-options-plist=ios/openCIexportOptions.plist;';
    await _sshShellService.executeCommand(
      command,
      _sshClient,
      _jobId,
      _workingVMName,
    );
  }

  Future<ShellResult> patchShorebirdIpa(
    int iosBuildNumber,
    String? shorebirdToken,
    WorkflowFlutterConfig flutterConfig,
  ) async {
    if (shorebirdToken == null) {
      throw Exception('Shorebird token is required');
    }
    final command = '''
${BuildCommonCommands.loadZshrc};
${BuildCommonCommands.navigateToAppDirectory(_appName)};
export SHOREBIRD_TOKEN=$shorebirdToken;
export CI=true;
shorebird patch ios ${FlavorService.flavorArgument(flutterConfig)} --allow-asset-diffs --allow-native-diffs -- --build-number=$iosBuildNumber --export-options-plist=ios/openCIexportOptions.plist ${BuildCommonCommands.generateDartDefines(flutterConfig.dartDefine)}; 
''';
    return _sshShellService.executeCommand(
      command,
      _sshClient,
      _jobId,
      _workingVMName,
    );
  }

  Future<ShellResult> buildShorebirdIpa(
    int iosBuildNumber,
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
    final command = '''
${BuildCommonCommands.loadZshrc};
${BuildCommonCommands.navigateToAppDirectory(_appName)};
export SHOREBIRD_TOKEN=$shorebirdToken;
shorebird release ios ${FlavorService.flavorArgument(flutterConfig)} $flutterVersionArgument -- --build-number=$iosBuildNumber --export-options-plist=ios/openCIexportOptions.plist ${BuildCommonCommands.generateDartDefines(flutterConfig.dartDefine)}; 
''';
    return _sshShellService.executeCommand(
      command,
      _sshClient,
      _jobId,
      _workingVMName,
    );
  }

  Future<void> downloadP8(
    String? downloadUrl,
    String? keyId,
  ) async {
    if (downloadUrl == null) {
      throw Exception('Download URL is required');
    }
    if (keyId == null) {
      throw Exception('Key ID is required');
    }
    const privateKeysDir = '~/private_keys';
    final fileName = 'AuthKey_$keyId.p8';
    await _sshShellService.executeCommand(
      '''
mkdir $privateKeysDir;
cd $privateKeysDir;
curl -L -o $fileName "$downloadUrl";
''',
      _sshClient,
      _jobId,
      _workingVMName,
    );
  }

  Future<String> fetchPrivateKey(
    String? downloadUrl,
  ) async {
    if (downloadUrl == null) {
      throw Exception('Download URL is required');
    }
    final result = await _sshShellService.executeCommand(
      '''
curl -sL "$downloadUrl"
''',
      _sshClient,
      _jobId,
      _workingVMName,
    );
    return result.sessionResult.sessionStdout;
  }

  Future<void> uploadIpaToTestFlight(
    String? appStoreConnectKeyId,
    String? appStoreConnectIssuerId,
    String ipaPath,
  ) async {
    if (appStoreConnectKeyId == null) {
      throw Exception('Download URL is required');
    }
    if (appStoreConnectIssuerId == null) {
      throw Exception('Key ID is required');
    }
    await _sshShellService.executeCommand(
      '''
xcrun altool --upload-app -f $ipaPath --type ios --apiKey $appStoreConnectKeyId --apiIssuer $appStoreConnectIssuerId
''',
      _sshClient,
      _jobId,
      _workingVMName,
    );
  }

  Future<void> getRubyScripts(
    SSHShellService sshShellService,
    SSHClient sshClient,
    String jobId,
    String workingVMName,
  ) async {
    await sshShellService.executeCommand(
      'cd ~/Downloads && git clone https://github.com/open-ci-io/xcodeproj_scripts.git',
      sshClient,
      jobId,
      workingVMName,
    );
  }

  Future<void> setProvisioningProfile(
    SSHShellService sshShellService,
    SSHClient sshClient,
    String jobId,
    String workingVMName,
    String? teamId,
    String? provisioningProfileName,
  ) async {
    if (teamId == null) {
      throw Exception('Team ID is required');
    }
    if (provisioningProfileName == null) {
      throw Exception('Provisioning Profile Name is required');
    }
    await sshShellService.executeCommand(
      // TODO(someone): xcodeproj is installed macOS vm but, openci can't recognize it.
      'cd ~/Downloads/ && sudo gem install xcodeproj && ruby xcodeproj_scripts/change_provisioning_profile.rb ~/Downloads/$_appName/ios/Runner.xcodeproj $teamId $provisioningProfileName',
      sshClient,
      jobId,
      workingVMName,
    );
  }

  Future<Map<String, dynamic>> getLatestAppVersionAndBuildNumber(
    String? appId,
    String? keyId,
    String? issuerId,
    String? privateKey,
  ) async {
    if (appId == null ||
        keyId == null ||
        issuerId == null ||
        privateKey == null) {
      throw Exception(
        'appId: $appId keyId: $keyId issuerId: $issuerId privateKey: $privateKey are null',
      );
    }

    const url =
        'https://getlatestbuildversionandnumber-wvluvdjkzq-uc.a.run.app';

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'keyId': keyId,
        'appId': appId,
        'issuerId': issuerId,
        'privateKey': privateKey,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return data;
    } else {
      throw Exception(
        'Failed to get installation token. Status code: ${response.statusCode}',
      );
    }
  }
}

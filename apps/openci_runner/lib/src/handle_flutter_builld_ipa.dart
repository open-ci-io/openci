import 'dart:convert';

import 'package:dart_firebase_admin_plus/firestore.dart';
import 'package:dartssh2/dartssh2.dart';
import 'package:openci_models/openci_models.dart';
import 'package:openci_runner/src/firebase.dart';
import 'package:openci_runner/src/run_command.dart';

Future<void> handleFlutterBuildIpa(
  String logId,
  SSHClient client,
  WorkflowModel workflow,
  BuildJob buildJob,
  Firestore firestore,
) async {
  // 0. Secretsの存在を確認
  final areASCSecretsUploaded = await _areASCSecretsUploaded();
  if (!areASCSecretsUploaded) {
    throw Exception('ASC secrets are not uploaded');
  }

  final isValidP12FileUploaded = await _wasP12FileUploadedWithinOneYear();
  if (isValidP12FileUploaded) {
    print('P12 file is uploaded within one year');
    // base64を取得し、リモートに書き込む
    // keychainにimport
    // PPをDL
    // PPをVMに配置
  } else {
    print('P12 file is not uploaded within one year');
    // p12ファイルを作成
    final p8Base64 = await _getP8Base64(firestore);
    final issuerId = await _getIssuerId(firestore);
    final keyId = await _getKeyId(firestore);
    await _uploadP8File(
      client,
      p8Base64,
      logId,
      workflow.id,
      buildJob.id,
      workflow.currentWorkingDirectory,
      keyId,
    );

    await runCommand(
      logId: logId,
      client: client,
      command: 'openci_cli2 update',
      currentWorkingDirectory: workflow.currentWorkingDirectory,
      jobId: buildJob.id,
    );

    final result = await runCommand(
      logId: logId,
      client: client,
      command:
          'openci_cli2 create-certificate --issuer-id=$issuerId --key-id=$keyId --path-to-private-key="${authKeyPath(cwd: workflow.currentWorkingDirectory, keyId: keyId)}" --certificate-type=DISTRIBUTION',
      currentWorkingDirectory: workflow.currentWorkingDirectory,
      jobId: buildJob.id,
    );

    final resultJson = jsonDecode(result.stdout);
    final resultCode = resultJson['statusCode'];

    if (resultCode != 201) {
      throw Exception('Failed to create certificate');
    }
    final keyBase64 = resultJson['key'];

    await runCommand(
      logId: logId,
      client: client,
      command:
          'echo $keyBase64 | base64 -d > /Users/admin/Desktop/certificate.key',
      currentWorkingDirectory: workflow.currentWorkingDirectory,
      jobId: buildJob.id,
    );

    final csrBase64 =
        resultJson['body']['data']['attributes']['certificateContent'];

    final certificateId = resultJson['body']['data']['id'];

    await runCommand(
      logId: logId,
      client: client,
      command:
          'echo $csrBase64 | base64 -d > /Users/admin/Desktop/certificate.cer',
      currentWorkingDirectory: workflow.currentWorkingDirectory,
      jobId: buildJob.id,
    );

    const p12Path = '/Users/admin/Desktop/certificate.p12';
    const p12Password = '12345678';
    const keychainPassword = '12345678';

    await runCommand(
      logId: logId,
      client: client,
      command:
          'openssl pkcs12 -export -in /Users/admin/Desktop/certificate.cer -inkey /Users/admin/Desktop/certificate.key -out $p12Path -name "Certificate Name" -passout pass:$p12Password',
      currentWorkingDirectory: workflow.currentWorkingDirectory,
      jobId: buildJob.id,
    );

    // Save p12 file to Firestore (as a secret)

    const keychainPath =
        '/Users/admin/Library/Keychains/app-signing.keychain-db';

    await runCommand(
      logId: logId,
      client: client,
      command: 'security create-keychain -p "$keychainPassword" $keychainPath',
      currentWorkingDirectory: workflow.currentWorkingDirectory,
      jobId: buildJob.id,
    );

    await runCommand(
      logId: logId,
      client: client,
      command: 'security set-keychain-settings -lut 21600 $keychainPath',
      currentWorkingDirectory: workflow.currentWorkingDirectory,
      jobId: buildJob.id,
    );

    await runCommand(
      logId: logId,
      client: client,
      command: 'security unlock-keychain -p "$keychainPassword" $keychainPath',
      currentWorkingDirectory: workflow.currentWorkingDirectory,
      jobId: buildJob.id,
    );

    await runCommand(
      logId: logId,
      client: client,
      command:
          'security import $p12Path -P $p12Password -A -t cert -f pkcs12 -k $keychainPath',
      currentWorkingDirectory: workflow.currentWorkingDirectory,
      jobId: buildJob.id,
    );

    await runCommand(
      logId: logId,
      client: client,
      command:
          'security set-key-partition-list -S apple-tool:,apple: -k $keychainPassword $keychainPath',
      currentWorkingDirectory: workflow.currentWorkingDirectory,
      jobId: buildJob.id,
    );

    await runCommand(
      logId: logId,
      client: client,
      command: 'security list-keychain -d user -s $keychainPath',
      currentWorkingDirectory: workflow.currentWorkingDirectory,
      jobId: buildJob.id,
    );

    // await runCommand(
    //   logId: logId,
    //   client: client,
    //   command:
    //       'openci_cli2 create-provisioning-profile --issuer-id=$issuerId --key-id=$keyId --path-to-private-key="/Users/admin/Desktop/AuthKey_$keyId.p8" --certificate-id=$certificateId --profile-name="OpenCI PP" --profile-type="IOS_APP_STORE" --bundle-id="io.openci.dashboard.ios"',
    //   currentWorkingDirectory: workflow.currentWorkingDirectory,
    //   jobId: buildJob.id,
    // );

    final bundleIdRes = await runCommand(
      logId: logId,
      client: client,
      command:
          r"grep -m1 PRODUCT_BUNDLE_IDENTIFIER ios/Runner.xcodeproj/project.pbxproj | sed -E 's/.*= ([^;]+);.*/\1/'",
      currentWorkingDirectory: workflow.currentWorkingDirectory,
      jobId: buildJob.id,
    );
    print('bundleIdRes: $bundleIdRes');

    final bundleId = bundleIdRes.stdout.trim();

    final bundleIdsRes = await runCommand(
      logId: logId,
      client: client,
      command:
          'openci_cli2 list-bundle-ids --issuer-id=$issuerId --key-id=$keyId --path-to-private-key="${authKeyPath(cwd: workflow.currentWorkingDirectory, keyId: keyId)}" --filter-identifier="$bundleId"',
      currentWorkingDirectory: workflow.currentWorkingDirectory,
      jobId: buildJob.id,
    );
    print('bundleIdsRes: $bundleIdsRes');

    final bundleIdsJson = jsonDecode(bundleIdsRes.stdout);
    final ascBundleId = bundleIdsJson['body']['data'][0]['id'];
    final teamId =
        bundleIdsJson['body']['data'][0]['attributes']['seedId'] as String;

    const ppName = 'OpenCI PP';

    final ppRes = await runCommand(
      logId: logId,
      client: client,
      command:
          'openci_cli2 create-provisioning-profile --issuer-id=$issuerId --key-id=$keyId --path-to-private-key="${authKeyPath(cwd: workflow.currentWorkingDirectory, keyId: keyId)}" --certificate-id=$certificateId --profile-name="$ppName" --profile-type="IOS_APP_STORE" --bundle-id=$ascBundleId',
      currentWorkingDirectory: workflow.currentWorkingDirectory,
      jobId: buildJob.id,
    );

    print('ppRes: $ppRes');
    final ppJson = jsonDecode(ppRes.stdout);
    final ppBase64 = ppJson['body']['data']['attributes']['profileContent'];
    final ppUuid = ppJson['body']['data']['attributes']['uuid'];

    await runCommand(
      logId: logId,
      client: client,
      command:
          r'mkdir -p /Users/admin/Library/MobileDevice/Provisioning\ Profiles',
      currentWorkingDirectory: workflow.currentWorkingDirectory,
      jobId: buildJob.id,
    );

    await runCommand(
      logId: logId,
      client: client,
      command: 'pwd',
      currentWorkingDirectory: workflow.currentWorkingDirectory,
      jobId: buildJob.id,
    );

    await runCommand(
      logId: logId,
      client: client,
      command:
          'echo $ppBase64 | base64 -d > "/Users/admin/Library/MobileDevice/Provisioning Profiles/$ppUuid.mobileprovision"',
      currentWorkingDirectory: workflow.currentWorkingDirectory,
      jobId: buildJob.id,
    );

    final exportOptionsPlistBase64 = createPlistXmlAsBase64(
      teamId: teamId,
      bundleId: bundleId,
      profileName: ppName,
    );

    await runCommand(
      logId: logId,
      client: client,
      command:
          'echo $exportOptionsPlistBase64 | base64 -d > "/Users/admin/${workflow.currentWorkingDirectory}/ios/ExportOptions.plist"',
      currentWorkingDirectory: workflow.currentWorkingDirectory,
      jobId: buildJob.id,
    );

    final rubyScriptBase64 = generateXcodeprojRubyScriptBase64(
      teamId: teamId,
      profileName: ppName,
    );
    const rubyScriptName = 'xcode_proj.rb';

    await runCommand(
      logId: logId,
      client: client,
      command:
          'echo $rubyScriptBase64 | base64 -d > "/Users/admin/${workflow.currentWorkingDirectory}/$rubyScriptName"',
      currentWorkingDirectory: workflow.currentWorkingDirectory,
      jobId: buildJob.id,
    );

    await runCommand(
      logId: logId,
      client: client,
      command: 'ruby $rubyScriptName',
      currentWorkingDirectory: workflow.currentWorkingDirectory,
      jobId: buildJob.id,
    );

    await runCommand(
      logId: logId,
      client: client,
      command: '',
      currentWorkingDirectory: workflow.currentWorkingDirectory,
      jobId: buildJob.id,
    );

    await runCommand(
      logId: logId,
      client: client,
      command:
          'flutter build ipa --export-options-plist="/Users/admin/${workflow.currentWorkingDirectory}/ios/ExportOptions.plist"',
      currentWorkingDirectory: workflow.currentWorkingDirectory,
      jobId: buildJob.id,
    );

    await runCommand(
      logId: logId,
      client: client,
      command:
          'xcrun altool --upload-app --type ios -f build/ios/ipa/*.ipa --apiKey $keyId --apiIssuer $issuerId',
      currentWorkingDirectory: workflow.currentWorkingDirectory,
      jobId: buildJob.id,
    );

    await Future<void>.delayed(const Duration(hours: 10));
  }
}

String decodeBase64ToOriginalString(String base64String) {
  if (base64String.trim().isEmpty) {
    return '';
  }
  return utf8.decode(base64Decode(base64String));
}

Future<String> _getIssuerId(Firestore firestore) async {
  final qs = firestore
      .collection(secretsCollectionPath)
      .where('key', WhereFilter.equal, 'OPENCI_ASC_ISSUER_ID');
  final docs = await qs.get();
  final data = docs.docs.first.data();
  final issuerId = data['value'] as String?;
  if (issuerId == null) {
    throw Exception('OPENCI_ASC_ISSUER_ID is not found');
  }
  return issuerId;
}

Future<String> _getKeyId(Firestore firestore) async {
  final qs = firestore
      .collection(secretsCollectionPath)
      .where('key', WhereFilter.equal, 'OPENCI_ASC_KEY_ID');
  final docs = await qs.get();
  final data = docs.docs.first.data();
  final keyId = data['value'] as String?;
  if (keyId == null) {
    throw Exception('OPENCI_ASC_KEY_ID is not found');
  }
  return keyId;
}

Future<String> _getP8Base64(Firestore firestore) async {
  final qs = firestore
      .collection(secretsCollectionPath)
      .where('key', WhereFilter.equal, 'OPENCI_ASC_KEY_BASE64');
  final docs = await qs.get();
  final data = docs.docs.first.data();
  final keyBase64 = data['value'] as String?;
  if (keyBase64 == null) {
    throw Exception('OPENCI_ASC_KEY_BASE64 is not found');
  }
  return keyBase64;
}

String authKeyPath({
  required String cwd,
  required String keyId,
}) {
  return '/Users/admin/$cwd/private_keys/AuthKey_$keyId.p8';
}

Future<void> _uploadP8File(
  SSHClient client,
  String p8Base64,
  String logId,
  String workflowId,
  String buildJobId,
  String currentWorkingDirectory,
  String keyId,
) async {
  // リモートに書き込む
  // keychainにimport
  // PPをDL
  // PPをVMに配置
  await runCommand(
    client: client,
    command: 'mkdir -p /Users/admin/$currentWorkingDirectory/private_keys',
    currentWorkingDirectory: currentWorkingDirectory,
    jobId: buildJobId,
    logId: logId,
  );

  await runCommand(
    logId: logId,
    client: client,
    command:
        'echo $p8Base64 | base64 -d > ${authKeyPath(cwd: currentWorkingDirectory, keyId: keyId)}',
    currentWorkingDirectory: currentWorkingDirectory,
    jobId: buildJobId,
  );
}

Future<bool> _wasP12FileUploadedWithinOneYear() async {
  final firestore = firestoreSignal.value!;
  final querySnapshot = await firestore
      .collection(secretsCollectionPath)
      .where('key', WhereFilter.equal, 'OPENCI_ASC_P12_FILE')
      .get();

  if (querySnapshot.docs.isEmpty) {
    return false;
  }

  final data = querySnapshot.docs.first.data();
  final updatedAtInt = int.parse(data['updatedAt'].toString());

  final updatedAtDateTime =
      DateTime.fromMillisecondsSinceEpoch(updatedAtInt * 1000);
  final now = DateTime.now();
  final aYearAgo = now.subtract(const Duration(days: 365));

  if (updatedAtDateTime.isBefore(aYearAgo)) {
    return false;
  }

  return true;
}

Future<bool> _areASCSecretsUploaded() async {
  final firestore = firestoreSignal.value!;
  final isIssuerIdUploaded = await _isIssuerIdUploaded(firestore);
  final isKeyIdUploaded = await _isKeyIdUploaded(firestore);
  final isKeyBase64Uploaded = await _isKeyBase64Uploaded(firestore);

  return isIssuerIdUploaded && isKeyIdUploaded && isKeyBase64Uploaded;
}

Future<bool> _isIssuerIdUploaded(Firestore firestore) async {
  final qs = firestore
      .collection(secretsCollectionPath)
      .where('key', WhereFilter.equal, 'OPENCI_ASC_ISSUER_ID');
  final docs = await qs.get();
  return docs.docs.isNotEmpty;
}

Future<bool> _isKeyIdUploaded(Firestore firestore) async {
  final qs = firestore
      .collection(secretsCollectionPath)
      .where('key', WhereFilter.equal, 'OPENCI_ASC_KEY_ID');
  final docs = await qs.get();
  return docs.docs.isNotEmpty;
}

Future<bool> _isKeyBase64Uploaded(Firestore firestore) async {
  final qs = firestore
      .collection(secretsCollectionPath)
      .where('key', WhereFilter.equal, 'OPENCI_ASC_KEY_BASE64');
  final docs = await qs.get();
  return docs.docs.isNotEmpty;
}

String createPlistXmlAsBase64({
  required String teamId,
  required String bundleId,
  required String profileName,
}) {
  final xmlContent = '''
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
    <dict>
        <key>method</key>
        <string>app-store</string>
        <key>provisioningProfiles</key>
        <dict>
            <key>$bundleId</key>
            <string>$profileName</string>
        </dict>
        <key>signingCertificate</key>
        <string>Apple Distribution</string>
        <key>signingStyle</key>
        <string>manual</string>
        <key>teamID</key>
        <string>$teamId</string>
    </dict>
</plist>
''';

  if (xmlContent.trim().isEmpty) {
    return '';
  }

  final bytes = utf8.encode(xmlContent);
  final base64String = base64Encode(bytes);
  return base64String;
}

/// Returns a base64 encoded string of the Ruby script.
/// This Ruby script modifies the Xcode project build settings.
String generateXcodeprojRubyScriptBase64({
  required String teamId,
  required String profileName,
}) {
  final rubyScript = '''
require 'xcodeproj'

# Project path (using ios/Runner.xcodeproj)
project_path = 'ios/Runner.xcodeproj'
project = Xcodeproj::Project.open(project_path)

# Modify build settings of each target in the project
project.targets.each do |target|
  target.build_configurations.each do |config|
    config.build_settings['CODE_SIGN_STYLE'] = 'Manual'
    config.build_settings['DEVELOPMENT_TEAM'] = '$teamId'
    config.build_settings['PROVISIONING_PROFILE_SPECIFIER'] = '$profileName'
    config.build_settings["PROVISIONING_PROFILE_SPECIFIER[sdk=iphoneos*]"] = '$profileName'
    config.build_settings['CODE_SIGN_IDENTITY'] = 'Apple Distribution'
  end
end

project.save
''';

  if (rubyScript.trim().isEmpty) return '';

  return base64Encode(utf8.encode(rubyScript));
}

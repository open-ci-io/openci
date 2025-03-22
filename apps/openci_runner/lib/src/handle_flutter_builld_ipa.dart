import 'dart:convert';

import 'package:dart_firebase_admin/firestore.dart';
import 'package:dartssh2/dartssh2.dart';
import 'package:openci_models/openci_models.dart';
import 'package:openci_runner/src/env.dart';
import 'package:openci_runner/src/firebase.dart';
import 'package:openci_runner/src/run_command.dart';
import 'package:uuid/uuid.dart';

const _p12Path = '/Users/admin/Desktop/certificate.p12';
const _p12Password = '12345678';
const _keychainPassword = '12345678';

Future<void> handleFlutterBuildIpa(
  String logId,
  SSHClient client,
  WorkflowModel workflow,
  BuildJob buildJob,
  Firestore firestore,
  ReplacementResult replacementResult,
) async {
  final areASCSecretsUploaded = await _areASCSecretsUploaded();
  if (!areASCSecretsUploaded) {
    throw Exception('ASC secrets are not uploaded');
  }

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

  String? certificateId;

  final isValidP12FileUploaded = await _wasP12FileUploadedWithinOneYear();
  final isP12CertificateIdUploaded =
      await _isP12CertificateIdUploaded(firestore);

  if (isValidP12FileUploaded && isP12CertificateIdUploaded) {
    print('P12 file is uploaded within one year');

    final p12Base64 = await _fetchP12File(firestore);
    certificateId = await _fetchP12CertificateId(firestore);

    final isP12RegisteredInASC = await _isP12RegisteredInASC(
      certificateId,
      client,
      logId,
      workflow.id,
      buildJob.id,
      workflow.currentWorkingDirectory,
      issuerId,
      keyId,
    );

    if (!isP12RegisteredInASC) {
      await _deleteP12File(firestore);
      await _deleteP12CertificateId(firestore);

      certificateId = await _createP12File(
        logId: logId,
        client: client,
        workflow: workflow,
        buildJob: buildJob,
        firestore: firestore,
        issuerId: issuerId,
        keyId: keyId,
      );

      await _uploadP12File(
        client,
        logId,
        workflow.id,
        buildJob.id,
        workflow.currentWorkingDirectory,
        _p12Path,
        firestore,
      );

      await _uploadP12CertificateId(certificateId, firestore);
    } else {
      await runCommand(
        logId: logId,
        client: client,
        command: 'echo $p12Base64 | base64 -d > $_p12Path',
        currentWorkingDirectory: workflow.currentWorkingDirectory,
        jobId: buildJob.id,
      );
    }
  } else if (!isValidP12FileUploaded && !isP12CertificateIdUploaded) {
    print('P12 file is not uploaded within one year');
    certificateId = await _createP12File(
      logId: logId,
      client: client,
      workflow: workflow,
      buildJob: buildJob,
      firestore: firestore,
      issuerId: issuerId,
      keyId: keyId,
    );

    await _uploadP12File(
      client,
      logId,
      workflow.id,
      buildJob.id,
      workflow.currentWorkingDirectory,
      _p12Path,
      firestore,
    );

    await _uploadP12CertificateId(certificateId, firestore);
  } else {
    throw Exception(
      'P12 file is not uploaded within one year or P12 certificate id is not uploaded, isValidP12FileUploaded:$isValidP12FileUploaded, isP12CertificateIdUploaded:$isP12CertificateIdUploaded',
    );
  }

  const keychainPath = '/Users/admin/Library/Keychains/app-signing.keychain-db';

  await runCommand(
    logId: logId,
    client: client,
    command: 'security create-keychain -p "$_keychainPassword" $keychainPath',
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
    command: 'security unlock-keychain -p "$_keychainPassword" $keychainPath',
    currentWorkingDirectory: workflow.currentWorkingDirectory,
    jobId: buildJob.id,
  );

  await runCommand(
    logId: logId,
    client: client,
    command:
        'security import $_p12Path -P $_p12Password -A -t cert -f pkcs12 -k $keychainPath',
    currentWorkingDirectory: workflow.currentWorkingDirectory,
    jobId: buildJob.id,
  );

  await runCommand(
    logId: logId,
    client: client,
    command:
        'security set-key-partition-list -S apple-tool:,apple: -k $_keychainPassword $keychainPath',
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

  final bundleIdRes = await runCommand(
    logId: logId,
    client: client,
    command:
        r"grep -m1 PRODUCT_BUNDLE_IDENTIFIER ios/Runner.xcodeproj/project.pbxproj | sed -E 's/.*= ([^;]+);.*/\1/'",
    currentWorkingDirectory: workflow.currentWorkingDirectory,
    jobId: buildJob.id,
  );

  final bundleId = bundleIdRes.stdout.trim();

  final bundleIdsRes = await runCommand(
    logId: logId,
    client: client,
    command:
        'openci_cli2 list-bundle-ids --issuer-id=$issuerId --key-id=$keyId --path-to-private-key="${authKeyPath(cwd: workflow.currentWorkingDirectory, keyId: keyId)}" --filter-identifier="$bundleId"',
    currentWorkingDirectory: workflow.currentWorkingDirectory,
    jobId: buildJob.id,
  );

  final bundleIdsJson = jsonDecode(bundleIdsRes.stdout);
  final ascBundleId = bundleIdsJson['body']['data'][0]['id'];
  final teamId =
      bundleIdsJson['body']['data'][0]['attributes']['seedId'] as String;

  final ppName = 'OpenCI_PP_${const Uuid().v4()}';

  final ppRes = await runCommand(
    logId: logId,
    client: client,
    command:
        'openci_cli2 create-provisioning-profile --issuer-id=$issuerId --key-id=$keyId --path-to-private-key="${authKeyPath(cwd: workflow.currentWorkingDirectory, keyId: keyId)}" --certificate-id=$certificateId --profile-name="$ppName" --profile-type="IOS_APP_STORE" --bundle-id=$ascBundleId',
    currentWorkingDirectory: workflow.currentWorkingDirectory,
    jobId: buildJob.id,
  );

  final ppJson = jsonDecode(ppRes.stdout);
  final ppBase64 = ppJson['body']['data']['attributes']['profileContent'];
  final ppUuid = ppJson['body']['data']['attributes']['uuid'];
  final ppId = ppJson['body']['data']['id'];

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

  try {
    await runCommand(
      logId: logId,
      client: client,
      command:
          '${replacementResult.replacedCommand} --export-options-plist="/Users/admin/${workflow.currentWorkingDirectory}/ios/ExportOptions.plist"',
      currentWorkingDirectory: workflow.currentWorkingDirectory,
      jobId: buildJob.id,
    );
  } finally {
    await runCommand(
      logId: logId,
      client: client,
      command:
          'openci_cli2 delete-provisioning-profile --issuer-id=$issuerId --key-id=$keyId --path-to-private-key="${authKeyPath(cwd: workflow.currentWorkingDirectory, keyId: keyId)}" --profile-id=$ppId',
      currentWorkingDirectory: workflow.currentWorkingDirectory,
      jobId: buildJob.id,
    );
  }
}

Future<void> _deleteP12File(Firestore firestore) async {
  final qs = firestore
      .collection(secretsCollectionPath)
      .where('key', WhereFilter.equal, 'OPENCI_ASC_P12_FILE');
  final docs = await qs.get();
  if (docs.docs.isNotEmpty) {
    await docs.docs.first.ref.delete();
  }
}

Future<void> _deleteP12CertificateId(Firestore firestore) async {
  final qs = firestore
      .collection(secretsCollectionPath)
      .where('key', WhereFilter.equal, 'OPENCI_ASC_P12_CERTIFICATE_ID');
  final docs = await qs.get();
  if (docs.docs.isNotEmpty) {
    await docs.docs.first.ref.delete();
  }
}

Future<String> _fetchP12File(Firestore firestore) async {
  final qs = firestore
      .collection(secretsCollectionPath)
      .where('key', WhereFilter.equal, 'OPENCI_ASC_P12_FILE');
  final docs = await qs.get();
  final data = docs.docs.first.data();
  final p12Base64 = data['value'] as String?;
  if (p12Base64 == null) {
    throw Exception('OPENCI_ASC_P12_FILE is not found');
  }

  return p12Base64;
}

Future<String> _fetchP12CertificateId(Firestore firestore) async {
  final qs = firestore
      .collection(secretsCollectionPath)
      .where('key', WhereFilter.equal, 'OPENCI_ASC_P12_CERTIFICATE_ID');
  final docs = await qs.get();
  final data = docs.docs.first.data();
  final certificateId = data['value'] as String?;
  if (certificateId == null) {
    throw Exception('OPENCI_ASC_P12_CERTIFICATE_ID is not found');
  }
  return certificateId;
}

Future<String> _createP12File({
  required String logId,
  required SSHClient client,
  required WorkflowModel workflow,
  required BuildJob buildJob,
  required Firestore firestore,
  required String issuerId,
  required String keyId,
}) async {
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

  final certificateId = resultJson['body']['data']['id'] as String;

  await runCommand(
    logId: logId,
    client: client,
    command:
        'echo $csrBase64 | base64 -d > /Users/admin/Desktop/certificate.cer',
    currentWorkingDirectory: workflow.currentWorkingDirectory,
    jobId: buildJob.id,
  );

  await runCommand(
    logId: logId,
    client: client,
    command:
        'openssl pkcs12 -export -in /Users/admin/Desktop/certificate.cer -inkey /Users/admin/Desktop/certificate.key -out $_p12Path -name "Certificate Name" -passout pass:$_p12Password',
    currentWorkingDirectory: workflow.currentWorkingDirectory,
    jobId: buildJob.id,
  );
  return certificateId;
}

Future<void> _uploadP12File(
  SSHClient client,
  String logId,
  String workflowId,
  String buildJobId,
  String currentWorkingDirectory,
  String p12Path,
  Firestore firestore,
) async {
  final p12Base64Result = await runCommand(
    logId: logId,
    client: client,
    command: 'base64 -i $p12Path',
    currentWorkingDirectory: currentWorkingDirectory,
    jobId: buildJobId,
  );

  if (p12Base64Result.exitCode != 0) {
    throw Exception('Failed to encode p12 file to base64');
  }

  final p12Base64 = p12Base64Result.stdout.trim();

  await firestore.collection(secretsCollectionPath).add({
    'key': 'OPENCI_ASC_P12_FILE',
    'value': p12Base64,
    'updatedAt': DateTime.now().millisecondsSinceEpoch ~/ 1000,
  });
  print('Successfully uploaded p12 file');
}

Future<void> _uploadP12CertificateId(
  String certificateId,
  Firestore firestore,
) async {
  await firestore.collection(secretsCollectionPath).add({
    'key': 'OPENCI_ASC_P12_CERTIFICATE_ID',
    'value': certificateId,
    'updatedAt': DateTime.now().millisecondsSinceEpoch ~/ 1000,
  });
  print('Successfully uploaded p12 certificate id');
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

Future<bool> _isP12CertificateIdUploaded(Firestore firestore) async {
  final qs = firestore
      .collection(secretsCollectionPath)
      .where('key', WhereFilter.equal, 'OPENCI_ASC_P12_CERTIFICATE_ID');
  final docs = await qs.get();
  return docs.docs.isNotEmpty;
}

Future<bool> _isP12RegisteredInASC(
  String certificateId,
  SSHClient client,
  String logId,
  String workflowId,
  String buildJobId,
  String currentWorkingDirectory,
  String issuerId,
  String keyId,
) async {
  final result = await runCommand(
    logId: logId,
    client: client,
    command:
        'openci_cli2 read-certificate --issuer-id=$issuerId --key-id=$keyId --path-to-private-key="${authKeyPath(cwd: currentWorkingDirectory, keyId: keyId)}" --certificate-id=$certificateId',
    currentWorkingDirectory: currentWorkingDirectory,
    jobId: buildJobId,
  );
  final stdout = result.stdout;
  return stdout.contains('200') ||
      stdout.contains('201') ||
      stdout.contains('202');
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

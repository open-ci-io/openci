import 'dart:convert';
import 'dart:io';

import 'package:mason_logger/mason_logger.dart';
import 'package:openci_cli2/src/app_store_connect.dart';
import 'package:openci_models/openci_models.dart';

Future<int> readProvisioningProfile({
  required String issuerId,
  required String keyId,
  required String privateKey,
  required String profileId,
}) async {
  final client = AppStoreConnectClient(
    issuerId: issuerId,
    keyId: keyId,
    privateKey: privateKey,
  );

  try {
    final response = await client.getProfile(
      profileId: profileId,
    );

    final result = SessionResult(
      stdout: json.encode(response),
      stderr: '',
      exitCode: 0,
    );

    stdout.write(json.encode(result.toJson()));
    return ExitCode.success.code;
  } catch (e) {
    final result = SessionResult(
      stdout: '',
      stderr: e.toString(),
      exitCode: 1,
    );
    stdout.write(json.encode(result.toJson()));
    return 1;
  } finally {
    client.dispose();
  }
}

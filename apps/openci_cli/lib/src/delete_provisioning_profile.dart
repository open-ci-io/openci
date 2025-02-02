import 'dart:convert';
import 'dart:io';

import 'package:mason_logger/mason_logger.dart';
import 'package:openci_cli2/src/app_store_connect.dart';

Future<int> deleteProvisioningProfile({
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
    final response = await client.deleteProfile(
      profileId: profileId,
    );

    stdout.write(jsonEncode(response));
    return ExitCode.success.code;
  } catch (e) {
    final result = {
      'stderr': e.toString(),
      'exitCode': 1,
    };
    stdout.write(jsonEncode(result));
    return 1;
  } finally {
    client.dispose();
  }
}

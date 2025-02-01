import 'dart:convert';
import 'dart:io';

import 'package:mason_logger/mason_logger.dart';
import 'package:openci_cli2/src/app_store_connect.dart';
import 'package:openci_cli2/src/profile_type.dart';
import 'package:openci_models/openci_models.dart';

Future<int> createProvisioningProfile({
  required String issuerId,
  required String keyId,
  required String privateKey,
  required String profileName,
  required ProfileType profileType,
  required String bundleId,
  required String certificateId,
}) async {
  final client = AppStoreConnectClient(
    issuerId: issuerId,
    keyId: keyId,
    privateKey: privateKey,
  );

  try {
    final response = await client.createProfile(
      name: profileName,
      profileType: profileType,
      bundleId: bundleId,
      certificateId: certificateId,
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

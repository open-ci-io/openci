import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:openci_cli2/src/read_provisioning_profile.dart';

class ReadProvisioningProfileCommand extends Command<int> {
  ReadProvisioningProfileCommand() {
    argParser
      ..addOption(
        'issuer-id',
        help: 'App Store Connect Issuer ID',
      )
      ..addOption(
        'key-id',
        help: 'App Store Connect Key ID',
      )
      ..addOption(
        'path-to-private-key',
        help: 'Path to App Store Connect Private Key, p8 file',
      )
      ..addOption(
        'profile-id',
        help: 'Provisioning Profile ID',
      );
  }

  @override
  String get description => 'Read Apple Developer Provisioning Profile';

  @override
  String get name => 'read-provisioning-profile';

  @override
  Future<int> run() async {
    final issuerId = argResults?['issuer-id'] as String?;
    final keyId = argResults?['key-id'] as String?;
    final pathToPrivateKey = argResults?['path-to-private-key'] as String?;
    final profileId = argResults?['profile-id'] as String?;

    if (issuerId == null ||
        keyId == null ||
        pathToPrivateKey == null ||
        profileId == null) {
      return ExitCode.usage.code;
    }
    final privateKey = File(pathToPrivateKey).readAsStringSync();

    return readProvisioningProfile(
      issuerId: issuerId,
      keyId: keyId,
      privateKey: privateKey,
      profileId: profileId,
    );
  }
}

import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:openci_cli/src/create_provisioning_profile.dart';
import 'package:openci_cli/src/profile_type.dart';

class CreateProvisioningProfileCommand extends Command<int> {
  CreateProvisioningProfileCommand() {
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
        'profile-name',
        help: 'Provisioning Profile Name',
      )
      ..addOption(
        'profile-type',
        help: 'Provisioning Profile Type',
      )
      ..addOption(
        'bundle-id',
        help: 'Bundle ID',
      )
      ..addOption(
        'certificate-id',
        help: 'Certificate ID',
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
    final profileName = argResults?['profile-name'] as String?;
    final profileTypeString = argResults?['profile-type'] as String?;
    final bundleId = argResults?['bundle-id'] as String?;
    final certificateId = argResults?['certificate-id'] as String?;

    if (issuerId == null ||
        keyId == null ||
        pathToPrivateKey == null ||
        profileName == null ||
        profileTypeString == null ||
        bundleId == null ||
        certificateId == null) {
      return ExitCode.usage.code;
    }
    final privateKey = File(pathToPrivateKey).readAsStringSync();
    final profileType = ProfileType.values.byName(profileTypeString);

    return createProvisioningProfile(
      issuerId: issuerId,
      keyId: keyId,
      privateKey: privateKey,
      profileName: profileName,
      profileType: profileType,
      bundleId: bundleId,
      certificateId: certificateId,
    );
  }
}

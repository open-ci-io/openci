import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:openci_cli/src/certificate_type.dart';
import 'package:openci_cli/src/list_provisioning_profiles.dart';

class ListProvisioningProfileCommand extends Command<int> {
  ListProvisioningProfileCommand() {
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
        'filter-name',
        help: 'Filter by name',
      )
      ..addOption(
        'filter-type',
        help: 'Filter by type',
      )
      ..addOption(
        'filter-id',
        help: 'Filter by id',
      );
  }

  @override
  String get description => 'List Apple Developer Provisioning Profiles';

  @override
  String get name => 'list-provisioning-profile';

  @override
  Future<int> run() async {
    final issuerId = argResults?['issuer-id'] as String?;
    final keyId = argResults?['key-id'] as String?;
    final pathToPrivateKey = argResults?['path-to-private-key'] as String?;
    final filterName = argResults?['filter-name'] as String?;
    final filterType = argResults?['filter-type'] as String?;
    final filterId = argResults?['filter-id'] as String?;

    if (issuerId == null || keyId == null || pathToPrivateKey == null) {
      return ExitCode.usage.code;
    }
    final privateKey = File(pathToPrivateKey).readAsStringSync();

    return listProvisioningProfiles(
      issuerId: issuerId,
      keyId: keyId,
      privateKey: privateKey,
      filterName: filterName,
      filterType:
          filterType == null ? null : CertificateType.values.byName(name),
      filterId: filterId,
    );
  }
}

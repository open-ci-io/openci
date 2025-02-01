import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:openci_cli2/src/list_bundle_ids.dart';

class ListBundleIdsCommand extends Command<int> {
  ListBundleIdsCommand() {
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
        'filter-identifier',
        help: 'Filter Bundle ID by Identifier',
      );
  }

  @override
  String get description => 'List Apple Developer Bundle IDs';

  @override
  String get name => 'list-bundle-ids';

  @override
  Future<int> run() async {
    final issuerId = argResults?['issuer-id'] as String?;
    final keyId = argResults?['key-id'] as String?;
    final pathToPrivateKey = argResults?['path-to-private-key'] as String?;
    final filterIdentifier = argResults?['filter-identifier'] as String?;

    if (issuerId == null || keyId == null || pathToPrivateKey == null) {
      return ExitCode.usage.code;
    }
    final privateKey = File(pathToPrivateKey).readAsStringSync();

    return listBundleIds(
      issuerId: issuerId,
      keyId: keyId,
      privateKey: privateKey,
      filterIdentifier: filterIdentifier,
    );
  }
}

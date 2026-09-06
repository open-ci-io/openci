import 'dart:convert';

import 'orchard_api_client.dart';

Future<void> writeFile({
  required OrchardApiClient api,
  required String vmName,
  required String filePath,
  required String content,
  String? mode,
}) async {
  if (filePath.isEmpty || filePath.contains('\u0000')) {
    throw ArgumentError('filePath must not be empty or contain NUL.');
  }

  // Prefix relative paths so leading hyphens cannot become command options.
  final targetPath = filePath.startsWith('/') ? filePath : './$filePath';
  final parentPath = targetPath.substring(0, targetPath.lastIndexOf('/') + 1);
  final quotedPath = _shellQuote(targetPath);
  final encodedContent = base64Encode(utf8.encode(content));
  final chmodCommand = mode != null && mode.isNotEmpty
      ? ' && chmod -- ${_shellQuote(mode)} $quotedPath'
      : '';
  final command =
      'mkdir -p ${_shellQuote(parentPath)} && '
      'printf %s ${_shellQuote(encodedContent)} | base64 -d > $quotedPath$chmodCommand';

  final int exitCode;
  try {
    exitCode = await api.execCommandWebSocket(
      vmName: vmName,
      command: command,
      onLog: (_, _) {},
    );
  } catch (error, stackTrace) {
    // Orchard and handshake errors can include the command and encoded secrets.
    Error.throwWithStackTrace(
      StateError(
        'Failed to write file on Orchard VM ($vmName): ${error.runtimeType}.',
      ),
      stackTrace,
    );
  }

  if (exitCode != 0) {
    throw StateError(
      'Failed to write file on Orchard VM ($vmName): exit code $exitCode.',
    );
  }
}

String _shellQuote(String value) => "'${value.replaceAll("'", "'\\''")}'";

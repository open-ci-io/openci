import 'dart:convert';
import 'dart:io';

import 'package:cli_util/cli_logging.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

import '../../i18n/i18n.dart';

const _defaultServerUrl = 'http://localhost:8080';
const _defaultTimeout = Duration(seconds: 10);

Future<bool> seedLocalData(
  Logger logger, {
  @visibleForTesting http.Client? client,
  @visibleForTesting Map<String, String>? environment,
  @visibleForTesting Duration timeout = _defaultTimeout,
}) async {
  logger.stdout('\n${t.dev.start.stepSeed}');

  final httpClient = client ?? http.Client();
  final env = environment ?? Platform.environment;
  final serverUrl = env['OPENCI_SERVER_URL'] ?? _defaultServerUrl;

  try {
    final seedResponse = await httpClient
        .post(
          Uri.parse('$serverUrl/internal/seed'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({}),
        )
        .timeout(timeout);
    if (!_isSuccessful(seedResponse)) {
      _logFailedResponse(logger, seedResponse);
      return false;
    }
  } catch (error) {
    logger.stderr('${t.dev.start.stepSeedFailed}\n$error');
    return false;
  } finally {
    httpClient.close();
  }

  logger.stdout(t.dev.start.stepSeedCompleted);
  return true;
}

bool _isSuccessful(http.Response response) =>
    response.statusCode >= HttpStatus.ok &&
    response.statusCode < HttpStatus.multipleChoices;

void _logFailedResponse(Logger logger, http.Response response) {
  logger.stderr(
    '${t.dev.start.stepSeedFailed}\n'
    'Status: ${response.statusCode}\n'
    'Body: ${response.body}',
  );
}

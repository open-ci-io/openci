import 'package:runner/src/services/logger/logger_service.dart';
import 'package:runner/src/services/sentry/sentry_service.dart';

Future<void> handleException(
  dynamic e,
  StackTrace s,
) async {
  final logger = loggerSignal.value
    ..err('CLI crashed: $e')
    ..err('StackTrace: $s');

  await sentryServiceSignal.value.captureException(e, s);
  await Future<void>.delayed(const Duration(seconds: 2));

  logger.warn('Restarting the CLI...');
}

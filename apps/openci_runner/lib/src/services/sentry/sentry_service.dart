import 'package:runner/src/services/logger/logger_service.dart';
import 'package:sentry/sentry.dart';
import 'package:signals_core/signals_core.dart';

final sentryServiceSignal = signal(SentryService());

class SentryService {
  Future<void> initializeSentry(String? sentryDSN) async {
    if (sentryDSN == null) {
      loggerSignal.value
          .warn('Sentry DSN not set, skipping Sentry initialization');
      return;
    }
    await Sentry.init((options) {
      options
        ..dsn = sentryDSN
        ..tracesSampleRate = 1.0;
    });
  }

  Future<void> captureException(dynamic e, StackTrace s) async {
    await Sentry.captureException(e, stackTrace: s);
  }
}

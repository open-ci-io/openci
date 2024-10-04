import 'package:sentry/sentry.dart';

class SentryService {
  Future<void> initializeSentry(String? sentryDSN) async {
    if (sentryDSN != null) {
      await Sentry.init((options) {
        options
          ..dsn = sentryDSN
          ..tracesSampleRate = 1.0;
      });
    }
  }
}

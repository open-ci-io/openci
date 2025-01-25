import 'dart:async';

import 'package:sentry/sentry.dart';

Future<void> initSentry({
  required String sentryDsn,
  required FutureOr<void> Function() appRunner,
}) async {
  await Sentry.init(
    (options) {
      options.dsn = sentryDsn;
    },
    appRunner: appRunner,
  );
}

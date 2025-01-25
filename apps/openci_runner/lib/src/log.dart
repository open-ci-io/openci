import 'package:mason_logger/mason_logger.dart';

void log(String message, {bool isSuccess = false}) {
  final logger = Logger();
  switch (isSuccess) {
    case true:
      logger.success('[${DateTime.now().toIso8601String()}]: $message');
    case false:
      logger.info('[${DateTime.now().toIso8601String()}]: $message');
  }
}

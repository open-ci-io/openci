import 'package:args/args.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:openci_runner/src/features/runner/ios/domain/ios_runner.dart';

class IosRunnerController {
  IosRunnerController(this._logger, this.argResults);

  final Logger _logger;
  final ArgResults? argResults;

  void checkArgument(IosRunner runner) {
    if (argResults?[runner.key] == false) {
      _logger.err(runner.error);
      throw Exception('${runner.key} is required');
    }
  }

  List<String> doesArgumentsExist() {
    final arguments = argResults?.arguments;
    if (arguments == null) {
      _logger.err('arguments is null');
      throw Exception('Command Arguments are null.');
    }
    return arguments;
  }
}

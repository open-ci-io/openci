import 'package:args/command_runner.dart';
import 'package:openci_cli/src/run.dart';

class RunCommand extends Command<int> {
  @override
  String get description => 'Run the OpenCI CLI';

  @override
  String get name => 'run';

  @override
  Future<int> run() async => runApp();
}

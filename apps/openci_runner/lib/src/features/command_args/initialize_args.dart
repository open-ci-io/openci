import 'package:args/args.dart';
import 'package:runner/src/features/command_args/app_args.dart';
import 'package:runner/src/services/logger/logger_service.dart';

Future<AppArgs> initializeApp(ArgResults? argResults) async {
  if (argResults == null) {
    throw Exception('ArgResults is null');
  }
  final supabaseUrl = argResults['supabaseUrl'] as String;
  final supabaseAPIKey = argResults['supabaseAPIKey'] as String;
  loggerSignal.value.success('Argument check passed.');

  return AppArgs(
    supabaseUrl: supabaseUrl,
    supabaseAPIKey: supabaseAPIKey,
  );
}

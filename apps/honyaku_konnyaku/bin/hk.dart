import 'package:hk/arg.dart';
import 'package:hk/parse_arg.dart';
import 'package:hk/print_usage.dart';
import 'package:hk/translate.dart';

const String version = '0.0.1';

Future<void> main(List<String> arguments) async {
  final parser = buildParser();
  final results = parseArguments(parser, arguments);
  if (results == null) return;

  if (results.wasParsed('help')) {
    printUsage(parser);
    return;
  }

  if (results.wasParsed('version')) {
    print('hk version: $version');
    return;
  }
  if (results.wasParsed('input') &&
      results.wasParsed('output') &&
      results.wasParsed('api-key')) {
    final input = results['input'] as String;
    final output = results['output'] as String;
    final apiKey = results['api-key'] as String;
    final prompt = results['prompt'] as String?;
    await translate(input, output, apiKey, prompt);
    return;
  }

  final verbose = results.wasParsed('verbose');
  print('Positional arguments: ${results.rest}');
  if (verbose) {
    print('[VERBOSE] All arguments: ${results.arguments}');
  }
}

import 'package:args/args.dart';

ArgParser buildParser() {
  return ArgParser()
    ..addFlag(
      'help',
      abbr: 'h',
      negatable: false,
      help: 'Print this usage information.',
    )
    ..addFlag(
      'verbose',
      abbr: 'v',
      negatable: false,
      help: 'Show additional command output.',
    )
    ..addFlag(
      'version',
      negatable: false,
      help: 'Print the tool version.',
    )
    ..addOption(
      'input',
      abbr: 'i',
      mandatory: true,
      help: '/path/to/input.mdx',
    )
    ..addOption(
      'output',
      abbr: 'o',
      mandatory: true,
      help: '/path/to/output.mdx',
    )
    ..addOption(
      'prompt',
      abbr: 'p',
      help:
          'The prompt to use. If not provided, the default prompt (translate to english) will be used.',
    )
    ..addOption(
      'api-key',
      abbr: 'k',
      help: 'The API key to use.',
    );
}

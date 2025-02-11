import 'package:args/args.dart';

void printUsage(ArgParser argParser) {
  print('Usage: hk <flags> [arguments]');
  print(
      'Example: hk -i /path/to/input.mdx -o /path/to/output.mdx -p "translate to english" -k "your-api-key"');
  print(argParser.usage);
}

import 'package:args/args.dart';
import 'package:hk/print_usage.dart';

ArgResults? parseArguments(ArgParser parser, List<String> arguments) {
  try {
    return parser.parse(arguments);
  } on FormatException catch (e) {
    _handleFormatException(parser, e);
    return null;
  }
}

void _handleFormatException(ArgParser parser, FormatException exception) {
  print(exception.message);
  print('');
  printUsage(parser);
}

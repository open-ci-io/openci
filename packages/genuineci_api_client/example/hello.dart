import 'dart:io';

import 'package:genuineci_api_client/genuineci_api_client.dart';

Future<void> main() async {
  final client = Client('http://localhost:8180/');
  try {
    stdout.writeln(await client.greeting.hello());
  } finally {
    client.close();
  }
}

import 'package:genuineci_server/src/generated/serverpod.dart';

Future<void> main(List<String> args) async {
  final pod = Serverpod(args);
  await pod.start();
}

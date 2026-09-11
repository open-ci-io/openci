import 'package:serverpod/serverpod.dart';

/// The first GenuineCI API endpoint.
class GreetingEndpoint extends Endpoint {
  Future<String> hello(Session session) async => 'Hello world';
}

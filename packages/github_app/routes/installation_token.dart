import 'package:dart_frog/dart_frog.dart';
import 'package:dotenv/dotenv.dart';
import 'package:openci_models/openci_models.dart';

import '../bin/jwt_service.dart';

Future<Response> onRequest(RequestContext context) async {
  try {
    final request = context.request;
    final body = await request.json() as Map<String, dynamic>;
    final installationId = body['installationId'] as int;

    final env = EnvModel.fromEnvironment(
      DotEnv(includePlatformEnvironment: true)..load(),
    );

    final token =
        await accessToken(installationId, env.pemBase64, env.githubAppId);
    return Response(body: '{"installation_token":"$token"}');
  } catch (e) {
    return Response(body: 'Error: $e', statusCode: 500);
  }
}

import 'package:dotenv/dotenv.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'env_model.freezed.dart';
part 'env_model.g.dart';

@freezed
class EnvModel with _$EnvModel {
  const factory EnvModel({
    required String firebaseServiceAccountBase64,
    required String firebaseProjectName,
    required String pemBase64,
    required String githubAppId,
  }) = _EnvModel;
  factory EnvModel.fromJson(Map<String, Object?> json) =>
      _$EnvModelFromJson(json);

  factory EnvModel.fromEnvironment(DotEnv env) {
    final base64SA = env['FIREBASE_SERVICE_ACCOUNT_BASE64'];

    if (base64SA == null) {
      throw Exception("base64SA is null");
    }

    final firebaseProjectName = env['FIREBASE_PROJECT_NAME'];
    if (firebaseProjectName == null) {
      throw Exception("firebaseProjectName is null");
    }

    final base64Pem = env['PEM_BASE64'];

    if (base64Pem == null) {
      throw Exception("base64Pem is null");
    }

    final githubAppId = env['GITHUB_APP_ID'];
    if (githubAppId == null) {
      throw Exception("githubAppId is null");
    }
    return EnvModel(
      firebaseServiceAccountBase64: base64SA,
      firebaseProjectName: firebaseProjectName,
      pemBase64: base64Pem,
      githubAppId: githubAppId,
    );
  }
}

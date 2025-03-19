import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:openci_models/openci_models.dart';

part 'openci_user.freezed.dart';
part 'openci_user.g.dart';

@freezed
class OpenCIUser with _$OpenCIUser {
  const factory OpenCIUser({
    required String userId,
    required int createdAt,
    OpenCIUserGitHub? github,
  }) = _OpenCIUser;
  factory OpenCIUser.fromJson(Map<String, Object?> json) =>
      _$OpenCIUserFromJson(json);
}

@freezed
class OpenCIUserGitHub with _$OpenCIUserGitHub {
  const factory OpenCIUserGitHub({
    int? installationId,
    String? login,
    List<OpenCIRepository>? repositories,
    int? userId,
  }) = _OpenCIUserGitHub;
  factory OpenCIUserGitHub.fromJson(Map<String, Object?> json) =>
      _$OpenCIUserGitHubFromJson(json);
}

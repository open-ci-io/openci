import 'package:freezed_annotation/freezed_annotation.dart';

part 'openci_user.freezed.dart';
part 'openci_user.g.dart';

@freezed
class OpenCIUser with _$OpenCIUser {
  const factory OpenCIUser({
    required String userId,
    required int createdAt,
    required OpenCIUserGitHub github,
  }) = _OpenCIUser;
  factory OpenCIUser.fromJson(Map<String, Object?> json) =>
      _$OpenCIUserFromJson(json);
}

@freezed
class OpenCIUserGitHub with _$OpenCIUserGitHub {
  const factory OpenCIUserGitHub({
    required String repositoryUrl,
  }) = _OpenCIUserGitHub;
  factory OpenCIUserGitHub.fromJson(Map<String, Object?> json) =>
      _$OpenCIUserGitHubFromJson(json);
}

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:openci_models/src/github/repository.dart';

part 'user.g.dart';
part 'user.freezed.dart';

@freezed
abstract class OpenCIUserGitHub with _$OpenCIUserGitHub {
  const factory OpenCIUserGitHub({
    int? installationId,
    String? login,
    List<OpenCIGitHubRepository>? repositories,
    int? userId,
  }) = _OpenCIUserGitHub;
  factory OpenCIUserGitHub.fromJson(Map<String, Object?> json) =>
      _$OpenCIUserGitHubFromJson(json);
}

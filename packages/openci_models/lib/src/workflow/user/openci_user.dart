import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:openci_models/src/github/user.dart';

part 'openci_user.freezed.dart';
part 'openci_user.g.dart';

@freezed
abstract class OpenCIUser with _$OpenCIUser {
  const factory OpenCIUser({
    required String userId,
    required int createdAt,
    OpenCIUserGitHub? github,
  }) = _OpenCIUser;
  factory OpenCIUser.fromJson(Map<String, Object?> json) =>
      _$OpenCIUserFromJson(json);
}

import 'package:freezed_annotation/freezed_annotation.dart';

part 'openci_secret.freezed.dart';
part 'openci_secret.g.dart';

@freezed
class OpenCISecret with _$OpenCISecret {
  const factory OpenCISecret({
    required String key,
    required String value,
    required List<String> owners,
    required int createdAt,
    required int updatedAt,
  }) = _OpenCISecret;
  factory OpenCISecret.fromJson(Map<String, Object?> json) =>
      _$OpenCISecretFromJson(json);
}

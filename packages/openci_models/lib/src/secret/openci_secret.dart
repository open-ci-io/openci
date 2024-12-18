import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:openci_models/openci_models.dart';

part 'openci_secret.freezed.dart';
part 'openci_secret.g.dart';

@freezed
class OpenciSecret with _$OpenciSecret {
  const factory OpenciSecret({
    required String key,
    required String value,
    required List<String> owners,
    @DateTimeConverter() required DateTime createdAt,
    @DateTimeConverter() required DateTime updatedAt,
  }) = _OpenciSecret;
  factory OpenciSecret.fromJson(Map<String, Object?> json) =>
      _$OpenciSecretFromJson(json);
}

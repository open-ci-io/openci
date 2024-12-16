import 'package:dart_firebase_admin/firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:openci_models/openci_models.dart';

part 'command_log.freezed.dart';
part 'command_log.g.dart';

@freezed
class CommandLog with _$CommandLog {
  const factory CommandLog({
    required String command,
    required String log,
    @DateTimeConverter() required DateTime createdAt,
  }) = _CommandLog;

  factory CommandLog.fromJson(Map<String, Object?> json) =>
      _$CommandLogFromJson(json);
}

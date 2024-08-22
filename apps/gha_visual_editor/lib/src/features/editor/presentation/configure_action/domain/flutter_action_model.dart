import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gha_visual_editor/src/features/editor/presentation/configure_action/presentation/configure_action.dart';

part 'flutter_action_model.freezed.dart';
part 'flutter_action_model.g.dart';

@freezed
class FlutterActionModel with _$FlutterActionModel {
  const factory FlutterActionModel({
    @Default('Install Flutter') String title,
    @Default('https://github.com/subosito/flutter-action') String source,
    @Default('subosito/flutter-action@v2') String uses,
    @Default('Setup Flutter SDK') String name,
    @Default(FlutterChannel.stable) FlutterChannel channel,
    @Default('3.24.0') String flutterVersion,
    @Default(true) bool cache,
    @Default('default') String cacheKey,
  }) = _FlutterActionModel;
  factory FlutterActionModel.fromJson(Map<String, Object?> json) =>
      _$FlutterActionModelFromJson(json);
}

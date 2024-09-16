import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gha_visual_editor/src/features/editor/presentation/action/domain/action_model.dart';
import 'package:gha_visual_editor/src/features/editor/presentation/configure_workflow/domain/configure_first_action_domain.dart';

part 'editor_domain.freezed.dart';
part 'editor_domain.g.dart';

@freezed
class EditorDomain with _$EditorDomain {
  const factory EditorDomain({
    @Default(ConfigureFirstActionDomain())
    ConfigureFirstActionDomain firstAction,
    @Default([]) List<ActionModel> actionList,
  }) = _EditorDomain;
  factory EditorDomain.fromJson(Map<String, Object?> json) =>
      _$EditorDomainFromJson(json);
}

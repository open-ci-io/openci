import 'package:flutter/material.dart';
import 'package:gha_visual_editor/src/features/editor/presentation/action/domain/action_model.dart';
import 'package:gha_visual_editor/src/features/editor/presentation/editor_controller.dart';
import 'package:gha_visual_editor/src/features/editor/presentation/editor_page.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'configure_action_controller.g.dart';

@riverpod
class ConfigureActionController extends _$ConfigureActionController {
  @override
  ActionModel build(ActionModel action) {
    return action;
  }

  void updateValue(ActionModel value) {
    state = value;
  }

  void updateName(String value) {
    state = state.copyWith(name: value);
  }

  void updateProperties(ActionModelProperties value, int index) {
    state = state.copyWith(
      properties: [
        ...state.properties.sublist(0, index),
        value,
        ...state.properties.sublist(index + 1),
      ],
    );
  }

  void addNewSavedAction() {
    ref.watch(editorControllerProvider.notifier).addNewSavedAction(state);
  }

  void addNewKey() {
    keyListSignal.add(GlobalKey());
  }
}

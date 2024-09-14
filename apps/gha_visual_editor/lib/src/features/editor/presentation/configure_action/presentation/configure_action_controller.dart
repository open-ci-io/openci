import 'package:flutter/material.dart';
import 'package:gha_visual_editor/src/features/editor/presentation/editor_page.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'configure_action_controller.g.dart';

@riverpod
class ConfigureActionController extends _$ConfigureActionController {
  @override
  Map<String, dynamic> build(Map<String, dynamic> value) {
    return value;
  }

  void updateValue(Map<String, dynamic> value) {
    state = value;
  }

  void updateState({
    required FormStyle formStyle,
    required int index,
    required String label,
    required String newValue,
    List<String>? options,
  }) {
    final newProperties = state['properties'];
    if (options == null) {
      newProperties[index] = {
        'formStyle': formStyle.name,
        'label': label,
        'value': newValue,
      };
    } else {
      newProperties[index] = {
        'formStyle': formStyle.name,
        'label': label,
        'value': newValue,
        'options': options,
      };
    }

    state = {
      ...state,
      'properties': [
        ...state['properties'],
      ],
    };
  }

  void addNewSavedAction() {
    savedActionList.add(state);
  }

  void addNewKey() {
    keyListSignal.add(GlobalKey());
  }
}

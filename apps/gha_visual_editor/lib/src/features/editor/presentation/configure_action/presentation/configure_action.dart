import 'package:flutter/material.dart';
import 'package:gha_visual_editor/src/constants/margins.dart';
import 'package:gha_visual_editor/src/features/editor/presentation/configure_action/presentation/configure_action_controller.dart';
import 'package:gha_visual_editor/src/features/editor/presentation/configure_workflow/presentation/configure_first_action.dart';
import 'package:gha_visual_editor/src/features/editor/presentation/editor_page.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class ConfigureActions extends ConsumerWidget {
  const ConfigureActions({
    super.key,
    required this.action,
  });

  final Map<String, dynamic> action;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(configureActionControllerProvider(action));
    final controller =
        ref.watch(configureActionControllerProvider(action).notifier);
    final properties = state['properties'] as List;
    return Container(
      width: 500,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Colors.redAccent,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.inventory_2, color: Colors.white),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    state['title'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () async {
                      final url = Uri.parse(state['source']);
                      if (!await launchUrl(url)) {
                        throw Exception('Could not launch $url');
                      }
                    },
                    child: const Text(
                      'View source',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ],
          ),
          verticalMargin16,
          UsesField(label: 'uses', value: state['uses']),
          CustomTextField(
            label: 'name',
            value: state['name'],
            onChanged: (value) {
              controller.updateValue(
                {
                  ...state,
                  'name': value,
                },
              );
            },
          ),
          verticalMargin16,
          if (properties.isNotEmpty)
            ...properties.asMap().entries.map((e) {
              final index = e.key;
              final value = e.value;
              final formStyle = FormStyle.values.byName(value['formStyle']);
              final label = value['label'];
              final data = value['value'];

              switch (formStyle) {
                case FormStyle.dropDown:
                  final options = value['options'] as List<String>;
                  return DropdownMenu<String>(
                    inputDecorationTheme: InputDecorationTheme(
                      enabledBorder: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                    ),
                    initialSelection: data,
                    requestFocusOnTap: true,
                    label: Text(label),
                    onSelected: (newValue) {
                      if (newValue == null) {
                        return;
                      }
                      controller.updateState(
                        formStyle: FormStyle.dropDown,
                        index: index,
                        label: label,
                        newValue: newValue,
                        options: options,
                      );
                    },
                    dropdownMenuEntries:
                        options.map<DropdownMenuEntry<String>>((value) {
                      return DropdownMenuEntry(value: value, label: value);
                    }).toList(),
                  );
                case FormStyle.textField:
                  final data = value['value'];
                  return CustomTextField(
                    label: label,
                    value: data,
                    onChanged: (value) {
                      controller.updateState(
                        formStyle: FormStyle.textField,
                        index: index,
                        label: label,
                        newValue: value,
                      );
                    },
                  );
                case FormStyle.checkBox:
                  final data = bool.parse(value['value']);

                  return Column(
                    children: [
                      Text(label, style: const TextStyle(color: Colors.grey)),
                      Transform.scale(
                        scale: 0.8,
                        child: SizedBox(
                          width: 40,
                          child: Switch(
                            value: data,
                            onChanged: (bool value) {
                              controller.updateState(
                                formStyle: FormStyle.checkBox,
                                index: index,
                                label: label,
                                newValue: value.toString(),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  );
              }
            }),
          verticalMargin16,
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 200,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(8),
              ),
              child: ElevatedButton(
                onPressed: () {
                  controller.addNewSavedAction();
                  controller.addNewKey();

                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Done',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfigItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Widget _buildSecretItem(String label, {bool showDelete = false}) {
    return Row(
      children: [
        Checkbox(value: false, onChanged: (value) {}),
        const Icon(Icons.lock, size: 16, color: Colors.grey),
        const SizedBox(width: 8),
        Text(label),
        if (showDelete) ...[
          const Spacer(),
          const Icon(Icons.delete, size: 16, color: Colors.grey),
        ],
      ],
    );
  }
}

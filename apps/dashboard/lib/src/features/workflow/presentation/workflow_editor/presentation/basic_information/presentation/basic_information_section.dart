import 'package:dashboard/src/common_widgets/margins.dart';
import 'package:dashboard/src/features/navigation/presentation/navigation_page.dart';
import 'package:dashboard/src/features/workflow/presentation/workflow_editor/presentation/workflow_editor.dart';
import 'package:dashboard/src/features/workflow/presentation/workflow_editor/presentation/workflow_editor_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:openci_models/openci_models.dart';

class BasicInfoSection extends HookConsumerWidget {
  const BasicInfoSection(
    this.workflowModel,
    this.firebaseSuite, {
    super.key,
  });

  final WorkflowModel workflowModel;
  final OpenCIFirebaseSuite firebaseSuite;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(
      workflowEditorControllerProvider(workflowModel, firebaseSuite).notifier,
    );

    final workflowNameFocus = useFocusNode();
    final currentWorkingDirectoryFocus = useFocusNode();
    final flutterVersionFocus = useFocusNode();
    useListenable(workflowNameFocus);
    useListenable(currentWorkingDirectoryFocus);
    useListenable(flutterVersionFocus);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Basic Information',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          verticalMargin16,
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: TextFormField(
              focusNode: workflowNameFocus,
              initialValue: workflowModel.name,
              decoration: InputDecoration(
                labelText: 'Workflow Name',
                labelStyle: labelStyle(hasFocus: workflowNameFocus.hasFocus),
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter a workflow name';
                }
                return null;
              },
              onChanged: controller.updateWorkflowName,
            ),
          ),
          verticalMargin16,
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: DropdownButtonFormField<String>(
              focusNode: flutterVersionFocus,
              value: workflowModel.flutter.version,
              decoration: InputDecoration(
                labelText: 'Flutter Version',
                labelStyle: labelStyle(hasFocus: flutterVersionFocus.hasFocus),
              ),
              items: flutterVersionList.map((value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                controller.updateFlutterVersion(
                  value ?? flutterVersionList[0],
                );
              },
            ),
          ),
          verticalMargin16,
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: TextFormField(
              focusNode: currentWorkingDirectoryFocus,
              initialValue: workflowModel.currentWorkingDirectory,
              decoration: InputDecoration(
                labelText: 'Current Working Directory',
                labelStyle: labelStyle(
                  hasFocus: currentWorkingDirectoryFocus.hasFocus,
                ),
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter current working directory';
                }
                return null;
              },
              onChanged: controller.updateCurrentWorkingDirectory,
            ),
          ),
        ],
      ),
    );
  }
}

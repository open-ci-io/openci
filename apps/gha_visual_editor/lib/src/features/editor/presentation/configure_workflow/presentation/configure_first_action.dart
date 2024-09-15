import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gha_visual_editor/src/constants/margins.dart';
import 'package:gha_visual_editor/src/features/editor/presentation/configure_workflow/domain/workflow_domain.dart';
import 'package:gha_visual_editor/src/features/editor/presentation/configure_workflow/presentation/first_action_card_controller.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ConfigureFirstAction extends ConsumerWidget {
  const ConfigureFirstAction({
    super.key,
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(firstActionCardControllerProvider);
    final controller = ref.watch(firstActionCardControllerProvider.notifier);
    final workflow = state.workflow;
    final branch = state.branch;
    final buildMachine = state.buildMachine;
    return Container(
      width: 500,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextField(
            label: workflow.label,
            value: workflow.value,
            onChanged: (value) {
              controller.updateWorkflow(value);
            },
          ),
          verticalMargin16,
          DropdownMenu<OnPush>(
            initialSelection: OnPush.push,
            requestFocusOnTap: true,
            label: const Text('Run'),
            onSelected: (value) {
              if (value == null) return;
              controller.updateRun(value.name);
            },
            dropdownMenuEntries:
                OnPush.values.map<DropdownMenuEntry<OnPush>>((value) {
              return DropdownMenuEntry<OnPush>(
                value: value,
                label: value.name,
                enabled: true,
              );
            }).toList(),
          ),
          CustomTextField(
            label: branch.label,
            value: branch.value,
            onChanged: (value) {
              controller.updateBranch(value);
            },
          ),
          CustomTextField(
            label: buildMachine.label,
            value: buildMachine.value,
            onChanged: (value) {
              controller.updateBuildMachine(value);
            },
          ),
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
                onPressed: onTap,
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
}

class CustomTextField extends HookWidget {
  final String label;
  final String value;
  final ValueChanged<String>? onChanged;

  const CustomTextField({
    super.key,
    required this.label,
    required this.value,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController(text: value);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 4),
          TextField(
            controller: controller,
            onChanged: onChanged,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

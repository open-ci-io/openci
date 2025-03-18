import 'package:dashboard/src/common_widgets/dialogs/custom_wolt_modal_dialog.dart';
import 'package:dashboard/src/common_widgets/margins.dart';
import 'package:dashboard/src/features/workflow/presentation/workflow_list/presentation/create_workflow_dialog/presentation/create_workflow_dialog_controller.dart';
import 'package:dashboard/src/features/workflow/presentation/workflow_list/presentation/create_workflow_dialog/presentation/dialogs/select_distribution.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:openci_models/openci_models.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

WoltModalSheetPage selectFlutterBuildIpaData(
  BuildContext modalSheetContext,
  String selectedRepository,
) {
  final workflowNameEditingController = TextEditingController();
  final flutterBuildCommandEditingController = TextEditingController();
  final cwdEditingController = TextEditingController();
  final baseBranchEditingController = TextEditingController();

  void updateState(WidgetRef ref) {
    ref.read(
        createWorkflowDialogControllerProvider(selectedRepository).notifier)
      ..setFlutterBuildIpaWorkflowName(
        workflowNameEditingController.text,
      )
      ..setFlutterBuildIpaFlutterBuildCommand(
        flutterBuildCommandEditingController.text,
      )
      ..setFlutterBuildIpaCwd(
        cwdEditingController.text,
      )
      ..setFlutterBuildIpaBaseBranch(
        baseBranchEditingController.text,
      );
  }

  return baseDialog(
    onBack: (ref) {
      updateState(ref);
      WoltModalSheet.of(modalSheetContext).popPage();
    },
    onNext: (ref, formKey) {
      if (formKey.currentState!.validate()) {
        formKey.currentState!.save();
        updateState(ref);

        WoltModalSheet.of(modalSheetContext).pushPage(
          selectDistribution(modalSheetContext, selectedRepository),
        );
      }
    },
    child: (ref) {
      return _Body(
        workflowNameEditingController: workflowNameEditingController,
        flutterBuildCommandEditingController:
            flutterBuildCommandEditingController,
        cwdEditingController: cwdEditingController,
        baseBranchEditingController: baseBranchEditingController,
        selectedRepository: selectedRepository,
      );
    },
    modalSheetContext: modalSheetContext,
    title: 'Select Flutter Build .ipa Data',
  );
}

class _Body extends StatefulHookConsumerWidget {
  const _Body({
    required this.workflowNameEditingController,
    required this.flutterBuildCommandEditingController,
    required this.cwdEditingController,
    required this.baseBranchEditingController,
    required this.selectedRepository,
  });

  final TextEditingController workflowNameEditingController;
  final TextEditingController flutterBuildCommandEditingController;
  final TextEditingController cwdEditingController;
  final TextEditingController baseBranchEditingController;
  final String selectedRepository;

  @override
  ConsumerState<_Body> createState() => _BodyState();
}

class _BodyState extends ConsumerState<_Body> {
  @override
  Widget build(BuildContext context) {
    final state = ref
        .watch(
            createWorkflowDialogControllerProvider(widget.selectedRepository))
        .flutterBuildIpaData;
    useEffect(
      () {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          widget.workflowNameEditingController.text = state.workflowName;
          widget.flutterBuildCommandEditingController.text =
              state.flutterBuildCommand;
          widget.cwdEditingController.text = state.cwd;
          widget.baseBranchEditingController.text = state.baseBranch;
        });

        return null;
      },
      [],
    );
    return Column(
      children: [
        TextFormField(
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w300,
          ),
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.all(18),
            labelText: 'Workflow Name',
          ),
          controller: widget.workflowNameEditingController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Workflow name is required';
            }
            return null;
          },
        ),
        verticalMargin24,
        TextFormField(
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w300,
          ),
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.all(18),
            labelText: 'flutter build command',
          ),
          controller: widget.flutterBuildCommandEditingController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Flutter build command is required';
            }
            return null;
          },
        ),
        verticalMargin24,
        TextField(
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w300,
          ),
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.all(18),
            labelText: 'current working directory',
            helperText: 'leave blank for non-monorepo',
          ),
          controller: widget.cwdEditingController,
        ),
        verticalMargin24,
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<GitHubTriggerType>(
                value: state.triggerType,
                style: const TextStyle(fontWeight: FontWeight.w300),
                decoration: const InputDecoration(
                  labelText: 'Trigger Type',
                ),
                items: GitHubTriggerType.values.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type.name),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    ref
                        .read(
                          createWorkflowDialogControllerProvider(
                            widget.selectedRepository,
                          ).notifier,
                        )
                        .setFlutterBuildIpaTriggerType(value);
                  }
                },
              ),
            ),
            horizontalMargin16,
            Expanded(
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Base branch is required';
                  }
                  return null;
                },
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                ),
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(18),
                  labelText: 'base branch',
                ),
                controller: widget.baseBranchEditingController,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

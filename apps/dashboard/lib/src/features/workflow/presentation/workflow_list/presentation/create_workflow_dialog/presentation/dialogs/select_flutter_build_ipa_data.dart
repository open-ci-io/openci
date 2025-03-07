import 'package:dashboard/src/common_widgets/dialogs.dart';
import 'package:dashboard/src/common_widgets/margins.dart';
import 'package:dashboard/src/features/workflow/presentation/workflow_list/presentation/create_workflow_dialog/presentation/dialogs/select_distribution.dart';
import 'package:flutter/material.dart';
import 'package:openci_models/openci_models.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

WoltModalSheetPage selectFlutterBuildIpaData(
  BuildContext modalSheetContext,
  TextTheme textTheme,
) {
  final workflowNameEditingController =
      TextEditingController(text: 'Release iOS build');
  final flutterBuildCommandEditingController = TextEditingController(
    text: 'flutter build ipa',
  );
  final cwdEditingController = TextEditingController(text: '');
  final baseBranchEditingController = TextEditingController(text: 'main');

  return baseDialog(
    onBack: (ref) => WoltModalSheet.of(modalSheetContext).popPage(),
    onNext: (ref, formKey) {
      if (formKey.currentState!.validate()) {
        formKey.currentState!.save();
        WoltModalSheet.of(modalSheetContext).pushPage(
          selectDistribution(modalSheetContext, textTheme),
        );
      }
    },
    child: (ref) {
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
            controller: workflowNameEditingController,
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
            controller: flutterBuildCommandEditingController,
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
            controller: cwdEditingController,
          ),
          verticalMargin24,
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<GitHubTriggerType>(
                  value: GitHubTriggerType.push,
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
                  onChanged: (value) {},
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
                  controller: baseBranchEditingController,
                ),
              ),
            ],
          ),
        ],
      );
    },
    modalSheetContext: modalSheetContext,
    textTheme: textTheme,
    title: 'Select Flutter Build .ipa Data',
    leftButtonTextButton:
        TextButton(onPressed: () {}, child: const Text('Back')),
    rightButtonTextButton: TextButton(
      onPressed: () {
        // final provider = ProviderContainer();
        // if (formKey.currentState!.validate()) {
        //   formKey.currentState!.save();
        //   provider
        //       .read(createWorkflowDialogControllerProvider.notifier)
        //       .setFlutterBuildIpaData(
        //         FlutterBuildIpaData(
        //           workflowName: workflowNameEditingController.text,
        //           flutterBuildCommand:
        //               flutterBuildCommandEditingController.text,
        //           cwd: cwdEditingController.text,
        //           baseBranch: baseBranchEditingController.text,
        //         ),
        //       );

        //   WoltModalSheet.of(modalSheetContext).pushPage(
        //     selectDistribution(modalSheetContext, textTheme),
        //   );
        // }
      },
      child: const Text('Next'),
    ),
    builder: (context, ref, child) {
      return const SizedBox.shrink();
    },
  );
}

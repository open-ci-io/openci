import 'package:dashboard/src/common_widgets/margins.dart';
import 'package:dashboard/src/common_widgets/openci_dialog.dart';
import 'package:dashboard/src/features/workflow/presentation/create_workflow/presentation/pages/enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:openci_models/openci_models.dart';
import 'package:signals/signals_flutter.dart';

class FlutterBuildIpa extends HookWidget {
  const FlutterBuildIpa({
    super.key,
    required this.currentPage,
    required this.workflowName,
    required this.flutterBuildIpaCommand,
    required this.cwd,
    required this.baseBranch,
    required this.githubTriggerType,
  });

  final Signal<PageEnum> currentPage;
  final Signal<String> workflowName;
  final Signal<String> flutterBuildIpaCommand;
  final Signal<String> cwd;
  final Signal<String> baseBranch;
  final Signal<GitHubTriggerType> githubTriggerType;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final workflowNameEditingController =
        useTextEditingController(text: workflowName.value);
    final flutterBuildCommandEditingController =
        useTextEditingController(text: flutterBuildIpaCommand.value);
    final cwdEditingController = useTextEditingController(text: cwd.value);
    final baseBranchEditingController =
        useTextEditingController(text: baseBranch.value);
    return OpenCIDialog(
      title: Text(
        'Flutter Build .ipa',
        style: textTheme.titleLarge,
      ),
      children: [
        TextField(
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w300,
          ),
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.all(18),
            labelText: 'Workflow Name',
          ),
          controller: workflowNameEditingController,
        ),
        verticalMargin24,
        TextField(
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w300,
          ),
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.all(18),
            labelText: 'flutter build command',
          ),
          controller: flutterBuildCommandEditingController,
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
                onChanged: (value) {
                  githubTriggerType.value = value ?? GitHubTriggerType.push;
                },
              ),
            ),
            horizontalMargin16,
            Expanded(
              child: TextField(
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
        verticalMargin16,
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {
                currentPage.value = PageEnum.checkASCKeyUpload;
              },
              child: const Text(
                'Back',
                style: TextStyle(fontWeight: FontWeight.w300),
              ),
            ),
            horizontalMargin8,
            TextButton(
              onPressed: () async {
                workflowName.value = workflowNameEditingController.text;
                flutterBuildIpaCommand.value =
                    flutterBuildCommandEditingController.text;
                cwd.value = cwdEditingController.text;
                baseBranch.value = baseBranchEditingController.text;
                currentPage.value = PageEnum.distribution;
              },
              child: const Text(
                'Save',
                style: TextStyle(fontWeight: FontWeight.w300),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

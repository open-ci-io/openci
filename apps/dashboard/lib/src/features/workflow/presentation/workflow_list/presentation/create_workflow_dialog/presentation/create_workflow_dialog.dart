import 'package:dashboard/colors.dart';
import 'package:dashboard/src/common_widgets/margins.dart';
import 'package:dashboard/src/features/workflow/presentation/workflow_list/presentation/create_workflow_dialog/presentation/create_workflow_dialog_controller.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

const double _bottomPaddingForButton = 100;
const double _pagePadding = 16;

enum OpenCIWorkflowTemplate {
  ipa,
  blank;

  String get title {
    switch (this) {
      case OpenCIWorkflowTemplate.ipa:
        return 'Release iOS App';
      case OpenCIWorkflowTemplate.blank:
        return 'From Scratch';
    }
  }
}

WoltModalSheetPage chooseWorkflowTemplate(
  BuildContext modalSheetContext,
  TextTheme textTheme,
) {
  return baseDialog(
    modalSheetContext: modalSheetContext,
    textTheme: textTheme,
    title: 'Choose a Workflow Template',
    leftButtonTextButton: TextButton(
      onPressed: () => Navigator.of(modalSheetContext).pop(),
      child: const Text(
        'Cancel',
        style: TextStyle(
          color: OpenCIColors.error,
          fontWeight: FontWeight.w300,
        ),
      ),
    ),
    rightButtonTextButton: TextButton(
      onPressed: () {},
      child: const Text(
        'Next',
        style: TextStyle(
          fontWeight: FontWeight.w300,
        ),
      ),
    ),
    builder: (context, ref, child) {
      final controller =
          ref.watch(createWorkflowDialogControllerProvider.notifier);
      final state = ref.watch(createWorkflowDialogControllerProvider);
      return Column(
        children: <Widget>[
          RadioListTile<OpenCIWorkflowTemplate>(
            title: Text(OpenCIWorkflowTemplate.ipa.title),
            value: OpenCIWorkflowTemplate.ipa,
            groupValue: state.template,
            onChanged: (OpenCIWorkflowTemplate? value) {
              if (value == null) {
                return;
              }
              controller.setTemplate(value);
            },
          ),
          RadioListTile<OpenCIWorkflowTemplate>(
            title: Text(OpenCIWorkflowTemplate.blank.title),
            value: OpenCIWorkflowTemplate.blank,
            groupValue: state.template,
            onChanged: (OpenCIWorkflowTemplate? value) {
              if (value == null) {
                return;
              }
              controller.setTemplate(value);
            },
          ),
        ],
      );
    },
  );
}

WoltModalSheetPage baseDialog({
  required BuildContext modalSheetContext,
  required TextTheme textTheme,
  required String title,
  required TextButton leftButtonTextButton,
  required TextButton rightButtonTextButton,
  required Widget Function(BuildContext, WidgetRef, Widget?) builder,
}) {
  return WoltModalSheetPage(
    hasSabGradient: false,
    stickyActionBar: Padding(
      padding: const EdgeInsets.all(32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          leftButtonTextButton,
          horizontalMargin16,
          rightButtonTextButton,
        ],
      ),
    ),
    topBarTitle: Text(title, style: textTheme.titleSmall),
    isTopBarLayerAlwaysVisible: true,
    trailingNavBarWidget: IconButton(
      padding: const EdgeInsets.all(_pagePadding),
      icon: const Icon(Icons.close),
      onPressed: Navigator.of(modalSheetContext).pop,
    ),
    child: Padding(
      padding: const EdgeInsets.fromLTRB(
        _pagePadding,
        _pagePadding,
        _pagePadding,
        _bottomPaddingForButton,
      ),
      child: Consumer(
        builder: builder,
      ),
    ),
  );
}

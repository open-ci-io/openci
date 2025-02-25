import 'package:dashboard/src/common_widgets/margins.dart';
import 'package:dashboard/src/common_widgets/openci_dialog.dart';
import 'package:dashboard/src/features/workflow/presentation/create_workflow/presentation/pages/enum.dart';
import 'package:flutter/material.dart';
import 'package:openci_models/openci_models.dart';
import 'package:signals/signals_flutter.dart';

class Distribution extends StatelessWidget {
  const Distribution({
    super.key,
    required this.appDistributionTarget,
    required this.currentPage,
  });

  final Signal<OpenCIAppDistributionTarget> appDistributionTarget;
  final Signal<PageEnum> currentPage;

  @override
  Widget build(BuildContext context) {
    return OpenCIDialog(
      title: const Text('Distribution'),
      children: [
        // TODO(maffreud): add firebase app distribution support
        // RadioListTile<OpenCIAppDistributionTarget>(
        //   title: const Text('Firebase App Distribution'),
        //   value: OpenCIAppDistributionTarget.firebaseAppDistribution,
        //   groupValue: appDistributionTarget.value,
        //   onChanged: (OpenCIAppDistributionTarget? value) {
        //     if (value != null) {
        //       appDistributionTarget.value = value;
        //     }
        //   },
        // ),
        RadioListTile<OpenCIAppDistributionTarget>(
          title: Text(OpenCIAppDistributionTarget.testflight.name),
          value: OpenCIAppDistributionTarget.testflight,
          groupValue: appDistributionTarget.value,
          onChanged: (OpenCIAppDistributionTarget? value) {
            if (value != null) {
              appDistributionTarget.value = value;
            }
          },
        ),
        RadioListTile<OpenCIAppDistributionTarget>(
          title: Text(OpenCIAppDistributionTarget.none.name),
          value: OpenCIAppDistributionTarget.none,
          groupValue: appDistributionTarget.value,
          onChanged: (OpenCIAppDistributionTarget? value) {
            if (value != null) {
              appDistributionTarget.value = value;
            }
          },
        ),
        verticalMargin16,
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {
                currentPage.value = PageEnum.flutterBuildIpa;
              },
              child: const Text(
                'Back',
                style: TextStyle(fontWeight: FontWeight.w300),
              ),
            ),
            horizontalMargin8,
            TextButton(
              onPressed: () async {
                currentPage.value = PageEnum.result;
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

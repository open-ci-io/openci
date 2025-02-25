import 'package:dashboard/src/common_widgets/margins.dart';
import 'package:dashboard/src/common_widgets/openci_dialog.dart';
import 'package:dashboard/src/features/workflow/presentation/create_workflow/presentation/pages.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:signals/signals_flutter.dart';

class ChooseTemplate extends StatelessWidget {
  const ChooseTemplate({
    super.key,
    required this.currentPage,
  });

  final Signal<PageEnum> currentPage;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return OpenCIDialog(
      title: Text(
        'Choose a template',
        style: textTheme.titleLarge,
      ),
      children: [
        TextButton(
          onPressed: () {
            // check ASC keys
            currentPage.value = PageEnum.checkASCKeyUpload;
          },
          child: const ListTile(
            title: Text('Release .ipa'),
            leading: Icon(FontAwesomeIcons.apple),
          ),
        ),
        verticalMargin8,
        TextButton(
          onPressed: () {},
          child: const ListTile(
            title: Text('Release .apk'),
            leading: Icon(FontAwesomeIcons.android),
          ),
        ),
        verticalMargin8,
        TextButton(
          onPressed: () {},
          child: const ListTile(
            title: Text('From scratch'),
            leading: Icon(FontAwesomeIcons.pen),
          ),
        ),
        verticalMargin16,
      ],
    );
  }
}

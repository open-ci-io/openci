import 'package:gha_visual_editor/src/features/editor/presentation/action/domain/action_model.dart';

class ActionList {
  static const installFlutter = ActionModel(
      title: 'Install Flutter',
      source: 'https://github.com/subosito/flutter-action',
      name: 'Setup Flutter SDK',
      uses: 'subosito/flutter-action@v2',
      properties: [
        ActionModelProperties(
          formStyle: FormStyle.dropDown,
          label: 'channel',
          options: ['stable', 'beta', 'dev', 'master'],
          value: 'stable',
        ),
        ActionModelProperties(
          formStyle: FormStyle.textField,
          label: 'Flutter Version',
          value: '3.22.2',
        ),
        ActionModelProperties(
          formStyle: FormStyle.checkBox,
          label: 'Cache',
          value: 'false',
        ),
        ActionModelProperties(
          formStyle: FormStyle.textField,
          label: 'Cache Key',
          value: 'default',
        )
      ]);

  static const flutterPubGet = ActionModel(
      title: 'Flutter Pub Get',
      source: 'none',
      name: 'Install dependencies',
      uses: 'custom',
      properties: []);

  static const checkoutCode = ActionModel(
      title: 'checkout',
      source: 'https://github.com/actions/checkout',
      name: 'Checkout the source code',
      uses: 'actions/checkout@v4',
      properties: []);
}

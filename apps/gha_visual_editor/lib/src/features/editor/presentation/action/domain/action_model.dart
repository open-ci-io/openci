import 'package:freezed_annotation/freezed_annotation.dart';

part 'action_model.freezed.dart';
part 'action_model.g.dart';

@freezed
class ActionModel with _$ActionModel {
  const factory ActionModel({
    required String title,
    required String source,
    required String name,
    required String uses,
    @Default([]) List<ActionModelProperties> properties,
  }) = _ActionModel;
  factory ActionModel.fromJson(Map<String, Object?> json) =>
      _$ActionModelFromJson(json);
}

@freezed
class ActionModelProperties with _$ActionModelProperties {
  const factory ActionModelProperties({
    required FormStyle formStyle,
    required String label,
    required String value,
    required String key,
    @Default([]) List<String> options,
  }) = _ActionModelProperties;
  factory ActionModelProperties.fromJson(Map<String, Object?> json) =>
      _$ActionModelPropertiesFromJson(json);
}

enum FormStyle {
  dropDown,
  textField,
  checkBox,
}

final installFlutterMap = {
  'title': 'Install Flutter',
  'source': 'https://github.com/subosito/flutter-action',
  'name': 'Setup Flutter SDK',
  'uses': 'subosito/flutter-action@v2',
  'properties': [
    {
      'formStyle': 'dropDown',
      'label': 'channel',
      'options': ['stable', 'beta', 'dev', 'master'],
      'value': 'stable',
    },
    {
      'formStyle': 'textField',
      'label': 'Flutter Version',
      'value': '3.22.2',
    },
    {
      'formStyle': 'checkBox',
      'label': 'Cache',
      'value': 'false',
    },
    {
      'formStyle': 'textField',
      'label': 'Cache Key',
      'value': 'default',
    }
  ],
};

final flutterPubGetMap = {
  'title': 'Flutter Pub Get',
  'source': 'none',
  'name': 'Install dependencies',
  'uses': 'custom',
  'properties': [],
};

final checkoutCode = {
  'title': 'checkout',
  'source': 'https://github.com/actions/checkout',
  'name': 'Checkout the source code',
  'uses': 'actions/checkout@v4',
  'properties': [],
};

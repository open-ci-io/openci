import 'package:freezed_annotation/freezed_annotation.dart';

enum FlutterVersion {
  v3_19_5,
  v3_24_4,
  v3_27_1;

  String get stringValue {
    return name.split('_').join('.').replaceAll('v', '');
  }

  static FlutterVersion getDefault() {
    return values.first;
  }

  static FlutterVersion fromString(String string) {
    return FlutterVersionConverter().fromJson(string);
  }
}

class FlutterVersionConverter implements JsonConverter<FlutterVersion, String> {
  const FlutterVersionConverter();

  @override
  FlutterVersion fromJson(String json) {
    for (final version in FlutterVersion.values) {
      if (version.stringValue == json) {
        return version;
      }
    }
    return FlutterVersion.getDefault();
  }

  @override
  String toJson(FlutterVersion object) {
    return object.stringValue;
  }
}

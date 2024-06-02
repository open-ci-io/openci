import 'package:openci_runner/src/features/runner/android/domain/android_runner.dart';

class AndroidArguments {
  static AndroidRunner get firebaseProjectName {
    const key = 'firebaseProjectName';
    const name = 'Firebase Project Name';
    return const AndroidRunner(
      key: key,
      error: '''
$name($key) has not been set.
$name($key)を指定してください。,
''',
    );
  }
}

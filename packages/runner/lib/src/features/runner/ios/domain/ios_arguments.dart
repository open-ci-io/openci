import 'package:openci_runner/src/features/runner/ios/domain/ios_runner.dart';

class IosArguments {
  static IosRunner get supabaseUrl {
    const key = 'supabaseUrl';
    const name = 'Supabase URL';
    return const IosRunner(
      key: key,
      error: '''
$name($key) has not been set.
$name($key)を指定してください。,
''',
    );
  }

  static IosRunner get supabaseApiKey {
    const key = 'supabaseApiKey';
    const name = 'Supabase API KEY';
    return const IosRunner(
      key: key,
      error: '''
$name($key) has not been set.
$name($key)を指定してください。,
''',
    );
  }

  static IosRunner get supabaseSignInEmail {
    const key = 'supabaseSignInEmail';
    const name = 'Supabase Sign In Email';
    return const IosRunner(
      key: key,
      error: '''
$name($key) has not been set.
$name($key)を指定してください。,
''',
    );
  }

  static IosRunner get supabaseSignInPassword {
    const key = 'supabaseSignInPassword';
    const name = 'Supabase Sign In Password';
    return const IosRunner(
      key: key,
      error: '''
$name($key) has not been set.
$name($key)を指定してください。,
''',
    );
  }

  static IosRunner get icloudKeychainPassword {
    const key = 'icloudKeychainPassword';
    const name = 'iCloud Keychain Password';
    return const IosRunner(
      key: key,
      error: '''
$name($key) has not been set.
$name($key)を指定してください。,
''',
    );
  }
}

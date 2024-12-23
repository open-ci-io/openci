## 0.8.16

- fix: command log

## 0.8.15

- update: openci_models

## 0.8.14

- update: openci_models

## 0.8.13

- feat: support secret

## 0.8.12

- fix: command log

## 0.8.11

- update README

## 0.8.10

- fix: #110

## 0.8.9

- fix: #105

## 0.8.8

- fix: command log

## 0.8.7

- fix: command log

## 0.8.6

- fix: command log

## 0.8.5

- fix: workflow runner

## 0.8.4

- fix: update build status

## 0.8.3

- fix: update build status

## 0.8.2

- fix: tart runner

## 0.8.1

- fix: tart vm name

## 0.8.0

- update: CLI

## 0.7.6

- update

## 0.7.5

- refactor: remove get_it and unused packages
- fix: stop using firestore trigger and start to use REST APIs written in Dart
- fix: remove unused code

## 0.7.4

- Drop support of aab build temporarily

## 0.7.3

- feat: update custom script for ios

## 0.7.2

- fix: Disable Shorebird support

## 0.7.1

- fix: logic of incrementing build number

## 0.7.0

- auto reboot
- faster build time
- fix lots of bugs
- refactor

## 0.6.8

- close #124

This pull request introduces a new feature to the `openci_runner` project: the
integration of Sentry for error tracking. The changes are mostly concentrated in
the `runner_command.dart` file, where the command-line arguments have been
updated to include Sentry's DSN and Firestore's database ID. The `CHANGELOG.md`
and `pubspec.yaml` files have also been updated to reflect the new version and
the addition of the Sentry package.

Main changes:

- [`CHANGELOG.md`](diffhunk://#diff-06572a96a58dc510037d5efa622f9bec8519bc1beab13c9f251e97e657a9d4edR1-R4):
  Updated the changelog with the new version (0.6.8) and the addition of the
  Sentry feature.

Updates to `lib/src/features/runner/runner_command.dart`:

- Introduced a new `AppConfig` class that includes the Firebase project name,
  Firebase service account JSON, Firestore database ID, and Sentry DSN.
- Updated the `RunnerCommand` class to replace flags with options for the
  Firebase project name and service account JSON. Also added options for the
  Sentry DSN and Firestore database ID.
- Added a new `initializeApp` method to validate and initialize the application
  configuration.
- Refactored the `run` method to use the new `AppConfig` class and initialize
  the Firebase Admin App and Firestore with the new configuration.
- Added a process exit when the SIGINT signal is received.

Removals:

- [`lib/src/features/runner/runner_controller.dart`](diffhunk://#diff-05591da6f8536c76638426faef6bca0e0ef2a059ec5b194d564e5eb6f37515ecL1-L26):
  Removed the `RunnerController` class as it is no longer needed after the
  refactoring in `runner_command.dart`.

Updates to `pubspec.yaml`:

- Updated the version of the `openci_runner` package to 0.6.8.
- Added the Sentry package to the dependencies.

## 0.6.7

- feat: aut-reboot
  ([#111](https://github.com/open-ci-io/openci_runner/issues/111))

## 0.6.6

- feat: delete unused tart VM
  ([#120](https://github.com/open-ci-io/openci_runner/issues/120))

## 0.6.5

- fix: Remove wait 20 seconds for vm start
  ([#77](https://github.com/open-ci-io/openci_runner/issues/77))

## 0.6.4

- refactor

## 0.6.3

- fix: openci_runner doesn't import p8
  ([#116](https://github.com/open-ci-io/openci_runner/issues/116))

## 0.6.2

- feat: Allow dynamic build name.
  ([#113](https://github.com/open-ci-io/openci_runner/issues/113))

- feat: shellV2 command should return stdout, stderr, and exitCode.
  ([#114](https://github.com/open-ci-io/openci_runner/issues/114))

## 0.6.1

- Refactor

## 0.6.0

- OpenCI now supports ios build

## 0.5.1

- fix bug

## 0.5.0

- jobs is now v2

## 0.4.2

- fix minor bug

## 0.4.1

- fix minor bug

## 0.4.0

- openci_runner now stores logs in cloud firestore.
  ([#17](https://github.com/open-ci-io/openci_runner/issues/17))

## 0.3.2

- fix: Unable to distribute apk to firebase tester group.
  ([#83](https://github.com/open-ci-io/openci_runner/issues/83))

## 0.3.1

- fix: Unable to build dev flavor.
  ([#81](https://github.com/open-ci-io/openci_runner/issues/81))

## 0.3.0

- fix: firebase cli should use service_account instead of cli token.
  ([#78](https://github.com/open-ci-io/openci_runner/issues/78))
- fix: jks file name and path should be dynamic.
  ([#76](https://github.com/open-ci-io/openci_runner/issues/76))
- fix: fvm doesn't work.
  ([#74](https://github.com/open-ci-io/openci_runner/issues/74))

## 0.2.12

- add: FVM to change Flutter version.
  ([#7](https://github.com/open-ci-io/openci_runner/issues/7))

## 0.2.11

- fix: UserData does not accept null value.
  ([#69](https://github.com/open-ci-io/openci_runner/issues/69))

## 0.2.10

- fix: Unable to get a job.
  ([#57](https://github.com/open-ci-io/openci_runner/issues/57))

## 0.2.9

- fix: Null job message"job is null, waiting 10 seconds for next check." is too
  redundant. ([#51](https://github.com/open-ci-io/openci_runner/issues/51))

## 0.2.8

- fix: VM won't be shut down and deleted if build fails
  ([#54](https://github.com/open-ci-io/openci_runner/issues/54))

## 0.2.7

- fix: tart VM won't be shut down and deleted automatically after the build is
  complete. ([#52](https://github.com/open-ci-io/openci_runner/issues/52))

## 0.2.6

- fix: openci_runner doesn't find a new job after one job has been successfully
  finished ([#49](https://github.com/open-ci-io/openci_runner/issues/49))

## 0.2.5

- feat: flavor support (only prod or null env)
  ([#21](https://github.com/open-ci-io/openci_runner/issues/21))

## 0.2.4

- update: README.md

## 0.2.2

- fix: How to use service_account json?
  ([#44](https://github.com/open-ci-io/openci_runner/issues/44))

## 0.2.1

- fix: Unable to skip build for android runner
  ([#39](https://github.com/open-ci-io/openci_runner/issues/39))

## 0.2.0

- feat: Use Firestore as a Backend instead of Supabase
  ([#30](https://github.com/open-ci-io/openci_runner/issues/30))
- fix: Build Times were always wrong.
  ([#27](https://github.com/open-ci-io/openci_runner/issues/27))
- fix: use firebase cli to upload aab/apk to Firebase App Distribution
  ([#25](https://github.com/open-ci-io/openci_runner/issues/25))

## 0.1.3

- add: flutter clean step before building aab/ipa.

## 0.1.2

- fix: Unable to launch multiple VMs on MacMini
  ([#14](https://github.com/open-ci-io/openci_runner/issues/14))

## 0.1.1

- Update

## 0.1.0

- Initial version.

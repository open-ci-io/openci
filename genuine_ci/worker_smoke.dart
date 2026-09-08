import 'package:genuine_ci/genuine_ci.dart';

Future<void> main() async {
  final genuineCI = await GenuineCI.init(
    workflowName: 'Build job worker smoke',
    ciTrigger: CiTrigger.push(branch: 'test/build-job-worker-smoke'),
  );

  await genuineCI.run('sw_vers');
  await genuineCI.run('flutter --version');
  await genuineCI.run(
    'dart test --reporter=expanded',
    workingDirectory: 'apps/build_job_worker',
  );
}

import 'package:runner/src/commands/signals.dart';
import 'package:runner/src/features/build_job/update_checks.dart';

Future<void> finishJob(String jobId) async {
  await vmServiceSignal.value.stopVM();
  await setSuccess(jobId);
}

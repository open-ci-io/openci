import 'package:dart_firebase_admin/firestore.dart';
import 'package:openci_models/openci_models.dart';
import 'package:openci_runner/src/clone_repo.dart';
import 'package:openci_runner/src/initialize_vm.dart';
import 'package:openci_runner/src/run_multi_commands.dart';

Future<void> processBuildJob(
  BuildJob buildJob,
  Firestore firestore,
  String pem,
  String vmName,
  String logId,
) async {
  final client = await initializeVM(vmName, buildJob, logId, pem);

  await cloneRepo(buildJob, logId, client, pem);

  await runMultiCommands(
    firestore,
    logId,
    buildJob.id,
    client,
    buildJob,
  );
}

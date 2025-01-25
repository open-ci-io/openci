import 'dart:async';

import 'package:dart_firebase_admin_plus/firestore.dart';
import 'package:openci_models/openci_models.dart';
import 'package:openci_runner/src/initialize_vm.dart';
import 'package:openci_runner/src/run_commands.dart';

Future<void> processBuildJob(
  BuildJob buildJob,
  Firestore firestore,
  String pem,
  String vmName,
  String logId,
) async {
  final client = await initializeVM(vmName, buildJob, logId, pem);

  await runCommands(
    firestore,
    logId,
    buildJob.id,
    client,
    buildJob,
  );
}

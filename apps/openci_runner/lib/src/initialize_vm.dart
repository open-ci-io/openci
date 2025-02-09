import 'dart:async';

import 'package:dartssh2/dartssh2.dart';
import 'package:openci_models/openci_models.dart';
import 'package:openci_runner/src/clone_repo.dart';
import 'package:openci_runner/src/features/tart_vm/clone_vm.dart';
import 'package:openci_runner/src/features/tart_vm/get_vm_ip.dart';
import 'package:openci_runner/src/features/tart_vm/run_vm.dart';
import 'package:openci_runner/src/log.dart';

Future<SSHClient> initializeVM(
  String vmName,
  BuildJob buildJob,
  String logId,
  String pem,
) async {
  await cloneVM(vmName);
  unawaited(runVM(vmName));
  final vmIp = await getVMIp(vmName);
  openciLog('VM IP: $vmIp');
  openciLog('VM is ready', isSuccess: true);

  final client = SSHClient(
    await SSHSocket.connect(vmIp, 22),
    username: 'admin',
    onPasswordRequest: () => 'admin',
  );

  await cloneRepo(buildJob, logId, client, pem);

  return client;
}

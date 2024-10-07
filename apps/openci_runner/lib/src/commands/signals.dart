import 'package:dart_firebase_admin/firestore.dart';
import 'package:dartssh2/dartssh2.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:runner/src/services/shell/local_shell_service.dart';
import 'package:runner/src/services/shell/ssh_shell_service.dart';
import 'package:runner/src/services/tart/tart_service.dart';
import 'package:runner/src/services/uuid/uuid_service.dart';
import 'package:runner/src/services/vm_service.dart';
import 'package:signals_core/signals_core.dart';

final shouldExitSignal = signal(false);
final isSearchingSignal = signal(false);
final progressSignal = signal<Progress?>(null);
final workingVMNameSignal = signal(UuidService.generateV4());
final supabaseRowIdSignal = signal<int?>(null);
final sshClientSignal = signal<SSHClient?>(null);
final localShellServiceSignal = signal(LocalShellService());
final tartServiceSignal = signal(TartService(localShellServiceSignal.value));
final vmServiceSignal = signal(VMService(tartServiceSignal.value));
final sshSignal = sshShellServiceSignal.value;
final isDebugMode = signal(true);

final isDebugSignal = signal(false);
final firestoreClientSignal = signal<Firestore?>(null);

final nonNullFirestoreClientSignal = computed(() {
  final client = firestoreClientSignal.value;
  if (client == null) {
    throw Exception('Firestore client is not initialized');
  }
  return client;
});

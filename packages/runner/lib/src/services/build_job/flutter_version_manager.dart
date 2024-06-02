import 'package:dartssh2/dartssh2.dart';
import 'package:runner/src/services/shell/ssh_shell_service.dart';

class FlutterVersionManager {
  FlutterVersionManager(
    this._sshShellService,
    this._sshClient,
    this._jobId,
    this._workingVMName,
    this._appName,
  );
  final SSHShellService _sshShellService;
  final SSHClient _sshClient;
  final String _jobId;
  final String _workingVMName;
  final String _appName;

  Future<void> changeFlutterVersion(String flutterVersion) async {
    await _sshShellService.executeCommand(
      'source ~/.zshrc && cd ~/Downloads/$_appName && cd /Users/admin/flutter && git checkout $flutterVersion',
      _sshClient,
      _jobId,
      _workingVMName,
    );
  }
}

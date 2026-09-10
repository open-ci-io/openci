import 'dart:io';

Directory? findWorkflowDirectory([Directory? startDirectory]) {
  var directory = (startDirectory ?? Directory.current).absolute;
  while (true) {
    final workflows = Directory('${directory.path}/.genuineci');
    if (workflows.existsSync()) return workflows;
    final parent = directory.parent;
    if (parent.path == directory.path) return null;
    directory = parent;
  }
}

class CommandExecutionException implements Exception {
  CommandExecutionException({
    required this.command,
    required this.stdout,
    required this.stderr,
    required this.exitCode,
  });
  final String command;
  final String stdout;
  final String stderr;
  final int exitCode;

  @override
  String toString() {
    return 'CommandExecutionException: Command "$command" failed with exit code $exitCode.\nStdout: $stdout\nStderr: $stderr';
  }
}

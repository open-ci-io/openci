class ReplacementResult {
  ReplacementResult({
    required this.replacedCommand,
    required this.replacements,
  });

  final String replacedCommand;
  final Map<String, String> replacements;
}

ReplacementResult replaceEnvironmentVariables({
  required String command,
  required Map<String, String> secrets,
}) {
  var processedCommand = command;
  final replacements = <String, String>{};
  for (final entry in secrets.entries) {
    final key = '\$${entry.key}';
    if (processedCommand.contains(key)) {
      processedCommand = processedCommand.replaceAll(
        key,
        entry.value,
      );
      replacements[entry.key] = entry.value;
    }
  }
  return ReplacementResult(
    replacedCommand: processedCommand,
    replacements: replacements,
  );
}

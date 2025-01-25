String replaceEnvironmentVariables({
  required String command,
  required Map<String, String> secrets,
}) {
  var processedCommand = command;
  for (final entry in secrets.entries) {
    processedCommand = processedCommand.replaceAll(
      '\$${entry.key}',
      entry.value,
    );
  }
  return processedCommand;
}

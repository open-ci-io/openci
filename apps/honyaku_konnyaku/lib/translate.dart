import 'dart:io';

import 'package:google_generative_ai/google_generative_ai.dart';

// Helper function to strip code block delimiters if present.
String _stripCodeBlockDelimiters(String text) {
  final trimmed = text.trim();
  if (trimmed.startsWith("```") && trimmed.endsWith("```")) {
    final withoutDelimiters = trimmed.substring(3, trimmed.length - 3);
    return withoutDelimiters.trim();
  }
  return trimmed;
}

Future<void> translate(
  String pathToInput,
  String pathToOutput,
  String apiKey,
  String? prompt,
) async {
  final inputFile = File(pathToInput);
  if (!await inputFile.exists()) {
    throw Exception('Input file does not exist');
  }
  final content = await inputFile.readAsString();
  final model = GenerativeModel(
    model: 'gemini-2.5-pro-exp-03-25',
    apiKey: apiKey,
  );
  final basicPrompt = 'Translate the following text to English:';
  final finalPrompt = "${prompt ?? basicPrompt}: $content";
  final response = await model.generateContent([Content.text(finalPrompt)]);
  final translated = response.text;
  if (translated == null) {
    throw Exception('Failed to translate text');
  }

  // Remove code block delimiters if present.
  final cleanedTranslation = _stripCodeBlockDelimiters(translated);

  final outputFile = File(pathToOutput);
  await outputFile.writeAsString(cleanedTranslation);
}

import 'dart:io';

import 'package:google_generative_ai/google_generative_ai.dart';

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
  print('Content: $content');
  final model = GenerativeModel(
    model: 'gemini-2.0-flash',
    apiKey: apiKey,
  );
  final basicPrompt = 'Translate the following text to English:';
  final finalPrompt = "${prompt ?? basicPrompt}: $content";
  final response = await model.generateContent([Content.text(finalPrompt)]);
  final translated = response.text;
  if (translated == null) {
    throw Exception('Failed to translate text');
  }

  final outputFile = File(pathToOutput);
  await outputFile.writeAsString(translated);
}

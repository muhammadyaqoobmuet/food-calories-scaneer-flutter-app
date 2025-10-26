import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

Future<void> main() async {
  await dotenv.load(fileName: '.env');
  final apiKey = dotenv.env['GEMINI_API_KEY'];
  final model = dotenv.env['GEMINI_MODEL'] ?? 'gemini-2.5-flash';
  if (apiKey == null) {
    print('No API key');
    return;
  }

  final m = GenerativeModel(model: model, apiKey: apiKey);
  final prompt = TextPart('Return ONLY a JSON object with keys: foodName (string), calories (number), protein (string like "25g"), carbs (string like "30g"), fat (string like "10g"). Output only the JSON object.');

  final response = await m.generateContent([Content.text(prompt)]);
  print('Response runtimeType=${response.runtimeType}');
  print(response);
}


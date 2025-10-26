import 'dart:io';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  // Get API key from environment variables
  static String get apiKey {
    final key = dotenv.env['GEMINI_API_KEY'];
    if (key == null || key.isEmpty) {
      throw Exception(
        'GEMINI_API_KEY not found in environment variables. '
        'Please add your API key to the .env file.',
      );
    }
    return key;
  }

  Future<Map<String, dynamic>> analyzeFoodImage(File imageFile) async {
    try {
      // Create Gemini model
      final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);

      // Read image as bytes
      final imageBytes = await imageFile.readAsBytes();

      // Create prompt
      final prompt = TextPart(
        'Analyze this food image and identify the food. '
        'Provide estimated nutritional information per serving. '
        'Return your response as a JSON object with these exact keys: '
        'foodName (string), calories (number), protein (string with unit like "25g"), '
        'carbs (string with unit like "30g"), fat (string with unit like "10g"). '
        'If you cannot identify the food clearly, set foodName to "Unknown Food" '
        'and provide estimated values. Only return the JSON, no other text.',
      );

      // Create image part
      final imagePart = DataPart('image/jpeg', imageBytes);

      // Send request
      final response = await model.generateContent([
        Content.multi([prompt, imagePart]),
      ]);

      // Get response text
      String responseText = response.text ?? '';

      // Clean up response (remove markdown code blocks if present)
      responseText = responseText
          .replaceAll('```json', '')
          .replaceAll('```', '')
          .trim();

      // Parse JSON
      final Map<String, dynamic> result = jsonDecode(responseText);

      // Validate and return
      return {
        'foodName': result['foodName'] ?? 'Unknown Food',
        'calories': (result['calories'] ?? 0).toDouble(),
        'protein': result['protein']?.toString() ?? '0g',
        'carbs': result['carbs']?.toString() ?? '0g',
        'fat': result['fat']?.toString() ?? '0g',
      };
    } catch (e) {
      print('Error analyzing image: $e');
      // Return error response
      return {
        'foodName': 'Error analyzing food',
        'calories': 0.0,
        'protein': '0g',
        'carbs': '0g',
        'fat': '0g',
      };
    }
  }
}

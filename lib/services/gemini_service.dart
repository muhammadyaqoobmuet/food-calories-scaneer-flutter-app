import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  // Get API key from environment variables
  static String get apiKey {
    final raw = dotenv.env['GEMINI_API_KEY'];
    if (raw == null || raw.trim().isEmpty) {
      throw Exception(
        'GEMINI_API_KEY not found in environment variables. '
        'Please add your API key to the .env file as GEMINI_API_KEY.',
      );
    }

    // Trim surrounding whitespace and optional surrounding quotes
    var key = raw.trim();
    if ((key.startsWith('"') && key.endsWith('"')) ||
        (key.startsWith("'") && key.endsWith("'"))) {
      key = key.substring(1, key.length - 1);
    }

    return key;
  }

  // Get model name from env (so it's easy to change without editing code)
  static String get modelName {
    final model = dotenv.env['GEMINI_MODEL'];
    if (model == null || model.isEmpty) {
      throw Exception(
        'GEMINI_MODEL not found in environment variables. '
        'Please add GEMINI_MODEL to your .env (example: GEMINI_MODEL=gemini-1.5-flash) '
        'or set it to a model you have access to.',
      );
    }
    return model;
  }

  // New API: accept image bytes so this service works on all platforms (including web)
  Future<Map<String, dynamic>> analyzeFoodBytes(Uint8List imageBytes) async {
    try {
      // Helper to attempt generateContent with a given model string and return parsed result
      Future<Map<String, dynamic>> _attemptWithModel(String modelStr) async {
        print('Attempting model: $modelStr');
        final model = GenerativeModel(model: modelStr, apiKey: apiKey);

        // Use provided imageBytes

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

        // Debug: print raw response and its runtime type so failures are easier to diagnose
        try {
          print(
            'Gemini raw response (runtimeType=${response.runtimeType}): $response',
          );
        } catch (e) {
          print('Could not print raw Gemini response: $e');
        }

        // Try to extract a text representation from the response in several ways
        String responseText = '';
        // 1) The package may expose `text`
        try {
          final dynamic maybeText = (response as dynamic).text;
          if (maybeText != null) responseText = maybeText.toString();
        } catch (_) {}

        // 2) Fallback to toString()
        if (responseText.trim().isEmpty) {
          try {
            responseText = response.toString();
          } catch (_) {
            responseText = '';
          }
        }

        // 3) If still empty, try to JSON-encode the response (some response objects are encodable)
        if (responseText.trim().isEmpty) {
          try {
            responseText = jsonEncode(response);
          } catch (_) {}
        }

        if (responseText.trim().isEmpty) {
          print(
            'Empty response text from model; full response object: $response',
          );
          throw Exception('Empty response from model');
        }

        // Clean up response (remove markdown code blocks if present)
        responseText = responseText
            .replaceAll('```json', '')
            .replaceAll('```', '')
            .trim();

        // If the response contains other text around a JSON object, try to extract the first {...}
        String jsonCandidate = responseText;
        final firstBrace = responseText.indexOf('{');
        final lastBrace = responseText.lastIndexOf('}');
        if (firstBrace != -1 && lastBrace != -1 && lastBrace > firstBrace) {
          jsonCandidate = responseText.substring(firstBrace, lastBrace + 1);
        }

        // Parse JSON
        Map<String, dynamic> result;
        try {
          result = jsonDecode(jsonCandidate) as Map<String, dynamic>;
        } catch (e) {
          print(
            'Failed to parse JSON from model response. responseText="$responseText"',
          );
          rethrow;
        }

        // Normalize calories: accept number or numeric string
        double parseCalories(dynamic cal) {
          if (cal == null) return 0.0;
          if (cal is num) return cal.toDouble();
          if (cal is String) {
            final cleaned = cal.replaceAll(RegExp(r'[^0-9.]'), '');
            return double.tryParse(cleaned) ?? 0.0;
          }
          return 0.0;
        }

        // Validate and return
        return {
          'foodName': result['foodName'] ?? 'Unknown Food',
          'calories': parseCalories(result['calories']),
          'protein': result['protein']?.toString() ?? '0g',
          'carbs': result['carbs']?.toString() ?? '0g',
          'fat': result['fat']?.toString() ?? '0g',
        };
      }

      // Primary attempt with configured modelName
      try {
        return await _attemptWithModel(modelName);
      } catch (e) {
        print('Primary model attempt failed for "$modelName": $e');
        // Try alternative with 'models/' prefix or stripped prefix
        String altModel;
        if (modelName.startsWith('models/')) {
          altModel = modelName.replaceFirst('models/', '');
        } else {
          altModel = 'models/$modelName';
        }

        try {
          print('Retrying with alternative model name: $altModel');
          return await _attemptWithModel(altModel);
        } catch (e2) {
          print('Alternative model attempt also failed for "$altModel": $e2');
          rethrow;
        }
      }
    } catch (e, st) {
      print('Error analyzing image: $e\n$st');
      // Rethrow a clear exception so UI can show the real error instead of a silent placeholder
      throw Exception('Error analyzing image: $e');
    }
  }
}

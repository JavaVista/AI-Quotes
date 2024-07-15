import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class GeminiService {
  final log = Logger();

  final String geminiUrl =
      "https://us-central1-ai-quotes-46431.cloudfunctions.net/generateAiQuote";

  Future<Map<String, String>> generateQuote(String category) async {
    final response = await http.post(
      Uri.parse(geminiUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'category': category}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data.cast<String, String>();
    } else {
      log.d("Error generating quote Gemini: ${response.statusCode}");
      throw Exception('Failed to generate quote');
    }
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class GeminiService {
  final log = Logger();

  final String geminiUrl = "https://us-central1-ai-quotes-46431.cloudfunctions.net/generateAiQuote"; 
  Future<Map<String, String>> generateQuote(String category) async {
    final response = await http.post(
      Uri.parse(geminiUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'category': category}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      log.d("Received data Gemini: $data"); // Log the received data
      return data.cast<String, String>(); // Cast to Map<String, String>
    } else {
      log.d("Error generating quote Gemini: ${response.statusCode}");
      throw Exception('Failed to generate quote');
    }
  }
}

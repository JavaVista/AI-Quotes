import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  final String geminiUrl = "YOUR_GEMINI_API_URL";

  Future<String> generateQuote(String category) async {
    final response = await http.post(
      Uri.parse(geminiUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'category': category}),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body)['quote'];
    } else {
      throw Exception('Failed to generate quote');
    }
  }
}

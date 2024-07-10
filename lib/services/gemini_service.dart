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

// // Example usage:
// void main() async {
//   GeminiService geminiService = GeminiService();
//   try {
//     Map<String, String> quoteData = await geminiService.generateQuote("love");
//     log.d("Quote: ${quoteData['quote']}");
//     log.d("Author: ${quoteData['author']}");
//     log.d("Category: ${quoteData['category']}");
//     log.d("Occupation: ${quoteData['occupation']}");
//   } catch (e) {
//     log.d("Error: $e");
//   }
// }

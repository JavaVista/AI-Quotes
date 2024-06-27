import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ai_quotes_app/models/quote.dart';

class QuoteService {
  final String apiUrl = "YOUR_QUOTE_API_URL";

  Future<Quote> fetchRandomQuote() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final quoteJson = json.decode(response.body);
      return Quote.fromJson(quoteJson);
    } else {
      throw Exception('Failed to load quote');
    }
  }
}

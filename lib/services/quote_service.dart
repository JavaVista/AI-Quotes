import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:ai_quotes_app/models/quote.dart';
import 'package:logger/logger.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class QuoteService {
  final String? apiKey = dotenv.env['API_KEY'];
  final log = Logger();
  late final String apiUrl;
  List<Quote> _cachedQuotes = [];
  Timer? _refreshTimer;

  QuoteService() {
    apiUrl = "https://zenquotes.io/api/quotes/$apiKey";
    _fetchAndCacheQuotes();
    _startRefreshTimer();
  }

  Future<void> _fetchAndCacheQuotes() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> quotesJson = json.decode(response.body);
        _cachedQuotes = quotesJson
            .map((quoteJson) => Quote(
                  id: '',
                  paragraph: quoteJson['q'],
                  author: quoteJson['a'],
                  imageUrl: quoteJson['i'],
                  occupation: 'Unknown',
                ))
            .toList();
      } else {
        log.d("Error fetching quotes ZenQuotes: ${response.statusCode}");
      }
    } on Exception catch (e) {
      log.d("Error fetching quotes ZenQuotes: $e");
    }
  }

  void _startRefreshTimer() {
    _refreshTimer = Timer.periodic(const Duration(hours: 1), (timer) {
      _fetchAndCacheQuotes();
    });
  }

  Future<Quote> fetchRandomQuote() async {
    if (_cachedQuotes.isEmpty) {
      await _fetchAndCacheQuotes();
    }
    if (_cachedQuotes.isNotEmpty) {
      final randomIndex = Random().nextInt(_cachedQuotes.length);
      return _cachedQuotes[randomIndex];
    }
    throw Exception('No quotes available');
  }

  void dispose() {
    _refreshTimer?.cancel();
  }
}

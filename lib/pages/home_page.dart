import 'package:ai_quotes_app/theme/colors.dart';
import 'package:ai_quotes_app/theme/typography.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:ai_quotes_app/services/quote_service.dart';
import 'package:ai_quotes_app/services/gemini_service.dart';
import 'package:ai_quotes_app/services/firebase_service.dart';
import 'package:ai_quotes_app/models/quote.dart';
import 'package:uuid/uuid.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final TextEditingController paragraphController = TextEditingController();
  final TextEditingController authorController = TextEditingController();
  String previewQuote = '';
  String previewAuthor = '';
  String previewImageUrl = '';
  String previewOccupation = 'Unknown';
  final uuid = const Uuid();
  final log = Logger();

  @override
  Widget build(BuildContext context) {
    final quoteService = Provider.of<QuoteService>(context);
    final geminiService = Provider.of<GeminiService>(context);
    final firebaseService = Provider.of<FirebaseService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Quotes', style: AppTypography.heading),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _showAddQuoteDialog(context);
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/ai_quotes_bkg_zen.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            if (previewQuote.isEmpty)
              const Center(
                child: Text(
                  'Welcome to AI Quotes',
                  style: AppTypography.heading,
                ),
              ),
            if (previewQuote.isNotEmpty)
              Center(
                child: Card(
                  margin: const EdgeInsets.all(16.0),
                  child: ListTile(
                    title: Text(previewQuote, style: AppTypography.cardText),
                    subtitle: Text('$previewAuthor, $previewOccupation', style: AppTypography.body),
                    trailing: IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        final newQuote = Quote(
                          id: uuid.v4(),
                          paragraph: previewQuote,
                          author: previewAuthor,
                          occupation: previewOccupation,
                          imageUrl: previewImageUrl,
                        );
                        firebaseService.addQuote(newQuote);
                        _clearPreview();
                        Navigator.pushNamed(context, '/quotes');
                      },
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () async {
              final quote = await quoteService.fetchRandomQuote();
              setState(() {
                previewQuote = quote.paragraph;
                previewAuthor = quote.author;
                previewOccupation = 'Unknown';
                previewImageUrl = quote.imageUrl;
              });
            },
            child: const Icon(Icons.shuffle),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () async {
              final aiQuote = await geminiService.generateQuote('pain');

              setState(() {
                previewQuote = aiQuote['quote'] ?? '';
                previewAuthor = aiQuote['author'] ?? 'Gemini';
                previewOccupation = aiQuote['occupation'] ?? 'AI';
                previewImageUrl = '';
              });
            },
            child: const Icon(Icons.stars),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, '/favorites').then((_) {
                _clearPreview();
              });
            },
            child: const Icon(Icons.favorite),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, '/quotes').then((_) {
                _clearPreview();
              });
            },
            child: const Icon(Icons.list),
          ),
        ],
      ),
    );
  }

  void _showAddQuoteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add a Quote', style: AppTypography.heading,),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: paragraphController,
                  decoration: const InputDecoration(labelText: 'Quote'),
                ),
                TextField(
                  controller: authorController,
                  decoration: const InputDecoration(labelText: 'Author'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      previewQuote = paragraphController.text;
                      previewAuthor = authorController.text;
                      previewOccupation = 'Unknown';
                      previewImageUrl = '';
                    });
                    Navigator.of(context).pop();
                  },
                  child: const Text('Preview Quote', style: AppTypography.body),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _clearPreview() {
    setState(() {
      previewQuote = '';
      previewAuthor = '';
      previewOccupation = 'Unknown';
      previewImageUrl = '';
    });
  }
}

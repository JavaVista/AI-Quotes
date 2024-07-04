import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ai_quotes_app/services/quote_service.dart';
import 'package:ai_quotes_app/services/gemini_service.dart';
import 'package:ai_quotes_app/services/firebase_service.dart';
import 'package:ai_quotes_app/models/quote.dart';

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

  @override
  Widget build(BuildContext context) {
    final quoteService = Provider.of<QuoteService>(context);
    final geminiService = Provider.of<GeminiService>(context);
    final firebaseService = Provider.of<FirebaseService>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('AI Quotes')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
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
                onPressed: () async {
                  String paragraph = paragraphController.text;
                  String author = authorController.text;
                  if (paragraph.isEmpty || author.isEmpty) {
                    final quote = await quoteService.fetchRandomQuote();
                    paragraph = quote.paragraph;
                    author = quote.author;
                  }
                  setState(() {
                    previewQuote = paragraph;
                    previewAuthor = author;
                  });
                },
                child: const Text('Preview Quote'),
              ),
              const SizedBox(height: 20),
              if (previewQuote.isNotEmpty)
                Card(
                  child: ListTile(
                    title: Text(previewQuote),
                    subtitle: Text(previewAuthor),
                    trailing: IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        final newQuote = Quote(
                            id: '',
                            paragraph: previewQuote,
                            author: previewAuthor,
                            occupation: 'Unknown');
                        Navigator.pushNamed(context, '/quotes',
                            arguments: newQuote);
                      },
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final quote = await quoteService.fetchRandomQuote();
                  setState(() {
                    previewQuote = quote.paragraph;
                    previewAuthor = quote.author;
                  });
                },
                child: const Text('Get Random Quote'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final aiQuote =
                      await geminiService.generateQuote('inspiration');
                  setState(() {
                    previewQuote = aiQuote['quote'] ?? '';
                    previewAuthor = 'Gemini AI';
                  });
                },
                child: const Text('Generate AI Quote'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

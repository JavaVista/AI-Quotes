import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ai_quotes_app/services/quote_service.dart';
import 'package:ai_quotes_app/services/gemini_service.dart';
import 'package:ai_quotes_app/services/firebase_service.dart';
import 'package:ai_quotes_app/models/quote.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController paragraphController = TextEditingController();
  final TextEditingController authorController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  String randomQuote = '';
  String randomAuthor = '';

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
                  final newQuote = Quote(id: '', paragraph: paragraph, author: author, occupation: 'Unknown');
                  await firebaseService.addQuote(newQuote);
                  setState(() {
                    randomQuote = paragraph;
                    randomAuthor = author;
                  });
                },
                child: const Text('Add Quote'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final quote = await quoteService.fetchRandomQuote();
                  setState(() {
                    randomQuote = quote.paragraph;
                    randomAuthor = quote.author;
                  });
                },
                child: const Text('Get Random Quote'),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: categoryController,
                decoration: const InputDecoration(labelText: 'Category for AI Quote'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final aiQuote = await geminiService.generateQuote(categoryController.text);
                  final newQuote = Quote(id: '', paragraph: aiQuote, author: 'Gemini AI', occupation: 'AI');
                  await firebaseService.addQuote(newQuote);
                  setState(() {
                    randomQuote = aiQuote;
                    randomAuthor = 'Gemini AI';
                  });
                },
                child: const Text('Generate AI Quote'),
              ),
              const SizedBox(height: 20),
              if (randomQuote.isNotEmpty)
                Card(
                  child: ListTile(
                    title: Text(randomQuote),
                    subtitle: Text(randomAuthor),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

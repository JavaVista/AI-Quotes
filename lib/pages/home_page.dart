import 'package:flutter/material.dart';
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
  String previewOccupation = 'Unknown';
  final uuid = const Uuid();

  @override
  Widget build(BuildContext context) {
    final quoteService = Provider.of<QuoteService>(context);
    final geminiService = Provider.of<GeminiService>(context);
    final firebaseService = Provider.of<FirebaseService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Quotes'),
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
            image: AssetImage('assets/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            if (previewQuote.isNotEmpty)
              Card(
                margin: const EdgeInsets.all(16.0),
                child: ListTile(
                  title: Text(previewQuote),
                  subtitle: Text('$previewAuthor, $previewOccupation'),
                  trailing: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      final newQuote = Quote(
                        id: uuid.v4(),
                        paragraph: previewQuote,
                        author: previewAuthor,
                        occupation: previewOccupation,
                      );
                      firebaseService.addQuote(newQuote);
                      Navigator.pushNamed(context, '/quotes');
                    },
                  ),
                ),
              ),
            const Expanded(
              child: Center(
                child: Text(
                  'Welcome to AI Quotes',
                  style: TextStyle(fontSize: 24, color: Colors.white),
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
              });
            },
            child: const Icon(Icons.shuffle),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () async {
              final aiQuote = await geminiService.generateQuote('inspiration');
              setState(() {
                previewQuote = aiQuote['quote'] ?? '';
                previewAuthor = aiQuote['author'] ?? 'Gemini';
                previewOccupation = aiQuote['occupation'] ?? 'AI';
              });
            },
            child: const Icon(Icons.stars),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, '/favorites');
            },
            child: const Icon(Icons.favorite),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, '/quotes');
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
          title: const Text('Add a Quote'),
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
                    });
                    Navigator.of(context).pop();
                  },
                  child: const Text('Preview Quote'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

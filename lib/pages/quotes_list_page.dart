import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ai_quotes_app/models/quote.dart';
import 'package:ai_quotes_app/services/firebase_service.dart';

class QuotesListPage extends StatelessWidget {
  const QuotesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final newQuote = ModalRoute.of(context)?.settings.arguments as Quote?;

    return Scaffold(
      appBar: AppBar(title: const Text('Quotes')),
      body: StreamBuilder<List<Quote>>(
        stream: Provider.of<FirebaseService>(context).getQuotes(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final quotes = snapshot.data!;
          if (newQuote != null) {
            quotes.add(newQuote);
          }
          return ListView.builder(
            itemCount: quotes.length,
            itemBuilder: (context, index) {
              final quote = quotes[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(quote.paragraph),
                  subtitle: Text('${quote.author}, ${quote.occupation}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.favorite),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => FavoriteQuotePage(quote: quote)),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class FavoriteQuotePage extends StatefulWidget {
  final Quote quote;

  const FavoriteQuotePage({super.key, required this.quote});

  @override
  FavoriteQuotePageState createState() => FavoriteQuotePageState();
}

class FavoriteQuotePageState extends State<FavoriteQuotePage> {
  final TextEditingController occupationController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final firebaseService = Provider.of<FirebaseService>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Favorite Quote')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(widget.quote.paragraph, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Text('- ${widget.quote.author}', style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic)),
            TextField(
              controller: occupationController,
              decoration: const InputDecoration(labelText: 'Occupation'),
            ),
            TextField(
              controller: categoryController,
              decoration: const InputDecoration(labelText: 'Category'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final updatedQuote = Quote(
                  id: widget.quote.id,
                  paragraph: widget.quote.paragraph,
                  author: widget.quote.author,
                  occupation: occupationController.text,
                );
                firebaseService.addQuote(updatedQuote);
              },
              child: const Text('Save to Favorites'),
            ),
            ElevatedButton(
              onPressed: () {
                firebaseService.deleteQuote(widget.quote.id);
              },
              child: const Text('Delete from Favorites'),
            ),
          ],
        ),
      ),
    );
  }
}

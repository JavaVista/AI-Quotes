import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ai_quotes_app/models/quote.dart';
import 'package:ai_quotes_app/services/firebase_service.dart';

class QuotesListPage extends StatelessWidget {
  const QuotesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quotes')),
      body: StreamBuilder<List<Quote>>(
        stream: Provider.of<FirebaseService>(context).getQuotes(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final quotes = snapshot.data!;
          return ListView.builder(
            itemCount: quotes.length,
            itemBuilder: (context, index) {
              final quote = quotes[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(quote.paragraph),
                  subtitle: Text('${quote.author}, ${quote.occupation}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => QuoteDetailPage(quote: quote)),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class QuoteDetailPage extends StatelessWidget {
  final Quote quote;

  const QuoteDetailPage({super.key, required this.quote});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quote Detail')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          margin: const EdgeInsets.all(16.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(quote.paragraph, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                Text('- ${quote.author}, ${quote.occupation}', style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic)),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Add to favorites logic
                  },
                  child: const Text('Favorite'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ai_quotes_app/models/quote.dart';
import 'package:ai_quotes_app/services/firebase_service.dart';

class FavoriteQuotesPage extends StatelessWidget {
  const FavoriteQuotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorite Quotes')),
      body: StreamBuilder<List<Quote>>(
        stream: Provider.of<FirebaseService>(context).getFavoriteQuotes(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final favoriteQuotes = snapshot.data!;
          return ListView.builder(
            itemCount: favoriteQuotes.length,
            itemBuilder: (context, index) {
              final quote = favoriteQuotes[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(quote.paragraph),
                  subtitle: Text('${quote.author}, ${quote.occupation}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.favorite, color: Colors.red),
                    onPressed: () {
                      final firebaseService =
                          Provider.of<FirebaseService>(context, listen: false);
                      quote.isFavorite = false;
                      firebaseService.updateQuote(quote);
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

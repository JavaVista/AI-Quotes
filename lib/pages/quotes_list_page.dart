import 'package:ai_quotes_app/theme/typography.dart';
import 'package:ai_quotes_app/utils/image_utils.dart';
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
      appBar: AppBar(title: const Text('Quotes' , style: AppTypography.heading)),
      body: StreamBuilder<List<Quote>>(
        stream: Provider.of<FirebaseService>(context).getQuotes(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final quotes = snapshot.data!;
          if (newQuote != null &&
              !quotes.any((q) => q.paragraph == newQuote.paragraph)) {
            quotes.add(newQuote);
          }
          return ListView.builder(
            itemCount: quotes.length,
            itemBuilder: (context, index) {
              final quote = quotes[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: getAuthorImage(quote),
                  ),
                  title: Text(quote.paragraph, style: AppTypography.cardText),
                  subtitle: Text('${quote.author}, ${quote.occupation}', style: AppTypography.body),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          quote.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: quote.isFavorite ? Colors.red : null,
                        ),
                        onPressed: () {
                          final firebaseService = Provider.of<FirebaseService>(
                              context,
                              listen: false);
                          quote.isFavorite = !quote.isFavorite;
                          firebaseService.updateQuote(quote);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          final firebaseService = Provider.of<FirebaseService>(
                              context,
                              listen: false);
                          firebaseService.deleteQuote(quote.id);
                        },
                      ),
                    ],
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


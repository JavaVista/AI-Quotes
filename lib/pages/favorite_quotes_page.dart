import 'package:ai_quotes_app/theme/colors.dart';
import 'package:ai_quotes_app/theme/typography.dart';
import 'package:ai_quotes_app/utils/image_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ai_quotes_app/models/quote.dart';
import 'package:ai_quotes_app/services/firebase_service.dart';

class FavoriteQuotesPage extends StatelessWidget {
  const FavoriteQuotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundGrey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Favorite Quotes', style: AppTypography.heading),
      ),
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
                elevation: 4,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                  ),
                ),
                margin: const EdgeInsets.all(8.0),
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(30.0),
                      bottomLeft: Radius.circular(30.0),
                    ),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.25),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: getAuthorImage(quote),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(quote.paragraph, style: AppTypography.cardText),
                            const SizedBox(height: 8.0),
                            Text('${quote.author}, ${quote.occupation}',
                                style: AppTypography.body),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.favorite, color: Colors.red),
                        onPressed: () {
                          final firebaseService =
                              Provider.of<FirebaseService>(context,
                                  listen: false);
                          quote.isFavorite = false;
                          firebaseService.updateQuote(quote);
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

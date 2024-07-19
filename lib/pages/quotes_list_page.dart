import 'package:ai_quotes_app/dialogs/add_occupation_dialog.dart';
import 'package:ai_quotes_app/theme/colors.dart';
import 'package:ai_quotes_app/theme/typography.dart';
import 'package:ai_quotes_app/utils/image_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ai_quotes_app/models/quote.dart';
import 'package:ai_quotes_app/services/firebase_service.dart';

class QuotesListPage extends StatefulWidget {
  const QuotesListPage({super.key});

  @override
  QuotesListPageState createState() => QuotesListPageState();
}

class QuotesListPageState extends State<QuotesListPage> {
  final Map<String, bool> _isHovered = {};

  @override
  Widget build(BuildContext context) {
    final newQuote = ModalRoute.of(context)?.settings.arguments as Quote?;

    return Scaffold(
      backgroundColor: backgroundGrey,
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text('Quotes', style: AppTypography.heading)),
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
                            Text(quote.paragraph,
                                style: AppTypography.cardText),
                            const SizedBox(height: 8.0),
                            Row(
                              children: [
                                Text('${quote.author}, ',
                                    style: AppTypography.body),
                                GestureDetector(
                                  onTap: () {
                                    showAddOccupationDialog(context, quote,
                                        (updatedQuote) {
                                      final firebaseService =
                                          Provider.of<FirebaseService>(context,
                                              listen: false);
                                      firebaseService.updateQuote(updatedQuote);
                                    });
                                  },
                                  child: MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    onEnter: (_) {
                                      setState(() {
                                        _isHovered[quote.id] = true;
                                      });
                                    },
                                    onExit: (_) {
                                      setState(() {
                                        _isHovered[quote.id] = false;
                                      });
                                    },
                                    child: Text(
                                      quote.occupation,
                                      style: AppTypography.body.copyWith(
                                        color: _isHovered[quote.id] == true
                                            ? tertiaryColor
                                            : primaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Row(
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
                              _toggleFavorite(quote);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              final firebaseService =
                                  Provider.of<FirebaseService>(context,
                                      listen: false);
                              firebaseService.deleteQuote(quote.id);
                            },
                          ),
                        ],
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

  void _toggleFavorite(Quote quote) {
    final updatedQuote = quote.copyWith(isFavorite: !quote.isFavorite);
    final firebaseService =
        Provider.of<FirebaseService>(context, listen: false);
    firebaseService.updateQuote(updatedQuote);
  }


}

import 'package:ai_quotes_app/theme/colors.dart';
import 'package:ai_quotes_app/theme/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
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
  final TextEditingController categoryController = TextEditingController();
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

    return Stack(children: [
      Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/ai_quotes_bkg_zen.jpg'),
            fit: BoxFit.cover,
          ),
        ),
      ),
      Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: Stack(
          children: [
            if (previewQuote.isEmpty)
              Center(
                child: RichText(
                  text: const TextSpan(
                    text: 'Welcome to ',
                    style: AppTypography.mainTitle,
                    children: <TextSpan>[
                      TextSpan(
                        text: 'AI',
                        style: AppTypography.subMainTitle,
                      ),
                      TextSpan(
                        text: ' Quotes',
                        style: AppTypography.mainTitle,
                      ),
                    ],
                  ),
                ),
              ),
            if (previewQuote.isNotEmpty)
              Center(
                child: Card(
                  elevation: 8,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30.0),
                      bottomLeft: Radius.circular(30.0),
                    ),
                  ),
                  margin: const EdgeInsets.all(30.0),
                  shadowColor: primaryColor.withOpacity(0.5),
                  child: Container(
                    padding: const EdgeInsets.all(20.0),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30.0),
                        bottomLeft: Radius.circular(30.0),
                      ),
                      color: Colors.white,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(previewQuote, style: AppTypography.cardText),
                        const SizedBox(height: 10),
                        Text('$previewAuthor, $previewOccupation',
                            style: AppTypography.body),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: IconButton(
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
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
        floatingActionButton: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: secondaryColor, width: 2.0),
          ),
          child: SpeedDial(
            icon: Icons.edit,
            activeIcon: Icons.close,
            backgroundColor: Colors.white,
            foregroundColor: secondaryColor,
            overlayColor: Colors.black,
            overlayOpacity: 0.5,
            children: [
              SpeedDialChild(
                child: const Icon(Icons.add),
                backgroundColor: Colors.white,
                foregroundColor: secondaryColor,
                label: 'Add Quote',
                labelStyle: AppTypography.body,
                labelBackgroundColor: Colors.white,
                onTap: () {
                  _showAddQuoteDialog(context);
                },
              ),
              SpeedDialChild(
                child: const Icon(Icons.shuffle),
                backgroundColor: Colors.white,
                foregroundColor: secondaryColor,
                label: 'Random Quote',
                labelStyle: AppTypography.body,
                labelBackgroundColor: Colors.white,
                onTap: () async {
                  final quote = await quoteService.fetchRandomQuote();
                  setState(() {
                    previewQuote = quote.paragraph;
                    previewAuthor = quote.author;
                    previewOccupation = 'Unknown';
                    previewImageUrl = quote.imageUrl;
                  });
                },
              ),
              SpeedDialChild(
                child: const Icon(Icons.stars),
                backgroundColor: Colors.white,
                foregroundColor: secondaryColor,
                label: 'AI Quote',
                labelStyle: AppTypography.body,
                labelBackgroundColor: Colors.white,
                onTap: () async {
                  _showCategoryDialog(context, geminiService);
                },
              ),
              SpeedDialChild(
                child: const Icon(Icons.favorite),
                backgroundColor: Colors.white,
                foregroundColor: secondaryColor,
                label: 'Favorites',
                labelStyle: AppTypography.body,
                labelBackgroundColor: Colors.white,
                onTap: () {
                  Navigator.pushNamed(context, '/favorites').then((_) {
                    _clearPreview();
                  });
                },
              ),
              SpeedDialChild(
                child: const Icon(Icons.list),
                backgroundColor: Colors.white,
                foregroundColor: secondaryColor,
                label: 'Quotes List',
                labelStyle: AppTypography.body,
                labelBackgroundColor: Colors.white,
                onTap: () {
                  Navigator.pushNamed(context, '/quotes').then((_) {
                    _clearPreview();
                  });
                },
              ),
            ],
          ),
        ),
      ),
    ]);
  }

  void _showAddQuoteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(30.0),
              bottomLeft: Radius.circular(30.0),
            ),
          ),
          contentPadding: const EdgeInsets.all(20.0),
          content: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(30.0),
                bottomLeft: Radius.circular(30.0),
              ),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.25),
                  spreadRadius: 5,
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: SingleChildScrollView(
              // Add SingleChildScrollView to avoid overflow issues
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Add a Quote',
                    style: AppTypography.heading,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: paragraphController,
                    maxLines: null,
                    minLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'Quote',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: authorController,
                    decoration: const InputDecoration(
                      labelText: 'Author',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
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
            TextButton(
              onPressed: () {
                paragraphController.clear();
                authorController.clear();
                Navigator.of(context).pop();
              },
              child: const Text('Cancel', style: AppTypography.body),
            ),
          ],
        );
      },
    );
  }

  void _showCategoryDialog(BuildContext context, GeminiService geminiService) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(30.0),
              bottomLeft: Radius.circular(30.0),
            ),
          ),
          contentPadding: const EdgeInsets.all(20.0),
          content: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(30.0),
                bottomLeft: Radius.circular(30.0),
              ),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.25),
                  spreadRadius: 5,
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Enter a Category',
                  style: AppTypography.heading,
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: categoryController,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final category = categoryController.text;
                if (category.isNotEmpty) {
                  final aiQuote = await geminiService.generateQuote(category);
                  if (mounted) {
                    setState(() {
                      previewQuote = aiQuote['quote'] ?? '';
                      previewAuthor = aiQuote['author'] ?? 'Gemini';
                      previewOccupation = aiQuote['occupation'] ?? 'AI';
                      previewImageUrl = '';
                    });
                    categoryController.clear();
                    Navigator.of(this.context).pop();
                  }
                }
              },
              child: const Text('Generate', style: AppTypography.body),
            ),
            TextButton(
              onPressed: () {
                categoryController.clear();
                Navigator.of(context).pop();
              },
              child: const Text('Cancel', style: AppTypography.body),
            ),
          ],
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

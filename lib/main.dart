import 'package:ai_quotes_app/firebase_options.dart';
import 'package:ai_quotes_app/pages/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:ai_quotes_app/services/quote_service.dart';
import 'package:ai_quotes_app/services/gemini_service.dart';
import 'package:ai_quotes_app/services/firebase_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'pages/quotes_list_page.dart';
import 'pages/favorite_quotes_page.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const AIQuoteApp());
}

class AIQuoteApp extends StatelessWidget {
  const AIQuoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => QuoteService()),
        Provider(create: (_) => GeminiService()),
        Provider(create: (_) => FirebaseService()),
      ],
      child: MaterialApp(
        // Remove debug banner 
        //(When you build your app for release, the debug banner is automatically removed. )
        // Adding this for presentation purposes only
        debugShowCheckedModeBanner: false, 
        title: 'AI Quotes',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const SplashScreen(),
        routes: {
          '/quotes': (context) => const QuotesListPage(),
          '/favorites': (context) => const FavoriteQuotesPage(),
        },
      ),
    );
  }
}

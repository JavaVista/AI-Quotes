import 'package:flutter/material.dart';

class FavoriteQuotesPage extends StatelessWidget {
  const FavoriteQuotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorite Quotes')),
      body: const Center(
        child: Text('Display favorited quotes here', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}

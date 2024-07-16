import 'package:flutter/material.dart';
import 'package:ai_quotes_app/models/quote.dart';

ImageProvider<Object> getAuthorImage(Quote quote) {
  if (quote.author == 'Gemini') {
    return const AssetImage('assets/images/google-gemini-icon.png');
  } else if (quote.imageUrl.isNotEmpty) {
    return NetworkImage(quote.imageUrl);
  } else {
    return const AssetImage(
        'assets/images/half-face-selfie-on-phone-screen-in-a-hand.png');
  }
}

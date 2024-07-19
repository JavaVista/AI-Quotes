import 'package:flutter/material.dart';
import 'colors.dart';

class AppTypography {
  static const TextStyle mainTitle = TextStyle(
    fontFamily: 'GreatVibes',
    fontWeight: FontWeight.bold,
    fontSize: 40,
    color: primaryColor,
  );

    static const TextStyle subMainTitle = TextStyle(
    fontFamily: 'Assistant',
    fontWeight: FontWeight.bold,
    fontSize: 40,
    color: primaryColor,
  );

  static const TextStyle heading = TextStyle(
    fontFamily: 'GreatVibes',
    fontWeight: FontWeight.bold,
    fontSize: 26,
    color: primaryColor,
  );

  static const TextStyle body = TextStyle(
    fontFamily: 'Assistant',
    fontSize: 16,
    color: primaryGreyScale,
  );

  static const TextStyle cardText = TextStyle(
    fontFamily: 'Assistant',
    fontSize: 14,
    color: primaryGreyScale,
  );
}

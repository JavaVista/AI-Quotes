import 'package:flutter/material.dart';
import 'colors.dart';

class AppTypography {
  static const TextStyle heading = TextStyle(
    fontFamily: 'GowunBatang',
    fontWeight: FontWeight.bold,
    fontSize: 24,
    color: primaryColor,
  );

  static const TextStyle body = TextStyle(
    fontFamily: 'AlegreyaSans',
    fontSize: 16,
    color: primaryGreyScale,
  );

  static const TextStyle cardText = TextStyle(
    fontFamily: 'AlegreyaSans',
    fontSize: 14,
    color: primaryGreyScale,
  );
}

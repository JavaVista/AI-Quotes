import 'package:ai_quotes_app/models/quote.dart';
import 'package:ai_quotes_app/theme/colors.dart';
import 'package:ai_quotes_app/theme/typography.dart';
import 'package:flutter/material.dart';

void showAddOccupationDialog(
    BuildContext context, Quote quote, Function(Quote) onOccupationAdded) {
  final TextEditingController occupationController = TextEditingController();

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
                'Add Occupation',
                style: AppTypography.heading,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: occupationController,
                decoration: const InputDecoration(
                  labelText: 'Occupation',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              final updatedQuote = quote.copyWith(
                occupation: occupationController.text.isEmpty
                    ? 'Unknown'
                    : occupationController.text,
              );
              onOccupationAdded(updatedQuote); // Call the callback function
              Navigator.of(dialogContext).pop();
            },
            child: const Text('Add', style: AppTypography.body),
          ),
          TextButton(
            onPressed: () {
              occupationController.clear();
              Navigator.of(dialogContext).pop();
            },
            child: const Text('Cancel', style: AppTypography.body),
          ),
        ],
      );
    },
  );
}

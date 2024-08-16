import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart' as custom_colors;

void showErrorDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: custom_colors.darkGray,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Login Failed',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text(
              'OK',
              style: TextStyle(color: custom_colors.accentGreen),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}




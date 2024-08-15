import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart' as custom_colors;

class ScanSuccessfulScreen extends StatelessWidget {
  static const routeName = '/scan-successful-screen';
  const ScanSuccessfulScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: custom_colors.primaryBackground,
        child: Center(
          child: Text(
            "Scan Succesful",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:reclaim/core/theme/colors.dart' as custom_colors;
import 'package:reclaim/features/dashboard/presentation/screens/donating_screen.dart'; // Import the Donating screen

class DonationBox extends StatelessWidget {
  final String imagePath;
  final String title;
  final double progressValue;
  final String progressText;
  final String category;

  const DonationBox({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.progressValue,
    required this.progressText,
    required this.category,
  }) : super(key: key);

  void _openDetailScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DonatingScreen(
          imagePath: imagePath,
          title: title,
          progressText: progressText,
          progressValue: progressValue,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: 350,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => _openDetailScreen(context),
            child: Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progressValue,
              backgroundColor: Colors.grey[300],
              color: custom_colors.accentGreen,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            progressText,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

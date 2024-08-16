import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart' as custom_colors;

class MainBalanceCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double remainingBudget = 5000; //Change
    DateTime todayDate = DateTime.now();
    int lastDateOfTheMonth =
        DateTime(todayDate.year, todayDate.month + 1, 0).day;
    String formattedFinalDate =
        '$lastDateOfTheMonth/${todayDate.month}/${todayDate.year}';

    return Container(
      padding: const EdgeInsets.all(20),
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage('assets/images/card_background.png'),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(16),
          color: custom_colors.darkGray),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Current balance',
            style:
                TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14),
          ),
          Text(
            'RM${remainingBudget.toString()}',
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600, fontSize: 30),
          ),
          Text(
            'until $formattedFinalDate',
            style:
                TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14),
          ),
        ],
      ),
    );
  }
}

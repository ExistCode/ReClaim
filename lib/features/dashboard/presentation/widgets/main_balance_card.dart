import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart' as custom_colors;

class MainBalanceCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double currentBal = 8.23347; //Change
    String walletAddress =
        "0x1bcdd770a0bffb23cbad2de13ff89f0275180bd3feb7f421a2b330f6e0b5db72";

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
            'Your Wallet',
            style:
                TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14),
          ),
          Text(
            '${currentBal.toString()} RCLM',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600, fontSize: 32),
          ),
          Text(
            'Address: ${walletAddress}',
            style:
                TextStyle(color: Colors.white.withOpacity(0.2), fontSize: 10),
          ),
        ],
      ),
    );
  }
}

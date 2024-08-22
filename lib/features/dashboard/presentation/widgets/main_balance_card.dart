import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reclaim/features/dashboard/presentation/providers/balance_provider.dart';
import '../../../../core/models/app_user.dart';
import '../../../../core/theme/colors.dart' as custom_colors;

class MainBalanceCard extends StatelessWidget {
  final AppUser user;
  
  
  MainBalanceCard({required this.user});

  @override
  Widget build(BuildContext context) {
    String walletAddress =
        user.walletAddress.toString();
    String lifetimeEarnings = user.walletBalance.toString();

    return Consumer<BalanceProvider>(
      builder: (context, balanceProvider, _) {
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
            color: custom_colors.darkGray,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your Wallet',
                style: TextStyle(
                    color: Colors.white.withOpacity(0.7), fontSize: 14),
              ),
              Text(
                '${lifetimeEarnings != ""? lifetimeEarnings : 0.0} RCLM',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 32,
                ),
              ),
              Text(
                'Address: ${walletAddress != ""? walletAddress : "Not available"}',
                style: TextStyle(
                    color: Colors.white.withOpacity(0.2), fontSize: 10),
              ),
            ],
          ),
        );
      },
    );
  }
}

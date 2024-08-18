import 'dart:async';

import 'package:flutter/material.dart';
import 'package:reclaim/core/models/app_user.dart';
import 'package:reclaim/features/barcode-scan/data/models/transaction_model.dart';
import 'package:reclaim/features/barcode-scan/presentation/providers/transaction_provider.dart';
import 'package:reclaim/features/dashboard/presentation/widgets/main_balance_card.dart';
import '../../../../core/theme/colors.dart' as custom_colors;

import 'package:draggable_bottom_sheet/draggable_bottom_sheet.dart';
import '../../../../core/navigation/navigation.dart';
import '../widgets/main_menu_action_button.dart';
import '../widgets/recent_transaction_card.dart';

class DashboardScreen extends StatefulWidget {
  static const routeName = '/dashboard-screen';
  final AppUser user;
  DashboardScreen({required this.user});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}
class _DashboardScreenState extends State<DashboardScreen> {
  TransactionProvider _transactionProvider = TransactionProvider();

  @override
  Widget build(BuildContext context) {
    AppUser user = widget.user;
    print("In dashboard screen: ${user.email}");

    return StreamBuilder<List<TransactionModel>>(
      stream: _transactionProvider.getTransactionsStream(user.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        List<TransactionModel> transactions = snapshot.data ?? [];
        double lifetimeEarnings = calculateLifetimeEarnings(transactions);
        int lifetimeRecycledItems =
            calculateLifetimeRecycledItems(transactions);

        return Container(
          color: custom_colors.primaryBackground,
          width: double.infinity,
          height: double.infinity,
          child: RefreshIndicator(
            color: custom_colors.accentGreen,
            onRefresh: () async {
              // Refresh logic if needed
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      MainBalanceCard(userWalletAddress: user.walletAddress ?? '0x1bcdd770a0bffb23cbad2de13ff89f0275180bd3feb7f421a2b330f6e0b5db72', lifetimeEarnings: lifetimeEarnings,),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
                Expanded(
                  child: DraggableBottomSheet(
                    minExtent: 110,
                    barrierColor: Colors.transparent,
                    curve: Curves.easeIn,
                    expansionExtent: 0.5,
                    onDragging: (pos) {},
                    previewWidget: RecentTransactionsCard(user: user),
                    expandedWidget: ExpandedRecentTransactionsCard(user: user),
                    backgroundWidget: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ... (keep existing widgets)
                          Text(
                            'Lifetime Earnings',
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 16),
                          ),
                          const SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '$lifetimeEarnings RCLM',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 26,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '$lifetimeRecycledItems items recycled',
                                style: TextStyle(
                                  color: custom_colors.accentGreen,
                                  fontSize: 16,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  double calculateLifetimeEarnings(List<TransactionModel> transactions) {
    return transactions.fold(
        0.0, (sum, transaction) => sum + transaction.pointsRedeemed);
  }

  int calculateLifetimeRecycledItems(List<TransactionModel> transactions) {
    return transactions.fold(
        0,
        (sum, transaction) =>
            sum +
            transaction.numOfCan +
            transaction.numOfCartons +
            transaction.numOfPlastic);
  }
}

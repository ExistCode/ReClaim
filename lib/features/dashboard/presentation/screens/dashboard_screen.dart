import 'dart:async';

import 'package:flutter/material.dart';
import 'package:reclaim/core/models/app_user.dart';
import 'package:reclaim/features/barcode-scan/data/models/transaction_model.dart';
import 'package:reclaim/features/barcode-scan/presentation/providers/transaction_provider.dart';
import 'package:reclaim/features/dashboard/presentation/providers/balance_provider.dart';
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
  BalanceProvider _balanceProvider = BalanceProvider();
  double lifetimeEarnings = 0.00;
  int lifetimeRecycledItems = 0;

  @override
  void initState() {
    super.initState();
    _fetchUserTransactions();
  }

  Future<void> _fetchUserTransactions() async {
    // Fetch transactions specifically for the logged-in user
    await _transactionProvider.fetchTransactionsByUserId(widget.user.uid);
    // Calculate fields after fetching
    _calculateEarnings();
    // Use the fetched transaction data in your page
    _displayTransactionDetails();
  }

  void _displayTransactionDetails() {
    // Access the fetched transaction data from _transactionProvider.loadedTransactionList
    if (_transactionProvider.loadedTransactionList.isEmpty) {
      print("No transactions found.");
    } else {
      // Display the transaction details in your page
      print(
          "Sample fetched transaction points redeemed: ${_transactionProvider.loadedTransactionList[0].pointsRedeemed}");
    }
  }

  void _calculateEarnings() {
    AppUser user = widget.user;

    double templifetimeEarnings = 0.0;
    int templifetimeRecycledItems = 0;

    for (var transaction in _transactionProvider.loadedTransactionList) {
      try {
        // Only calculate for the current user's transactions
        if (transaction.userId == user.uid) {
          templifetimeEarnings += transaction.pointsRedeemed;
          templifetimeRecycledItems += transaction.numOfCan +
              transaction.numOfCartons +
              transaction.numOfPlastic;

          print("Current earnings: ${templifetimeEarnings}");
        }
      } catch (e) {
        print("Can't Calculate!! The error message is $e");
      }
    }

    // Call setState to update the UI after calculations
    setState(() {
      lifetimeEarnings = templifetimeEarnings;
      lifetimeRecycledItems = templifetimeRecycledItems;
    });

    _balanceProvider.fetchDashboardData(templifetimeEarnings, templifetimeRecycledItems);

    print("The total points earned: $lifetimeEarnings");
    print("The total recycled items: $lifetimeRecycledItems");
  }

  // Get BottomNavBar from GlobalKey to access onTap
  BottomNavigationBar get navigationBar {
    return NavigationState.globalKey.currentWidget as BottomNavigationBar;
  }

  @override
  Widget build(BuildContext context) {
    AppUser user = widget.user;
    print("In dashboard screen: ${user.email}");

    return Container(
      color: custom_colors.primaryBackground,
      width: double.infinity,
      height: double.infinity,
      child: RefreshIndicator(
        color: custom_colors.accentGreen,
        onRefresh: () async {
          return Future<void>.delayed(
            const Duration(seconds: 1),
            (() {
              // You can add refresh logic here if needed
            }),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  MainBalanceCard(),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            child: const MainMenuActionButton(
                              'Insight',
                              custom_colors.accentGreen,
                              Icons.bar_chart,
                            ),
                            onTap: () {
                              navigationBar.onTap!(1);
                            },
                          ),
                          GestureDetector(
                            child: const MainMenuActionButton(
                                'Adjust',
                                custom_colors.accentGreenVariant,
                                Icons.settings),
                          ),
                        ],
                      ),
                      const SizedBox(height: 60),
                      Text(
                        'Lifetime Earnings',
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.8), fontSize: 16),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${lifetimeEarnings} RCLM',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            '$lifetimeRecycledItems items recycled',
                            style: TextStyle(
                                color: custom_colors.accentGreen, fontSize: 16),
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
  }
}
